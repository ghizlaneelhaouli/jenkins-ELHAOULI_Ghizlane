pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
        stage('Test') {
            steps {
                echo 'Running Tests...'
            }
        }
        stage('Create Docker Image') {
            steps {
                script {
                    def imageName = "teemo156/testjenkins:latest"
                    sh "docker build -t ${imageName} ."
                }
            }
        }
        stage('Scan Docker Image') {
            steps {
                script {
                    def imageName = "teemo156/testjenkins:latest"
                    sh "docker scout cves ${imageName}"
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    def imageName = "teemo156/testjenkins:latest"
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                        sh "docker push ${imageName}"
                    }
                }
            }
        }
        stage('Deploy to Remote Server') {
            steps {
                script {
                    def imageName = "teemo156/testjenkins:latest"
                    sshagent(['remote-server-credentials-id']) {
                        sh """
                        ssh user@remote-server "
                            docker pull ${imageName} &&
                            docker run -d --name app-container -p 80:80 ${imageName}
                        "
                        """
                    }
                }
            }
        }
    }
}
