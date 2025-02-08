pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'partnership-petclinic.jfrog.io/petclinic'
        DOCKER_TAG = '0.0.1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'tech-task', url: 'https://github.com/danielmkn/spring-petclinic.git'
                echo "Cloned successfully"
            }
        }

        stage('Test') {
            steps {
                withGradle {
                    sh './mvnw test'
                    echo "Tests successful"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'artifactory-credentials', variable: 'DOCKER_PASS')]) {
                        sh('echo $DOCKER_PASS | docker login partnership-petclinic.jfrog.io -u danielmi --password-stdin')
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    sh "docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }
    }
}
