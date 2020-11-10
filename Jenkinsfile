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
            enviroment {
                registryCredential= 'msoysal'
            }
          steps {
              echo 'Pushing docker image to registry'
              
              script {
                docker.withRegistry( '', registryCredential )
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
