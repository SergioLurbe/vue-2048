pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'docker-compose build'
            }
        }

        stage('Publish') {
            steps {
                sh 'git push --tags'
            }
        }

            
    }
    
}