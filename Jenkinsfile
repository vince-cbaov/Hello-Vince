pipeline {
    agent any

    /* ---------- PARAMETERS (rebuild-safe) ---------- */
    parameters {
        string(
            name: 'APP_SERVER',
            defaultValue: '',
            description: 'App server IP or DNS name (from Terraform output)'
        )
    }

    options {
        timestamps()
    }

    /* ---------- STATIC ENVIRONMENT VALUES ---------- */
    environment {
        IMAGE_NAME = "hello-vince"
        IMAGE_TAG  = "latest"
        APP_NAME   = "hello-vince"

        APP_PORT = "${BRANCH_NAME == 'main' ? '80' : '8081'}"
    }

    stages {

        /* ---------- CHECKOUT ---------- */
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        /* ---------- TESTS ---------- */
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

        /* ---------- BUILD ---------- */
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        /* ---------- HEALTH CHECK ---------- */
        stage('Container Health Check') {
            steps {
                    sh '''
                        docker rm -f healthcheck || true
                        docker run -d --name healthcheck -p ${APP_PORT}:80 ${IMAGE_NAME}:${IMAGE_TAG}
                        sleep 5
                        curl -f http://localhost:${APP_PORT}
                        docker rm -f healthcheck
                '''
            }
        }

        /* ---------- DEPLOY ---------- */
        stage('Deploy to App Server') {
            when {
                expression { params.APP_SERVER?.trim() }
            }
            steps {
                sshagent(['app-server-ssh']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no vinadmin@${APP_SERVER} '
                        set -e
                        APP_NAME=hello-vince

                        rm -rf /tmp/hello-vince
                        git clone https://github.com/vince-cbaov/Hello-Vince.git /tmp/hello-vince
                        cd /tmp/hello-vince

                        docker stop $APP_NAME || true
                        docker rm $APP_NAME || true
                        docker build -t $APP_NAME:latest .
                        docker run -d --name $APP_NAME -p 80:80 $APP_NAME:latest
                    '
                    '''
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