pipeline {
    agent any

    environment {
        DOCKER_USER = 'tasnimdockerhub'
    }

    tools {
        maven 'M2_HOME' // Maven installé dans WSL
        jdk 'JAVA_HOME'  // JDK installé dans WSL
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
                sh 'java -version'
                sh 'mvn -v'

                echo "📦 Compilation du projet Maven (tests ignorés)..."
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
                echo "🔐 Connexion sécurisée à Docker Hub..."
                withCredentials([string(credentialsId: 'docker-hub-token', variable: 'DOCKER_PASS')]) {
                    // Création d'un fichier config temporaire pour éviter docker-credential helpers Windows
                    sh """
                        mkdir -p ~/.docker
                        echo \$DOCKER_PASS | docker login -u ${DOCKER_USER} --password-stdin --config ~/.docker
                        docker push ${DOCKER_USER}/pipeline:latest
                        docker logout --config ~/.docker
                    """
                }
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
