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
                    def imageName = "ghizlaneelhaouli/myproject:latest"
                    bat "docker build -t ${imageName} ."
                }
            }
        }
        stage('Scan Docker Image') {
            steps {
                script {
                    def imageName = "ghizlaneelhaouli/myproject:latest"
                    bat "docker scout cves ${imageName}"
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    def imageName = "ghizlaneelhaouli/myproject:latest"
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        bat """
                        echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                        docker push ${imageName}
                        """
                    }
                }
            }
        }
        stage('Deploy to Remote Server') {
            steps {
                script {
                    def imageName = "ghizlaneelhaouli/myproject:latest"
                    sshagent(['remote-server-credentials-id']) {
                        bat """
                        ssh user@remote-server "
                            docker pull ${imageName} &&
                            docker stop app-container || true &&
                            docker rm app-container || true &&
                            docker run -d --name app-container -p 8989:8989 ${imageName}
                        "
                        """
                    }
                }
            }
        }
    }
}
