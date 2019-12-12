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
        sh "./scripts/jenkins_deploy.sh ${git.GIT_COMMIT} apitest"
        sh "./scripts/test_deploy.sh ${git.GIT_COMMIT} api"
    }
    stage("Capacity Test") {
        sh "./scripts/jenkins_deploy.sh ${git.GIT_COMMIT} capacitytest"
        sh "./scripts/test_deploy.sh ${git.GIT_COMMIT} capacity"
    }
    stage("Deploy") {
        sh "./scripts/jenkins_deploy.sh ${git.GIT_COMMIT}"
    }
}
