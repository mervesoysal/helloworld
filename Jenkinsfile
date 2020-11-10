pipeline {
    agent any
    stages {
        stage('Build image') {
            steps {
                echo 'Starting to build docker image'

                script {
                    def customImage = docker.build("hello-python:${env.BUILD_ID}")
                }
            }
        }
        stage('Docker Push') {
            environment {
                
                url= 'https://hub.docker.com/repository/docker/msoysal/hello-python'
            }
          steps {
              echo 'Pushing docker image to registry'
              
              script {
                docker.withRegistry( url, 'msoysal_dockerhub' )
                customImage.push()
                customImage.push('latest')
              }
            }
        }
        stage('Docker Remove Image') {
          steps {
            sh "docker rmi $customImage"
          }
        }
        stage('Deploy on k8s') {
          steps {
              script{
                sh "ansible-playbook  playbook.yml --extra-vars \"$customImage\""
                }
            }
        }
    }
}
