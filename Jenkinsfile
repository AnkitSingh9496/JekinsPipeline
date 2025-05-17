pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPO = 'circleci'
        ECR_REGISTRY = '244706281787.dkr.ecr.ap-south-1.amazonaws.com'
        IMAGE_TAG = "${env.BUILD_ID}"
        DOCKER_IMAGE = "${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}"
    }

    tools {
        nodejs 'NodeJS_16' // Must match name in Jenkins → Global Tool Configuration
    }

    stages {

        stage('Clone Repo') {
            steps {
                echo 'Cloning repository...'
                git branch: 'main', url: 'https://github.com/AnkitSingh9496/JekinsPipeline.git'
            }
        }

        stage('Verify Files') {
            steps {
                echo 'Checking workspace contents...'
                sh 'ls -la'
                sh 'cat package.json || echo "package.json missing!"'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Installing Node.js dependencies...'
                sh 'npm install'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image ${DOCKER_IMAGE}..."
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                echo 'Authenticating with Amazon ECR...'
                sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
            }
        }

        stage('Push Image to ECR') {
            steps {
                echo 'Pushing Docker image to Amazon ECR...'
                sh "docker push ${DOCKER_IMAGE}"
            }
        }

        stage('Deploy to Amazon EKS') {
            steps {
                echo 'Deploying to EKS...'
                script {
                    // Replace the placeholder in deployment.yaml with the actual image path
                    sh "sed -i 's|<replace-me-later>|${DOCKER_IMAGE}|' k8s/deployment.yaml"

                    // Apply Kubernetes manifests (make sure deployment.yaml and service.yaml are in k8s/)
                    sh "kubectl apply -f k8s/"
                }
            }
        }
    }
}


// pipeline {
//     agent any

//     tools {
//         nodejs 'NodeJS_16' 
//     }

//     stages {
//         stage('Clone Repo') {
//             steps {
//                 echo 'Cloning repo...'
//                 git branch: 'main', url: 'https://github.com/AnkitSingh9496/JekinsPipeline.git'
//             }
//         }

//         stage('Install Dependencies') {
//             steps {
//                 echo 'Installing dependencies...'
//                 sh 'npm install'
//             }
//         }

//         stage('Run App') {
//             steps {
//                 echo 'Starting app...'
//                 sh 'node index.js &'
//                 sh 'sleep 5'
//             }
//         }
//     }
// }
