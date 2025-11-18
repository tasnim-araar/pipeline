pipeline {
    agent any

    tools {
        maven 'M2_HOME'     
        jdk   'JAVA_HOME'  
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
                echo "📦 Vérification des outils..."
                bat 'java -version'
                bat 'mvn -v'
                
                echo "📦 Build du projet Maven (tests ignorés)..."
                // On skip les tests pour éviter les erreurs liées à MySQL
                bat 'mvn clean package -DskipTests'
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
