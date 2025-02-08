pipeline {
    agent any

    parameters {
        string(name: 'DOCKER_TAG', defaultValue: 'latest', description: 'Docker tag for the image')
    }

    environment {
        DOCKER_IMAGE = 'partnership-petclinic.jfrog.io/petclinic'
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
                    def dockerTag = params.DOCKER_TAG
                    sh "docker build -t ${DOCKER_IMAGE}:${dockerTag} ."
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
                    def dockerTag = params.DOCKER_TAG
                    sh "docker push ${DOCKER_IMAGE}:${dockerTag}"
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    def dockerTag = params.DOCKER_TAG
                    sh "docker rmi ${DOCKER_IMAGE}:${dockerTag}"
                }
            }
        }
    }
}
