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
              -Dsonar.projectKey=nodejs-login-backend-${BRANCH_NAME} \
              -Dsonar.sources=. \
              -Dsonar.css.node=."
            }
          }
        }
      }
      stage('Build with Docker') {
        steps {
          sh "docker build -f Dockerfile -t ${DOCKER_REPO}/nodejs-backend:${BRANCH_NAME}-${BUILD_NUMBER} ."
        }
      }
      stage('Publish Docker Image') {
        steps {
          sh "docker push ${DOCKER_REPO}/nodejs-backend:${BRANCH_NAME}-${BUILD_NUMBER}"
          sh "docker image rm -f ${DOCKER_REPO}/nodejs-backend:${BRANCH_NAME}-${BUILD_NUMBER}"
        }
      }
      stage('Deploy to Kubernetes') {
        when {
           changelog 'deployment'
        }
        input {
          message "Should we continue?"
            ok "Yes, we should."
            parameters {
              string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who are you?')
            }
        }
        steps {
          script {
            if ( env.GIT_BRANCH == 'stagging' ) {
              sh "wget https://raw.githubusercontent.com/ikhsannugs/deploy-repo/master/deploy-nodejs-backend.yaml"
              sh "sed -i 's/ENV/${BRANCH_NAME}/g' deploy-nodejs-backend.yaml"
              sh "sed -i 's/NO/${BUILD_NUMBER}/g' deploy-nodejs-backend.yaml"
              sh "kubectl apply -f deploy-nodejs-backend.yaml"
            }
            else if ( env.GIT_BRANCH == 'master' ) {
              sh "wget https://raw.githubusercontent.com/ikhsannugs/deploy-repo/master/deploy-nodejs-backend.yaml"
              sh "sed -i 's/ENV/${BRANCH_NAME}/g' deploy-nodejs-backend.yaml"
              sh "sed -i 's/NO/${BUILD_NUMBER}/g' deploy-nodejs-backend.yaml"
              sh "kubectl apply -f deploy-nodejs-backend.yaml"
            }
          }
        }
      }
    }
    post {
        always {
            echo 'One way or another, I have finished'
            deleteDir()
        }
        success {
            echo 'I succeeded!'
        }
        failure {
            echo 'I failed :('
        }
    }
}

