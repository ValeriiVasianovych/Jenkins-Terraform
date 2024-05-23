pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    parameters {
        booleanParam(name: 'autoDeploy', defaultValue: false, description: 'Automatically run terraform apply after plan?')
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout GitHub Project') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'ls -la'
                    sh 'terraform init'
                    sh 'terraform plan -out=tfplan'
                    sh 'terraform show -json tfplan > tfplan.json'
                }
            }
        }

        stage('Approve') {
            when {
                not {
                    equals expected: true, actual: params.autoDeploy
                }
            }
            steps {
                script {
                    def plan = readFile('tfplan.json')
                    input message: 'Do you want to apply this plan?',
                          parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            when {
                anyOf {
                    equals expected: true, actual: params.autoDeploy
                    triggeredBy 'user'
                }
            }
            steps {
                sh 'terraform apply -input=false tfplan'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
