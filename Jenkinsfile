pipeline {
    agent any

    tools {
        nodejs 'NodeJS_16' 
    }

    stages {
        stage('Clone Repo') {
            steps {
                echo 'Cloning repo...'
                git 'https://github.com/AnkitSingh9496/JekinsPipeline.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Installing dependencies...'
                sh 'npm install'
            }
        }

        stage('Run App') {
            steps {
                echo 'Starting app...'
                sh 'node index.js &'
                sh 'sleep 5'
            }
        }
    }
}
