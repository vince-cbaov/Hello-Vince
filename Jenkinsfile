pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        IMAGE_NAME = "hello-vince"
        IMAGE_TAG  = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image for Hello-Vince...'
                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Verify Image') {
            steps {
                echo 'Verifying Docker image...'
                sh '''
                    docker images | grep ${IMAGE_NAME}
                '''
            }
        }

        stage('Test (placeholder)') {
            steps {
                echo 'Running tests (placeholder)...'
                echo 'No tests defined yet'
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
        always {
            echo 'Pipeline finished'
        }
    }
}