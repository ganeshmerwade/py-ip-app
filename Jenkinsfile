pipeline{
    agent{
            label 'docker_node'
        }
    environment{
        DOCKER_TAG = getDockerTag()
    }
    stages{
        stage('GetSourceCode') {
            steps{
                git branch: 'main', url: 'https://github.com/rtn136/ip_app_python'
            }
        }
        stage('BuildDockerImage') {
            steps{
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerPwd', usernameVariable: 'dockerUsr')]) {
                    sh '''
                        docker build . -t ${dockerUsr}/ip-app:${DOCKER_TAG} 
                        docker login -u ${dockerUsr} -p ${dockerPwd}
                        docker push ${dockerUsr}/ip-app:${DOCKER_TAG}
                    '''
                }
            }
        }
        stage('DeployToKubernetes'){
            steps{
                sh "chmod +x change_tag.sh"
                sh "./change_tag.sh ${DOCKER_TAG}"
                sshagent(['kubernetes_server']) {
				    script{
						sh '''
                            scp -v -o StrictHostKeyChecking=no ipapp-manifest.yaml ubuntu@${KUBERNETES_MASTER_IP}:/home/ubuntu/
                            ssh ubuntu@${KUBERNETES_MASTER_IP} kubectl apply -f ipapp-manifest.yaml
                        '''
					}
				}
            }
        }
    }
}

def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}