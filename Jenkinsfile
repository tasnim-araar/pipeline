pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/tasnim-araar/pipeline.git', branch: 'main', credentialsId: 'github-token'
            }
        }

        stage('Compile Java') {
            steps {
                bat 'if not exist bin mkdir bin'
                bat 'javac -d bin src\\*.java'
            }
        }

        stage('Create JAR') {
            steps {
                bat 'jar cf myapp.jar -C bin .'
            }
        }
    }

    post {
        success {
            echo 'Pipeline terminé avec succès !'
        }
        failure {
            emailext (
                to: "tasnim.araar@esprit.tn",
                subject: "❌ Build Failed : ${env.JOB_NAME}",
                body: "Le build Jenkins a échoué.\nVoir console output : ${env.BUILD_URL}"
            )
        }
    }
}
