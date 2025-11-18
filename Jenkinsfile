pipeline {
    agent any

    environment {
        DOCKER_USER = 'tasnimdockerhub'
        DOCKER_PASS = credentials('docker-hub-token')
    }

    tools {
        maven 'M2_HOME' // Assurez-vous que ce Maven est installé dans WSL
        jdk 'JAVA_HOME'  // Assurez-vous que ce JDK est installé dans WSL
    }

    stages {
        stage('Checkout') {
            steps {
                echo "🔄 Récupération du code source..."
                git credentialsId: 'github-token',
                    url: 'https://github.com/tasnim-araar/pipeline.git',
                    branch: 'main'
            }
        }

        stage('Build Maven') {
            steps {
                echo "🔧 Vérification des outils..."
                bat 'java -version'
                bat 'mvn -v'

                echo "📦 Compilation du projet Maven..."
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Construction de l'image Docker..."
                bat "docker build --progress=plain -t ${DOCKER_USER}/pipeline:latest ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "🔐 Connexion à Docker Hub..."
                bat "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"

                echo "📤 Push de l'image vers Docker Hub..."
                bat "docker push ${DOCKER_USER}/pipeline:latest"
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline exécuté avec succès !"
        }
        failure {
            echo "❌ Pipeline échoué !"
        }
    }
}
