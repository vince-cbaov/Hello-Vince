pipeline {
    agent any

    environment {
        APP_SERVER = "ubuntu@APP_SERVER_IP"
        IMAGE_NAME = "hello-vince:latest"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Deploy to App Server') {
            steps {
                sshagent(['app-server-ssh']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no $APP_SERVER '
                        docker stop hello-vince || true
                        docker rm hello-vince || true
                        docker run -d --name hello-vince -p 80:80 $IMAGE_NAME
                    '
                    """
                }
            }
        }
    }

    post {
        success {
            echo " App deployed successfully"
        }
        failure {
            echo " Deployment failed"
        }
    }
}