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
                sh 'mvn test' 
                
            }
        }
    stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
    }
    stage('Deploy') {
        steps {
            sh 'ssh -oStrictHostKeyChecking=no jenkins@10.142.15.226 sudo systemctl stop carts'
            sh 'scp /var/lib/jenkins/workspace/JenkinsDemo/target/carts.jar jenkins@10.142.15.226:~'
            sh 'ssh -oStrictHostKeyChecking=no jenkins@10.142.15.226 sudo systemctl start carts'
        }
    }
    }
    post {
        always {
            echo 'I have finished'            
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
