pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: jenkins-kaniko
spec:
  serviceAccountName: jenkins-sa
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:v1.16.0-debug
      imagePullPolicy: Always
      command:
        - sleep
      args:
        - 99d
"""
    }
  }

  environment {
    ECR_REGISTRY = "793872273299.dkr.ecr.eu-west-1.amazonaws.com"
    IMAGE_NAME   = "ecr-alx"
    IMAGE_TAG    = "v${BUILD_NUMBER}"
  }

  stages {
    stage('Build & Push Docker Image to ECR') {
      steps {
        container('kaniko') {
          sh '''
            cd django
            /kaniko/executor \\
              --context `pwd` \\
              --dockerfile `pwd`/Dockerfile \\
              --destination=$ECR_REGISTRY/$IMAGE_NAME:$IMAGE_TAG \\
              --cache=true \\
              --insecure \\
              --skip-tls-verify
          '''
        }
      }
    }
  }
}
