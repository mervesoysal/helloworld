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
                credentials-id= 'msoysal_dockerhub'
                url= 'https://hub.docker.com/repository/docker/msoysal/hello-python'
            }
          steps {
              echo 'Pushing docker image to registry'
              
              script {
                docker.withRegistry( url, credentials-id )
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
