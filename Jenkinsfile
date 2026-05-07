pipeline {
    agent any

    options {
        timestamps()
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building Hello-Vince project...'
                sh 'ls -la'
            }
        }

        stage('Test') {
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
