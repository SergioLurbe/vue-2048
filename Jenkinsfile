pipeline {
    agent any
    stages {
        steps('Build') {
            sh 'docker-compose build'
        }
    }
    steps('Publish') {
        sh 'git push --tags'
    }
}