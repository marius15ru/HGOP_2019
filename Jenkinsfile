node {
    def git = checkout scm
    stage("Build") {
        ssh "./scripts/docker_build.sh ${git.GIT_COMMIT}"
        ssh "./scripts/docker_push.sh ${git.GIT_COMMIT}"
    }
}