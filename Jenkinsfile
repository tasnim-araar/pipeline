pipeline {
    agent any

    environment {
        DOCKER_USER = 'tasnimdockerhub'
        DOCKER_PASS = credentials('docker-hub-token') // Personal Access Token Docker Hub
    }

    tools {
        maven 'M2_HOME' // Maven installé sur Windows
        jdk 'JAVA_HOME'  // JDK installé sur Windows
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

                echo "📦 Compilation du projet Maven (tests ignorés)..."
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Construction de l'image Docker..."
                bat "docker build -t %DOCKER_USER%/pipeline:latest ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "🔐 Connexion à Docker Hub..."
                bat "echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin"

                echo "📤 Push de l'image vers Docker Hub..."
                bat "docker push %DOCKER_USER%/pipeline:latest"
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
