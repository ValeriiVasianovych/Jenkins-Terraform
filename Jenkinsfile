pipeline {
	agent any

	options {
		buildDiscarder(logRotator(numToKeepStr: '5'))
	}

	parameters {
		choice(name: 'ACTION', choices: ['Apply', 'Plan', 'Destroy'], description: 'Select action to perform with Terraform')
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
					sh 'pwd; ls -la'

					withCredentials([
						[
							$class: 'AmazonWebServicesCredentialsBinding',
							credentialsId: 'aws-credentials',
							accessKeyVariable: 'AWS_ACCESS_KEY_ID',
							secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
						]
					]) {
						sh 'terraform init'
						sh 'terraform plan -out=tfplan'
					}

					sh 'terraform show -json tfplan > tfplan.json'
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
							withCredentials([
								[
									$class: 'AmazonWebServicesCredentialsBinding',
									credentialsId: 'aws-credentials',
									accessKeyVariable: 'AWS_ACCESS_KEY_ID',
									secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
								]
							]) {
								sh 'terraform apply -auto-approve'
							}
							break
						case 'Plan':
							withCredentials([
								[
									$class: 'AmazonWebServicesCredentialsBinding',
									credentialsId: 'aws-credentials',
									accessKeyVariable: 'AWS_ACCESS_KEY_ID',
									secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
								]
							]) {
								sh 'terraform plan'
							}
							break
						case 'Destroy':
							withCredentials([
								[
									$class: 'AmazonWebServicesCredentialsBinding',
									credentialsId: 'aws-credentials',
									accessKeyVariable: 'AWS_ACCESS_KEY_ID',
									secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
								]
							]) {
								sh 'terraform destroy -auto-approve'
							}
							break
						default:
							error "Invalid action selected: ${params.ACTION}"
					}
				}
			}
		}
	}
}
