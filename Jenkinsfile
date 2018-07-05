pipeline {
  agent any
  stages {
    stage('Build Parent') {
      steps {
        sh 'mvn -U -N clean install'
      }
    }
    stage('Build Packages') {
      parallel {
        stage('Build System') {
          steps {
            sh 'mvn -U -fae -f system/pom.xml clean install -P !deb'
          }
        }
        stage('Build Admin') {
          steps {
            sh 'mvn -U -fae -f admin/pom.xml clean install -P !deb'
          }
        }
        stage('Build Services') {
          steps {
            sh 'mvn -U -fae -f services/pom.xml clean install -P !deb'
          }
        }
      }
    }
  }
}