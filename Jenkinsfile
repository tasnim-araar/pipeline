pipeline {
    agent any

    tools {
        maven 'M2_HOME'   // Nom de l'installation Maven configurée dans Jenkins
        jdk   'JAVA_HOME'  // Nom de l'installation JDK configurée dans Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-token',
                    url: 'https://github.com/tasnim-araar/pipeline.git',
                    branch: 'main'
            }
        }

        stage('Check Tools') {
            steps {
                echo '🔧 Vérification de Java et Maven...'
                bat 'java -version'
                bat 'mvn -v'
            }
        }

        stage('Build Java') {
            steps {
                script {
                    // Crée le dossier bin si nécessaire
                    bat 'if not exist bin mkdir bin'

                    // Liste tous les fichiers .java dans src
                    def javaFiles = bat(script: 'dir /b /s src\\*.java', returnStdout: true).trim().split('\r\n')

                    if (javaFiles.size() > 0 && javaFiles[0] != '') {
                        echo "Fichiers Java trouvés : ${javaFiles}"
                        // Construit la commande javac avec guillemets autour de chaque fichier
                        def javacCmd = "javac -d bin " + javaFiles.collect { "\"${it}\"" }.join(' ')
                        bat javacCmd
                        // Crée le JAR
                        bat 'jar cvf app.jar -C bin .'
                    } else {
                        echo 'Aucun fichier .java trouvé, compilation et JAR ignorés.'
                    }
                }
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
