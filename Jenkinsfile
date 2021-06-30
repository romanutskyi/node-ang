// Initialize a LinkedHashMap / object to share between stages
def pipelineContext = [:]

pipeline {
    agent any

    environment {
        //COMMIT_ID="""${env.BUILD_TIMESTAMP}"""
        //"""${sh(returnStdout: true, script: 'git rev-parse --short HEAD')}"""
        //app = ''
    }

    stages {
        stage('Configure') {
            steps {
                echo 'Create parameters file'
            }
        }
        stage('Build') {
            steps {
                echo "Build docker image"
                script {
                    docker.withRegistry('https://registry.hub.docker.com', '${DOCKER_CREDS}') {
                        app = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                    }
                    pipelineContext.dockerImage = app
                }
            }
        }
        stage('Run') {
            steps {
                echo "Run docker image"
                script {
                    pipelineContext.dockerContainer = pipelineContext.dockerImage.run()
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', '${DOCKER_CREDS}') {
                        app.push("${env.BUILD_TIMESTAMP}")                
                    }
                }
            }
        }
        
    }
    post {
        always {
            echo "Stop Docker image"
            script {
                if (pipelineContext && pipelineContext.dockerContainer) {
                    pipelineContext.dockerContainer.stop()
                }
            }
        }
    }
}