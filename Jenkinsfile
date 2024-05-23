pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    parameters {
        booleanParam(name: 'autoDeploy', defaultValue: false, description: 'Automatically run terraform apply after plan?')
        booleanParam(name: 'autoDestroy', defaultValue: false, description: 'Automatically run terraform destroy if needed?')
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
                allOf {
                    anyOf {
                        equals expected: true, actual: params.autoDeploy
                        triggeredBy 'user'
                    }
                    not {
                        equals expected: true, actual: params.autoDestroy
                    }
                }
            }
            steps {
                withCredentials([[
                  $class: 'AmazonWebServicesCredentialsBinding',
                  credentialsId: 'aws-credentials',
                  accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                  secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                  sh 'terraform apply -input=false tfplan'
                }
            }
        }

        stage('Destroy') {
            when {
                allOf {
                    anyOf {
                        equals expected: true, actual: params.autoDestroy
                        triggeredBy 'user'
                    }
                    not {
                        equals expected: true, actual: params.autoDeploy
                    }
                }
            }
            steps {
                withCredentials([[
                  $class: 'AmazonWebServicesCredentialsBinding',
                  credentialsId: 'aws-credentials',
                  accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                  secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                  sh 'terraform destroy -auto-approve'
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
