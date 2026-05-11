pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        IMAGE_NAME = "hello-vince"
        IMAGE_TAG  = "latest"
        APP_SERVER = "20.234.122.187"
    }

    stages {
       stage('Init') {
            steps {
               script {
                if (env.BRANCH_NAME == 'main') {
                    env.APP_PORT = '80'
                    env.CONTAINER_NAME = env.IMAGE_NAME
                    env.ENVIRONMENT = 'prod'

                } else if (env.BRANCH_NAME == 'Dev') {
                    env.APP_PORT = '8081'
                    env.CONTAINER_NAME = "${env.IMAGE_NAME}-Dev"
                    env.ENVIRONMENT = 'dev'

                } else if (env.BRANCH_NAME == 'Feature-A') {
                    env.APP_PORT = '8082'
                    env.CONTAINER_NAME = "${env.IMAGE_NAME}-Feature-A"
                    env.ENVIRONMENT = 'feature'

                } else {
                    error "No port assigned for branch ${env.BRANCH_NAME}"
                }
            }
                echo "Branch: ${env.BRANCH_NAME}"
                echo "Environment: ${env.ENVIRONMENT}"
                echo "Container: ${env.CONTAINER_NAME}"
                echo "Port: ${env.APP_PORT}"
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Unit Tests (pytest)') {
            steps {
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
                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Container Health Check') {
            steps {
                sh '''
                    HC_CONTAINER="healthcheck-${BUILD_ID}"

                    docker rm -f $HC_CONTAINER || true

                    docker run -d \
                    --name $HC_CONTAINER \
                    -p ${APP_PORT}:80 \
                    ${IMAGE_NAME}:${IMAGE_TAG}

                    echo "Waiting for app on port ${APP_PORT}..."

                    for i in {1..15}; do
                    if curl -fs http://localhost:${APP_PORT} > /dev/null; then
                        echo "Container is healthy"
                        break
                    fi
                    sleep 2
                    done

                    # final assertion
                    curl -fs http://localhost:${APP_PORT}

                    docker rm -f $HC_CONTAINER
                '''
            }
        }

        stage('Deploy to App Server') {
            steps {
                sshagent(['app-server-ssh']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no vinadmin@${APP_SERVER} '
                        set -e
                        APP_NAME=${IMAGE_NAME}
                        CONTAINER_NAME=${CONTAINER_NAME}
                        APP_PORT=${APP_PORT}
                        BRANCH_NAME=${BRANCH_NAME}

                        rm -rf /tmp/hello-vince
                        git clone --branch \$BRANCH_NAME \
                        https://github.com/vince-cbaov/Hello-Vince.git /tmp/hello-vince
                        cd /tmp/hello-vince

                        docker stop \$CONTAINER_NAME || true
                        docker rm   \$CONTAINER_NAME || true

                        docker build -t \$APP_NAME:latest .

                        docker run -d \
                        --name \$CONTAINER_NAME \
                        -p \$APP_PORT:80 \
                        \$APP_NAME:latest
                    '
                    """
                }
            }
        }
    }

    post {
        success {
            echo "CI/CD pipeline completed successfully"
        }
        failure {
            echo "CI/CD pipeline failed"
        }
        always {
            echo "Pipeline finished"
        }
    }
}