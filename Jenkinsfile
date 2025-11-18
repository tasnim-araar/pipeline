pipeline {
    agent any

    environment {
        DOCKER_USER = 'tasnimdockerhub'
        DOCKER_PASS = credentials('docker-hub-token')
        PATH = "/mnt/c/Program Files/Eclipse Adoptium/jdk-17.0.15.6-hotspot/bin:/mnt/c/Program Files (x86)/apache-maven-3.9.11/bin:${env.PATH}"
    }

    tools {
        maven 'M2_HOME'
        jdk 'JAVA_HOME'
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
                sh 'java.exe -version'
                sh 'mvn.cmd -v'

                echo "📦 Compilation du projet Maven..."
                sh 'mvn.cmd clean package -DskipTests'
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
                echo "🔐 Connexion à Docker Hub..."
                sh "echo \$DOCKER_PASS | docker login -u ${DOCKER_USER} --password-stdin"

                echo "📤 Push de l'image vers Docker Hub..."
                sh "docker push ${DOCKER_USER}/pipeline:latest"
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
