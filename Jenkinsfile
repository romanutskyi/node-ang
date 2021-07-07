pipeline {
    agent any
    environment {
        COMMIT_ID="""${env.BUILD_TIMESTAMP}"""
        app = ''
    }
    stages {
        stage('Build') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', '${DOCKER_CREDS}') {
                        app = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                    }
                }
            }
        }
        
        stage('Run') {
            steps {
                sh 'docker run -d  -p 8081:80 -t ${IMAGE_NAME}:${IMAGE_TAG}'
            }
        }
        
    stage('Test') {
            steps {
	script{
        withEnv([
                "ipaddrs=$FINAL_IP",
                "appuri=http://$FINAL_IP:8081"
            ]){
            timeout(time: 15, unit: 'MINUTES') {
                waitUntil {
                    try {         
                  new URL("$appuri").getText()
               return true
                    } 
               catch (Exception e) {
           return false
                }
        }
    }
}
        
	}
            }
        }
    stage('Stop'){
        steps {
    sh 'docker stop $(docker ps -a -q)'
        }
    }

//        stage('Push') {
//            steps {
//                script {
//                    docker.withRegistry('https://registry.hub.docker.com', '${DOCKER_CREDS}') {
//                        app.push("${COMMIT_ID}")
//        sh 'docker rm $(docker ps -a -q)'
//        sh 'docker rmi $(docker images -q) -f'
//                    }
//                }
//            }
//        }
    }
    post {
        always {
            emailext body: 'A Test EMail', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'Test'
        }
    }

}