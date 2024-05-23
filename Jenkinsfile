pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    parameters {
        booleanParam(name: 'autoDeploy', defaultValue: false, description: 'Automatically run terraform apply after plan?')
    }

    stages {
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
                    sh 'terraform plan -out tfplan'
                    sh 'terraform show tfplan > tfplan.txt'
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
                    def plan = readFile('terraform/tfplan.txt')
                    input message: 'Do you want to apply this plan?',
                          parameters: [text(name: 'Plan', description: 'Please review plan', defaultValue: plan)]
                }
            }
        }
        stage('Apply') {
            steps {
                sh 'pwd; cd terraform/; terraform apply -input=false tfplan'
            }
        }
    }
}
