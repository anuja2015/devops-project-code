pipeline{
    agent{
        node{
            label 'mvn-node'
        }
    }
    stages{
        stage("Build"){
            steps{
                sh 'mvn clean deploy'
            }
        }
        
    }
}