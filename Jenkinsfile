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
    stage('Build') {
            steps {
                sh 'mvn clean package' 
                
            }
        }
    stage('Test') {
            steps {
                sh './test/test.sh unit.py' 
                
            }
        }
    stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
    }
    stage('Deploy') {

        environment {
                PRODUCTION_NETWORK_IP = sh(script: "cat /var/lib/jenkins/production_local_ip", , returnStdout: true).trim()
                }

        steps {
            
                timeout(time:5, unit:'DAYS') {
                    input message:'Approve deployment?', submitter: 'it-ops'
                }
            
            sh "ssh -oStrictHostKeyChecking=no jenkins@$PRODUCTION_NETWORK_IP sudo systemctl stop carts"
            sh "scp /var/lib/jenkins/workspace/JenkinsDemo/target/carts.jar jenkins@$PRODUCTION_NETWORK_IP:~"
            sh "ssh -oStrictHostKeyChecking=no jenkins@$PRODUCTION_NETWORK_IP sudo systemctl start carts"
        }
    }
    }
    post {
        always {
            echo 'I have finished and deleting workspace'
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
