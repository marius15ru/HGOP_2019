node {
    def git = checkout scm
    stage("Build") {
        sh "./scripts/docker_build.sh ${git.GIT_COMMIT}"
        sh "./scripts/docker_push.sh ${git.GIT_COMMIT}"

        echo 'I solemnly swear that I know not to run this without committing changes I want to keep!'
        sh "cd game_api && git clean -dfxq"
        sh "cd game_api && git stash"
        sh "cd game_api && npm install"
        sh "cd game_api && npm run eslint"
    }
}