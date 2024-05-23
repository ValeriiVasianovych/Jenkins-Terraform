pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    parameters {
        choice(name: 'ACTION', choices: ['Apply', 'Plan', 'Destroy'], description: 'Select action to perform with Terraform')
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
                    sh 'pwd; ls -la'
                    
                    withCredentials([[
                      $class: 'AmazonWebServicesCredentialsBinding',
                      credentialsId: 'aws-credentials',
                      accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                      secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                      sh 'terraform init'
                      sh 'terraform plan -out=tfplan'
                    }

                    sh 'terraform show -json tfplan > tfplan.json'
                }
            }
        }
        
        stage('User Input') {
            when {
                expression { params.ACTION != null }
            }
            steps {
                script {
                    input message: 'Proceed with selected action?', parameters: [
                        [$class: 'ChoiceParameterDefinition', choices: 'Yes\nNo', description: '', name: 'CONFIRM']
                    ]
                    if (params.CONFIRM == 'No') {
                        error 'Pipeline aborted by user'
                    }
                }
            }
        }
        
        stage('Terraform Action') {
            when {
                expression { params.ACTION != null }
            }
            steps {
                script {
                    switch (params.ACTION) {
                        case 'Apply':
                            sh 'terraform apply -auto-approve'
                            break
                        case 'Plan':
                            sh 'terraform apply -auto-approve'
                            break
                        case 'Destroy':
                            sh 'terraform destroy -auto-approve'
                            break
                        default:
                            error "Invalid action selected: ${params.ACTION}"
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
