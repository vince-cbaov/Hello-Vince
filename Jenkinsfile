pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        IMAGE_NAME = "hello-vince"
        IMAGE_TAG  = "latest"
        APP_SERVER = "vinadmin@20.123.4.115"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image on Jenkins...'
                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Deploy to App Server') {
            steps {
                sshagent(['app-server-ssh']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ${APP_SERVER} "
                            docker stop hello-vince || true
                            docker rm hello-vince || true
                            docker build -t hello-vince:latest /tmp/hello-vince || true
                            docker run -d --name hello-vince -p 80:80 hello-vince:latest
                        "
                    '''
                }
            }
        }
    }

    post {
        success {
            echo ' Pipeline completed successfully'
        }
        failure {
            echo ' Pipeline failed'
        }
    }
}