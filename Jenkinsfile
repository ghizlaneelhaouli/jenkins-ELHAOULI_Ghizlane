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
                    def imageName = "ghizlaneelhaouli/jenkins-elhaouli_ghizlane:latest"
                    sh "docker build -t ${imageName} ."
                }
            }
        }
        stage('Scan Docker Image') {
            steps {
                script {
                    def imageName = "ghizlaneelhaouli/jenkins-elhaouli_ghizlane:latest"
                    sh "docker scout cves ${imageName}"
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    def imageName = "ghizlaneelhaouli/jenkins-elhaouli_ghizlane:latest"
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-ghizlane', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                        sh "docker push ${imageName}"
                    }
                }
            }
        }
        stage('Deploy to Remote Server') {
            steps {
                script {
                    def imageName = "ghizlaneelhaouli/jenkins-elhaouli_ghizlane:latest"
                    sshagent(['remote-server-credentials-ghizlane']) {
                        sh """
                        ssh ghizlane@remote-server "
                            docker pull ${imageName} &&
                            docker rm -f app-container || true &&
                            docker run -d --name app-container -p 8989:80 ${imageName}
                        "
                        """
                    }
                }
            }
        }
    }
}
