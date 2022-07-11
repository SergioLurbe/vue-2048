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
    /*
        stage('Scan') {
            steps {
                parallel(
                   a:{ sh "trivy image -f json -o results-image.json sergiolurbe/2048:latest"
                   recordIssues(tools: [trivy(pattern: 'results-image.json')])},
                   b:{sh "trivy fs --security-checks vuln,secret,config -f json -o results-fs.json ./"
                   recordIssues(tools: [trivy(pattern: 'results-fs.json')])}
               )
            }
        }
        */
        /*
        stage('Parallel Stage') {
                    when {
                        branch 'main'
                    }
                    failFast true
                    parallel {
                        stage('Trivy'){
                            steps{
                                sh 'trivy fs -f json -o results.json .'
                              }
                            post {
                              success {
                                  recordIssues(tools: [trivy(pattern: 'result.json')])
                              }
                            }
                        }
                        stage('Trivy Image') {
                            steps {
                                sh 'trivy image -f json -o results.json 2048'
                            }
                            post {
                              success {
                                  recordIssues(tools: [trivy(pattern: 'result.json')])
                              }
                            }
                        }
                    }
                }

        */
        stage('Publish') {
            steps {
                sshagent(['github-ssh']) {
                    sh 'git tag BUILD-1.0.${BUILD_NUMBER}'
                    sh 'git push --tags'
                }

                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'token', usernameVariable: 'username')]) {
                    sh "echo '${token}' | docker login -u '${username}' --password-stdin"
                    sh 'docker push sergiolurbe/2048:latest'
                    
                }

            }
        }

        stage('GitContainer') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockergit', passwordVariable: 'gitPassword', usernameVariable: 'gitUsername')]) {
                    sh "echo '${gitPassword}' | docker login ghcr.io -u '${gitUsername}' --password-stdin"
                    sh 'docker push ghcr.io/sergiolurbe/2048:latest'
                    sh 'docker tag ghcr.io/sergiolurbe/2048:latest  ghcr.io/sergiolurbe/2048:1.0.${BUILD_NUMBER}'
                    sh 'docker push ghcr.io/sergiolurbe/2048:1.0.${BUILD_NUMBER}'
                }
            }
        }

       stage('Ansible'){
            when {
                expression {
                    False
                }

            }
                steps {
                        withAWS(credentials: 'afcdcf40-dbfb-450b-b486-84b89ca82433', region: 'eu-west-1') {
                            sh 'terraform -chdir=terraform init'
                            sh 'terraform -chdir=terraform apply --auto-approve'
                            ansiblePlaybook credentialsId: 'key', inventory: 'ansible2/aws_ec2.yml', disableHostKeyChecking: true, playbook: 'ansible2/ec2-provision.yml', extras: '-vv'

                        }

                }
       }

        stage ('kube') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'minikube', contextName: '', credentialsId: 'kubekey', namespace: 'default', serverUrl: 'https://192.168.49.2:8443') {
                    sh 'kubectl apply -f kubernetes/vue2048.yml'
                }
            }
        }

    }
    
}