properties([pipelineTriggers([githubPush()])]) 

pipeline {

  agent any
    stages{
      stage('Test Code With Sonarqube') {
        steps {
          script {
            def scannerHome = tool 'sonarscanner';
              withSonarQubeEnv("sonarserver") {
              sh "${tool("sonarscanner")}/bin/sonar-scanner \
              -Dsonar.projectKey=nodejs-login-backend-${BRANCH_NAME}"
              }
          }
        }
      }
      stage('Build with Docker') {
        steps {
          sh "docker build -f Dockerfile -t nodejs-backend:${BRANCH_NAME}-${BUILD_NUMBER} ."
        }
      }
    }
}
