pipeline {
    agent { label 'dev' }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/LondheShubham153/tws-e-commerce-app.git'
            }
        }

        stage('Check Files') {
            steps {
                sh 'pwd'
                sh 'ls -la'
            }
        }
    }
}
