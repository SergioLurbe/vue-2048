pipeline {
    agent any
    options {
        ansiColor('xterm')
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }

    stages {




        stage('Build') {
            steps {
                sh 'docker-compose build'
            }
        }

        stage('Trivy') {
                steps {
                    sh 'trivy image -f json -o results.json vue-2048'
                    recordIssues(tools: [trivy()])
                }
        }

        stage('Publish') {
            steps {
                sshagent(['github-ssh']) {
                    //sh 'git tag BUILD-1.0.$(BUILD_NUMBER)'
                    sh 'git push --tags'
                }
            }
        }


    }
    
}