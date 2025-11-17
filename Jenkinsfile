pipeline {
    agent any

    tools {
        maven 'M2_HOME'     
        jdk   'JAVA_HOME'  
    }

    environment {
        DOCKER_HUB_USER = 'tasnim-dockerhub'                // ton username Docker Hub
        DOCKER_HUB_PASS = credentials('docker-hub-token')  // token Docker Hub ajouté dans Jenkins
    }

    stages {

        stage('Checkout') {
            steps {
                echo "🔄 Clonage du projet depuis GitHub..."
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
                
                echo "📦 Build du projet Maven (tests ignorés)..."
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Construction de l'image Docker..."
                bat "docker build -t %DOCKER_HUB_USER%/pipeline:1.0 ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "🚀 Push de l'image Docker sur Docker Hub..."
                bat "echo %DOCKER_HUB_PASS% | docker login -u %DOCKER_HUB_USER% --password-stdin"
                bat "docker push %DOCKER_HUB_USER%/pipeline:1.0"
            }
        }

        stage('Package') {
            steps {
                echo "📦 Le projet est compilé et packagé avec succès."
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
