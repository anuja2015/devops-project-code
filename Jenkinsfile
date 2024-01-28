def registry = 'https://devopsdecember2023.jfrog.io'
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
                echo "<---------- build started ---------->"
                    sh 'mvn clean install'
                echo "<---------- build completed ---------->"
            }
        }
        stage("Test"){
          steps{
           echo "<---------- unit test started ---------->" 
             sh 'mvn surefire-report:report'
           echo "<---------- unit test completed ---------->"
          }
        }
        stage('SonarQube analysis') {
          steps{
                withSonarQubeEnv('my-sonarqube-server') { // If you have configured more than one global server connection, you can specify its name
                sh "${scannerHome}/bin/sonar-scanner"
                }
          }
        }
        stage("Quality Gate"){
          steps{  
            script{
              timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
              def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
              if (qg.status != 'OK') {
                 error "Pipeline aborted due to quality gate failure: ${qg.status}"
              }
            }
            }
        }
       }
        stage("Jar Publish") {
           steps {
             script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"artifactory_cred"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "target/*.jar",
                              "target": "mydevops2023-libs-release-local/",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '<--------------- Jar Publish Ended --------------->'  
            
            }
        }   
    }   
        
    }
}
