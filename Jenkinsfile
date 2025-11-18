pipeline {
    agent any

    environment {
        DOCKER_USER = 'tasnimdockerhub'
        DOCKER_PASS = credentials('docker-hub-token')
    }

    tools {
        maven 'M2_HOME'
        jdk 'JAVA_HOME'
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-token',
                    url: 'https://github.com/tasnim-araar/pipeline.git',
                    branch: 'main'
            }
        }

        stage('Build with Maven') {
            steps {
                echo "🔧 Vérification des outils..."
                sh 'java -version'
                sh 'mvn -v'

                echo "📦 Build du projet Maven..."
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Construction de l'image Docker..."
                sh "docker build -t ${DOCKER_USER}/pipeline:latest ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "🔐 Connexion Docker Hub..."
                sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"

                echo "📤 Push de l'image vers Docker Hub..."
                sh "docker push ${DOCKER_USER}/pipeline:latest"
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline exécuté avec succès !'
        }
        failure {
            echo '❌ Pipeline échoué !'
        }
    }
}
