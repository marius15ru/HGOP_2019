node {
    def git = checkout scm
    stage("Clean"){
        echo 'I solemnly swear that I know not to run this without committing changes I want to keep!'
        sh "cd game_api && git clean -dfxq"
        sh "cd game_api && git stash"
    }
    stage("Setup"){
        sh "cd game_api && npm install"
    }
    stage("Lint"){
        sh "cd game_api && npm run eslint"
    }
    stage("Build") {
        sh "./scripts/docker_build.sh ${git.GIT_COMMIT}"
        withCredentials([usernamePassword( credentialsId: 'docker_hub_creds', usernameVariable: 'USER', passwordVariable: 'PASSWORD')]){
            sh "docker login -u $USER -p $PASSWORD"
        }
        sh "./scripts/docker_push.sh ${git.GIT_COMMIT}"
    }
    stage("Deploy") {
        sh "./scripts/sync_session.sh"
        sh "./scripts/jenkins_deploy.sh"
    }
}
