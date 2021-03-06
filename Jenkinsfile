pipeline {
    agent any
    stages {
        stage('Build image') {
            steps {
                echo 'Starting to build docker image'
                sh "docker build -t msoysal/hello-python:${env.BUILD_NUMBER} ."
                sh "docker build -t msoysal/hello-python:latest ."
            }
        }
        stage('Docker Push') {
          steps {
              echo 'Pushing docker image to registry'
              withCredentials([usernamePassword(credentialsId: 'msoysal_dockerhub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
                sh "docker push msoysal/hello-python:${env.BUILD_NUMBER}"
                sh "docker push msoysal/hello-python:latest"
              }
            }
        }
        stage('Docker Remove Image') {
          steps {
            sh "docker rmi msoysal/hello-python:${env.BUILD_NUMBER}"
          }
        }
        stage('Deploy on k8s') {
          steps {
            withKubeConfig([credentialsId: 'kubeconfig']) {
              sh 'cat deployment.yaml | sed "s/{{BUILD_NUMBER}}/$BUILD_NUMBER/g" | kubectl apply -f -'
              sh 'kubectl apply -f service.yaml'
            }
          }
        }
    }
}
