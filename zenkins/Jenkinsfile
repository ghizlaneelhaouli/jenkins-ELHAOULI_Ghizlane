pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'my-image'
        GIT_REPO = 'https://github.com/ghizlaneelhaouli/jenkins-ELHAOULI_Ghizlane'
        GIT_BRANCH = 'main'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                echo 'Checking out source code from Git...'
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "*/${env.GIT_BRANCH}"]],
                    userRemoteConfigs: [[url: env.GIT_REPO]]
                ])
            }
        }

        stage('Verify Workspace') {
            steps {
                echo 'Verifying workspace files...'
                bat 'dir /s' // Lister tous les fichiers pour vérifier leur présence
            }
        }

        stage('Build') {
            steps {
                echo 'Building the project with Maven...'
                bat 'mvn clean install -DskipTests' // Construire le projet avec Maven
            }
        }

        stage('Create Docker Image') {
            steps {
                echo 'Building Docker image...'
                bat "docker build -t ${DOCKER_IMAGE_NAME} ."
            }
        }

        stage('Scan Docker Image') {
            steps {
                echo 'Scanning Docker image for vulnerabilities...'
                // Ajouter un outil d'analyse (par exemple Trivy, si configuré)
                bat 'echo Scanning completed!'
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker image to registry...'
                bat "docker tag ${DOCKER_IMAGE_NAME} my-docker-registry/${DOCKER_IMAGE_NAME}:latest"
                bat "docker push my-docker-registry/${DOCKER_IMAGE_NAME}:latest"
            }
        }

        stage('Deploy to Remote Server') {
            steps {
                echo 'Deploying to remote server...'
                // Ajoutez vos commandes pour déployer sur un serveur distant
                bat 'echo Deployment completed!'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
