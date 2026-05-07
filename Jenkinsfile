pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        APP_SERVER = "vinadmin@20.123.4.115"
        APP_NAME   = "hello-vince"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Deploy to App Server') {
            steps {
                sshagent(['app-server-ssh']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${APP_SERVER} '
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
            echo ' Deployment completed successfully'
        }
        failure {
            echo ' Deployment failed'
        }
    }
}
