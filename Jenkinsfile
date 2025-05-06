pipeline {
    agent any

    tools {
        nodejs 'NodeJS_16' 
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/your-username/node-demo.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run App') {
            steps {
                sh 'npm start &'
                sh 'sleep 5'
            }
        }
    }
}
