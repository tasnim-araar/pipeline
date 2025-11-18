pipeline {
    agent any

    tools {
        maven 'M2_HOME'
        jdk   'JAVA_HOME'
    }

    environment {
        DOCKER_USER = 'tasnimdockerhub'
        DOCKER_PASS = credentials('docker-hub-token')
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

        stage('Build with Maven') {
            steps {
                echo "📦 Vérification des outils..."
                bat 'java -version'
                bat 'mvn -v'
                
                echo "📦 Build du projet Maven..."
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Construction de l'image Docker..."
                bat "docker build -t %DOCKER_USER%/pipeline:1.0 ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "🔑 Connexion à Docker Hub..."
                bat "echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin"

                echo "🚀 Push de l'image..."
                bat "docker push %DOCKER_USER%/pipeline:1.0"
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline terminé avec succès !'
        }
        failure {
            echo '❌ Pipeline échoué !'
            emailext (
                to: "tasnim.araar@esprit.tn",
                subject: "❌ Build Failed : ${env.JOB_NAME}",
                body: "Le build Jenkins a échoué.\nVoir console output : ${env.BUILD_URL}"
            )
        }
    }
}
