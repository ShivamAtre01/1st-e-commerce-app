pipeline {
    agent { label 'dev' }

    environment {
        IMAGE_NAME = "top017/app"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Clone Repository') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/ShivamAtre01/1st-e-commerce-app.git'
            }
        }
        stage('Trivy Filesystem Scan') {
            steps {
                sh 'trivy fs .'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build --cpu-quota=100000 --cpu-period=100000 --memory='1200m' -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
            }
        }
        stage('Trivy Scan') {
            steps {
                sh '''
                trivy image \
                --severity HIGH,CRITICAL \
                --exit-code 0 \
                --skip-version-check \
                ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Push Image To Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

                    docker push top017/app:${BUILD_NUMBER}
                    docker push top017/app:latest
                    '''
                }
            }
        }

        stage('Deploy Using Docker Compose') {
            steps {
                sh 'docker compose down'
                sh 'docker compose pull'
                sh 'docker compose up -d'
            }
        }
    }
}
