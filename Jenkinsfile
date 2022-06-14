pipeline {
    agent any
    options {
        ansiColor('xterm')
        timestamps {
            stages {
                    stage('Build') {
                        steps {
                            sh 'echo "empieza en "$BUILD_TIMESTAMP'
                            sh 'docker-compose build'
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
    }

    
}