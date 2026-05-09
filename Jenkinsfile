pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        IMAGE_NAME = "hello-vince"
        IMAGE_TAG  = "latest"
        APP_SERVER = "app_server_ip_or_hostname"
        APP_NAME   = "hello-vince"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Unit Tests (pytest)') {
            steps {
                echo 'Running Python unit tests...'
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install -r requirements.txt
                    pytest
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Container Health Check') {
            steps {
                echo 'Starting container for health check...'
                sh '''
                    docker rm -f healthcheck || true
                    docker run -d --name healthcheck -p 18080:80 ${IMAGE_NAME}:${IMAGE_TAG}
                    sleep 5
                    curl -f http://localhost:18080 || exit 1
                    docker rm -f healthcheck
                '''
            }
        }

        stage('Deploy to App Server') {
            steps {
                sshagent(['app-server-ssh']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no vinadmin@${APP_SERVER_IP} '
                            set -e
                            rm -rf /tmp/hello-vince
                            git clone https://github.com/vince-cbaov/Hello-Vince.git /tmp/hello-vince
                            cd /tmp/hello-vince
                            docker stop ${APP_NAME} || true
                            docker rm ${APP_NAME} || true
                            docker build -t ${APP_NAME}:latest .
                            docker run -d --name ${APP_NAME} -p 80:80 ${APP_NAME}:latest
                        '
                    """
                }
            }
        }
    }

    post {
        success {
            echo ' CI/CD pipeline completed successfully'
        }
        failure {
            echo ' CI/CD pipeline failed'
        }
        always {
            echo 'Pipeline finished'
        }
    }
}