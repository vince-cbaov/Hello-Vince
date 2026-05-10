pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        IMAGE_NAME = "hello-vince"
        IMAGE_TAG  = "latest"

        // main → 80, others → 8081
        APP_PORT = "${BRANCH_NAME == 'main' ? '80' : '8081'}"
    }

    stages {

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
                    docker rm -f healthcheck || true
                    docker run -d --name healthcheck ${IMAGE_NAME}:${IMAGE_TAG}

                    echo "Waiting for container to become ready..."

                    i=1
                    while [ $i -le 10 ]; do
                        if docker exec healthcheck wget -qO- http://localhost >/dev/null 2>&1; then
                            echo " Container is healthy"
                            break
                        fi
                        echo " Not ready yet (attempt $i)"
                        i=$((i+1))
                        sleep 2
                    done

                    docker exec healthcheck wget -qO- http://localhost
                    docker rm -f healthcheck
                '''
            }
        }

        stage('Deploy to App Server') {
            when {
                expression { env.BRANCH_NAME?.trim() }
            }
            steps {
                sshagent(['app-server-ssh']) {
                    sh """
                      ssh -o StrictHostKeyChecking=no vinadmin@${APP_SERVER} '
                        set -e
                        APP_NAME=hello-vince
                        BRANCH_NAME=${BRANCH_NAME}
                        APP_PORT=${APP_PORT}

                        rm -rf /tmp/hello-vince
                        git clone https://github.com/vince-cbaov/Hello-Vince.git /tmp/hello-vince
                        cd /tmp/hello-vince

                        docker stop \$APP_NAME-\$BRANCH_NAME || true
                        docker rm \$APP_NAME-\$BRANCH_NAME || true

                        docker build -t \$APP_NAME:latest .

                        docker run -d \
                          --name \$APP_NAME-\$BRANCH_NAME \
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