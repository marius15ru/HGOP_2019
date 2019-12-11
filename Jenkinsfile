node {
    def git = checkout scm
    stage("Clean") {
        sh "git clean -dfxq"
        sh "git stash"
    }
    stage("Setup") {
        dir("game_api") {
            sh "npm install"
        }
    }
    stage("Lint") {
        dir("game_api") {
            sh "npm run eslint"
        }
    }
    stage("Test") {
        dir("game_api") {
            sh "npm run test:unit"
        }
    }
    step([
        $class: 'CloverPublisher',
        cloverReportDir: 'coverage',
        cloverReportFileName: 'clover.xml',
        healthyTarget: [methodCoverage: 80, conditionalCoverage: 80, statementCoverage: 80],
        unhealthyTarget: [methodCoverage: 50, conditionalCoverage: 50, statementCoverage: 50],
        failingTarget: [methodCoverage: 0, conditionalCoverage: 0, statementCoverage: 0]
    ])
    stage("Build") {
        sh "./scripts/docker_build.sh ${git.GIT_COMMIT}"
        sh "./scripts/docker_push.sh ${git.GIT_COMMIT}"
    }

    stage("API Test") {
        script {
            env.TEST_ENV = 'apitest'
        }
        sh "./scripts/jenkins_deploy.sh ${git.GIT_COMMIT} ${env.TEST_ENV}"
        dir("game_api") {
            sh "API_URL=http://localhost:3000 npm run test:api"
        }
        dir("/var/lib/jenkins/terraform/hgop/${env.TEST_ENV}"){
            sh "terraform destroy -auto-approve -var environment=${env.TEST_ENV} || exit 1"
        }
    }
    stage("Capacity Test") {
        script {
            env.TEST_ENV = 'capacitytest'
        }
        sh "./scripts/jenkins_deploy.sh ${git.GIT_COMMIT} ${env.TEST_ENV}"
        dir("game_api") {
            sh "API_URL=http://localhost:3000 npm run test:capacity"
        }
        dir("/var/lib/jenkins/terraform/hgop/${env.TEST_ENV}"){
            sh "terraform destroy -auto-approve -var environment=${env.TEST_ENV} || exit 1"
        }
    }
    stage("Deploy") {
        sh "./scripts/jenkins_deploy.sh ${git.GIT_COMMIT} production"
    }
}
