pipeline {
    agent any
    stages {
        stage('Build') {
            sh 'docker-compose build'
        }
    }
    stage('Publish') {
        sh 'git push --tags'
    }
}