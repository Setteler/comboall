pipeline {
    agent any  // ✅ This will launch a Kubernetes pod

    environment {
        REGISTRY = "pegasusbi"
        IMAGE_NAME = "com"
        TAG = "latest"
    }

    stages {
        stage('Build & Push Docker Image') {
            agent {
                kubernetes {
                    yaml """
                    apiVersion: v1
                    kind: Pod
                    metadata:
                      labels:
                        jenkins-agent: 'docker'
                    spec:
                      containers:
                      - name: docker
                        image: docker:20.10.23
                        command: ['cat']
                        tty: true
                        volumeMounts:
                          - name: docker-socket
                            mountPath: /var/run/docker.sock
                      volumes:
                      - name: docker-socket
                        hostPath:
                          path: /var/run/docker.sock
                          type: Socket
                    """
                }
            }
            steps {
                script {
                    sh "docker build -t $REGISTRY/$IMAGE_NAME:$TAG ."
                    sh "docker login -u your-dockerhub-username -p your-password"
                    sh "docker push $REGISTRY/$IMAGE_NAME:$TAG"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            agent {
                kubernetes {
                    yaml """
                    apiVersion: v1
                    kind: Pod
                    metadata:
                      labels:
                        jenkins-agent: 'kubectl'
                    spec:
                      containers:
                      - name: kubectl
                        image: bitnami/kubectl:latest
                        command: ['cat']
                        tty: true
                    """
                }
            }
            steps {
                sh "kubectl set image deployment/com com=$REGISTRY/$IMAGE_NAME:$TAG --record"
            }
        }
    }
}
