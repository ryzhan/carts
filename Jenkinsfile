#!groovy
// Check properties
properties([disableConcurrentBuilds()])

pipeline {
        agent {
        label 'master'
        }
        
        stages {
        stage('Preparation') {
            steps {
                    git 'https://github.com/ryzhan/carts.git'
            }
        }
        
        stage('Build app') {
                
                environment {
                    DB_NETWORK_IP = sh(script: "cat /var/lib/jenkins/db_local_ip", , returnStdout: true).trim()
                    DOCKER_HOST="ssh://jenkins@app-server"
                }
            
                steps {
                    sh 'mvn clean package'
                    sh "docker build --no-cache --build-arg DB_NETWORK_IP=${DB_NETWORK_IP} -t carts ."
                }
        }
        
       stage('Deploy') {
            environment {
                DB_NETWORK_IP = sh(script: "cat /var/lib/jenkins/db_local_ip", , returnStdout: true).trim()
                CHECK_CONTAINER = sh(script: "ssh -oStrictHostKeyChecking=no jenkins@app-server /opt/check-carts.sh", , returnStdout: true).trim()
                DOCKER_HOST="ssh://jenkins@app-server"
            }
                
            steps {
                
                timeout(time:5, unit:'DAYS') {
                    input message:'Approve deployment?', submitter: 'it-ops'
                }
                
                script {
                    
                    if ("${CHECK_CONTAINER}" == 'carts') {
                        sh "docker restart carts"
                        
                    } else {
                        
                        sh "docker run -d --name carts --restart always --network socks -p 8081:80 carts"
                    }
                    //sh 'docker start catalogue' 
                }
                
                
                    
            }
        }
        
        stage('Archive') {
                steps {
                    archiveArtifacts artifacts: '**/*', fingerprint: true
                }
        }
        
    }
    
        
    post {
        always {
            echo 'I have finished'
            echo 'And cleaned workspace'
            deleteDir()
        }
        success {
            echo 'Job succeeeded!'
        }
        unstable {
            echo 'I am unstable :/'
        }
        failure {
            echo 'I failed :('
        }
        changed {
            echo 'Things were different before...'
        }
    }
}
