pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '767397694961'
        ECR_REPO_NAME1 = 'jenkins-nodejs-image'
        ECR_REPO_NAME2 = 'jenkins-postgresql-image'
        ECR_REPO_NAME3 = 'jenkins-react-image'
        DOCKER_IMAGE_TAG = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Create ECR Repos') {
            steps {
                script {
                    // Her ECR reposu için repo oluşturma
                    sh '''
                    aws ecr create-repository --repository-name ${ECR_REPO_NAME1} --region ${AWS_REGION} || echo "Repo 1 zaten mevcut"
                    aws ecr create-repository --repository-name ${ECR_REPO_NAME2} --region ${AWS_REGION} || echo "Repo 2 zaten mevcut"
                    aws ecr create-repository --repository-name ${ECR_REPO_NAME3} --region ${AWS_REGION} || echo "Repo 3 zaten mevcut"
                    '''
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    // AWS ECR login işlemi
                    sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    '''
                }
            }
        }

        stage('Build and Push App 1 Docker Image') {
            steps {
                script {
                    // App1 için Docker image oluşturma ve ECR'a gönderme
                    dir('nodejs') { // App1 dosyalarının bulunduğu klasör
                        sh '''
                        docker build -t ${ECR_REPO_NAME1}:${DOCKER_IMAGE_TAG} .
                        docker tag ${ECR_REPO_NAME1}:${DOCKER_IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME1}:${DOCKER_IMAGE_TAG}
                        docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME1}:${DOCKER_IMAGE_TAG}
                        '''
                    }
                }
            }
        }

        stage('Build and Push App 2 Docker Image') {
            steps {
                script {
                    // App2 için Docker image oluşturma ve ECR'a gönderme
                    dir('postgresql') { // App2 dosyalarının bulunduğu klasör
                        sh '''
                        docker build -t ${ECR_REPO_NAME2}:${DOCKER_IMAGE_TAG} .
                        docker tag ${ECR_REPO_NAME2}:${DOCKER_IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME2}:${DOCKER_IMAGE_TAG}
                        docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME2}:${DOCKER_IMAGE_TAG}
                        '''
                    }
                }
            }
        }

        stage('Build and Push App 3 Docker Image') {
            steps {
                script {
                    // App3 için Docker image oluşturma ve ECR'a gönderme
                    dir('react') { // App3 dosyalarının bulunduğu klasör
                        sh '''
                        docker build -t ${ECR_REPO_NAME3}:${DOCKER_IMAGE_TAG} .
                        docker tag ${ECR_REPO_NAME3}:${DOCKER_IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME3}:${DOCKER_IMAGE_TAG}
                        docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME3}:${DOCKER_IMAGE_TAG}
                        '''
                    }
                }
            }
        }

        stage('Wait for Image Push') {
            steps {
                // Docker image'ların ECR'a itilmesinden sonra bekleme
                script {
                    sleep time: 30, unit: 'SECONDS'
                }
            }
        }

        stage('Deploy App with Ansible') {
            steps {
                script {
                    // Ansible playbook kullanarak deploy
                    sh '''
                    cd ansible/
                    ansible-playbook -i /home/ec2-user/Jenkins-Project/inventory_aws_ec2.yml playbook.yaml
                    '''
                }
            }
        }
    }
    post {
        always {
            // Cleanup işlemleri (opsiyonel)
            cleanWs()
        }
    }
}
