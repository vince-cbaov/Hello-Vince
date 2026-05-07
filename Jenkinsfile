pipeline {
    agent any

    environment {
        APP_SERVER = "vinadmin@20.123.4.115"
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
                sh '''
                ssh -o StrictHostKeyChecking=no vinadmin@20.123.4.115 '
                    cd /tmp &&
                    rm -rf hello-vince &&
                    git clone https://github.com/vince-cbaov/Hello-Vince.git hello-vince &&
                    cd hello-vince &&
                    docker stop hello-vince || true &&
                    docker rm hello-vince || true &&
                    docker build -t hello-vince:latest . &&
                    docker run -d --name hello-vince -p 80:80 hello-vince:latest
                '
                '''
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