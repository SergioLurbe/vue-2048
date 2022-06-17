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
                sh 'trivy image -f json -o result.json vue-2048:latest'
                recordIssues(tools: [trivy(pattern: 'result.json')])
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