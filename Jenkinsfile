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
                sh 'trivy fs --security-checks vuln,secret,config -f json -o result.json .'
                recordIssues(tools: [trivy(pattern: 'result.json')])
            }
        }

        stage('Scan') {
            steps {
                parallel(
                   a:{ sh "trivy image -f json -o results-image.json server-vue:latest"
                   recordIssues(tools: [trivy(pattern: 'results-image.json')])},
                   b:{sh "trivy fs --security-checks vuln,secret,config -f json -o results-fs.json ./"
                   recordIssues(tools: [trivy(pattern: 'results-fs.json')])}
               )
            }
        }



        stage('Publish') {
            steps {
                sshagent(['github-ssh']) {
                    //sh 'git tag BUILD-1.0.$(BUILD_NUMBER)'
                    sh 'git push --tags'
                }
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'token', usernameVariable: 'username')]) {
                    sh "echo '${token}' | docker login -u '${username}' --password-stdin"
                    sh 'docker push sergiolurbe/2048:latest'
                }
            }
        }


    }
    
}