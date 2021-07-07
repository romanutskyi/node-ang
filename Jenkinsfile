pipeline {
    agent any
    environment {
        COMMIT_ID="""${env.BUILD_TIMESTAMP}"""
        //"""${sh(returnStdout: true, script: 'git rev-parse --short HEAD')}"""
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
        
        stage('Test') {
            steps {
                sh 'docker run -d  -p 8081:80 -t ${IMAGE_NAME}:${IMAGE_TAG}'
            }
        }
        
	stage('Stop'){
	    steps {
		sh 'docker stop $(docker ps -a -q)'
	    }
	}
        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', '${DOCKER_CREDS}') {
                        app.push("${COMMIT_ID}")
		    sh 'docker rm $(docker ps -a -q)'
                    }
                }
            }
        }
    }

}
