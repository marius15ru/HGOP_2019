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
    stage("Build") {
        sh "./scripts/docker_build.sh ${git.GIT_COMMIT}"
        sh "./scripts/docker_push.sh ${git.GIT_COMMIT}"
    }
    stage("Deploy") {
        sh "./scripts/jenkins_deploy.sh ${git.GIT_COMMIT}"
    }
}