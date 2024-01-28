pipeline{
    agent{
        node{
            label 'mvn-node'
        }
    }
    environment{
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
        scannerHome = tool 'my-sonar-scanner'
    }
    stages{
        stage("Build"){
            steps{
                echo "---------- build started ----------"
                    sh 'mvn clean install'
                echo "---------- build completed ----------"
            }
        }
        stage("Test"){
          steps{
           echo "---------- unit test started ----------" 
             sh 'mvn surefire-report:report'
           echo "---------- unit test completed ----------"
          }
        }
        stage('SonarQube analysis') {
          steps{
                withSonarQubeEnv('my-sonarqube-server') { // If you have configured more than one global server connection, you can specify its name
                sh "${scannerHome}/bin/sonar-scanner"
    }
          }
        }
        
    }
}
