pipeline {
    agent {
        node {
            label 'maven'
        }
    }

    //全局变量
    environment {
        PROJECT_NAME = 'mall'
        PRIVATE_TREASURY = '192.168.195.129:5000'
        IMAGE = "${PROJECT_NAME}:v1"
        WORKSPACE = '/var/jenkins_home/workspace'
    }
    stages {
        stage('pull project') {
            steps { 
                // checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'gitee', url: 'https://gitee.com/OK4dvc/mall.git']]])
                echo "检出目录${WORKSPACE}"
                echo 'pull project，Hello World' 
            }
        }


/**        stage('code checking') {
             steps {
                script {
                    scannerHome = tool 'SonarQube Scanner'
                }
                withSonarQubeEnv('SonarQube') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
             }
        }**/

        stage('build project') {
            steps {
                container('maven') {
                    sh 'mvn clean install -Dmaven.test.skip=true '
                    echo 'build project,Hello World'
                }
            }
        }

        stage('build image') {
            steps {
                container('maven') {
                    //sh 'cd ${WORKSPACE}/${PROJECT_NAME}/target/'
                    sh 'docker build  --build-arg PROJECT_NAME="${PROJECT_NAME}" --build-arg WORKSPACE="${WORKSPACE}" -t $IMAGE .'
                    echo '构建镜像成功'
                    sh 'docker tag $IMAGE $PRIVATE_TREASURY/$IMAGE'
                    echo '镜像打标签'
                    sh 'docker push  $PRIVATE_TREASURY/$IMAGE'
                    echo '推送镜像到镜像仓库'
                }
            }
        }

        stage('publish project') {
            steps {
                container('maven') {
                    sh '/opt/test.sh $PROJECT_NAME $PRIVATE_TREASURY $IMAGE'
                    sh ' docker rmi  $PRIVATE_TREASURY/$IMAGE'
                    //sh 'docker run -d --name $PROJECT_NAME  -p 8899:8181 $PRIVATE_TREASURY/$IMAGE'
                    //echo '运行镜像'
                    //sh 'kubectl apply -f deploy.yaml'
                    //echo '执行pod'

                     
                    withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: '', contextName: '', credentialsId: '59691017-6edf-4133-b0e1-35e83d095e4a', namespace: '', serverUrl: 'https://kubernetes.default']]) {
                        sh 'kubectl version'
                
                        sh 'kubectl apply -f deploy.yaml'
                    } 
                    echo '执行pod'
                }
            }
        }
    }
    /**post {
        always {
            
            emailext body: '${FILE,path="email.html"}', subject: '构建通知:${PROJECT_NAME} - Build # ${BUILD_NUMBER} - ${BUILD_STATUS}', to: '13788978045@163.com'
        }
    }**/

}
