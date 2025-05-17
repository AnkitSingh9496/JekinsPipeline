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
        stage('Verify Tools') {
            steps {
                echo 'Verifying required tools...'
                powershell '''
                    $tools = @("docker", "aws", "kubectl")
                    $missingTools = @()
                    
                    foreach ($tool in $tools) {
                        try {
                            $null = Get-Command $tool -ErrorAction Stop
                            Write-Host "$tool is installed"
                        } catch {
                            $missingTools += $tool
                        }
                    }
                    
                    if ($missingTools.Count -gt 0) {
                        Write-Error "The following required tools are missing: $($missingTools -join ', ')"
                        Write-Error "Please install the missing tools and ensure they are in the system PATH"
                        exit 1
                    }
                '''
            }
        }

        stage('Clone Repo') {
            steps {
                echo 'Cloning repository...'
                git branch: 'main', url: 'https://github.com/AnkitSingh9496/JekinsPipeline.git'
            }
        }

        stage('Verify Files') {
            steps {
                echo 'Checking workspace contents...'
                powershell 'Get-ChildItem -Force'
                powershell '''
                    if (Test-Path package.json) {
                        Get-Content package.json
                    } else {
                        Write-Error "package.json not found!"
                        exit 1
                    }
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Installing Node.js dependencies...'
                powershell 'npm install'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image ${DOCKER_IMAGE}..."
                powershell '''
                    try {
                        # Get the current directory
                        $currentDir = Get-Location
                        Write-Host "Building Docker image from directory: $currentDir"
                        
                        # Verify Dockerfile exists
                        if (-not (Test-Path "Dockerfile")) {
                            Write-Error "Dockerfile not found in the current directory"
                            exit 1
                        }
                        
                        # Build the Docker image
                        docker build -t ${DOCKER_IMAGE} "$currentDir"
                    } catch {
                        Write-Error "Failed to build Docker image. Error: $_"
                        Write-Error "Please ensure Docker is running and you have the necessary permissions"
                        exit 1
                    }
                '''
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                echo 'Authenticating with Amazon ECR...'
                powershell '''
                    try {
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    } catch {
                        Write-Error "Failed to authenticate with ECR. Error: $_"
                        Write-Error "Please ensure AWS credentials are properly configured"
                        exit 1
                    }
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                echo 'Pushing Docker image to Amazon ECR...'
                powershell '''
                    try {
                        docker push ${DOCKER_IMAGE}
                    } catch {
                        Write-Error "Failed to push Docker image. Error: $_"
                        exit 1
                    }
                '''
            }
        }

        stage('Deploy to Amazon EKS') {
            steps {
                echo 'Deploying to EKS...'
                script {
                    powershell '''
                        try {
                            # Replace the placeholder in deployment.yaml
                            (Get-Content k8s/deployment.yaml) -replace '<replace-me-later>', '${DOCKER_IMAGE}' | Set-Content k8s/deployment.yaml
                            
                            # Apply Kubernetes manifests
                            kubectl apply -f k8s/
                        } catch {
                            Write-Error "Failed to deploy to EKS. Error: $_"
                            exit 1
                        }
                    '''
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
