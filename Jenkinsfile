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
          steps {
              echo 'Pushing docker image to registry'
              withCredentials([usernamePassword(credentialsId: 'msoysal_dockerhub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
              }
              script {
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
