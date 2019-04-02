pipeline {
  agent any
  parameters {
    string(name: 'product_groupId', defaultValue: 'fr.project-factory.core.products', description: 'Product groupId')
    string(name: 'product_artifactId', defaultValue: 'default', description: 'Product artifactId')
    string(name: 'product_version', defaultValue: '3.4.0', description: 'Product version')
    string(name: 'product_file', defaultValue: 'product-dev.properties', description: 'Product file')
    string(name: 'mvn_opts', defaultValue: '-U', description: 'Maven build options')
    string(name: 'mvn_goals', defaultValue: 'clean install', description: 'Maven build goals')
    booleanParam(name: 'build_centos7', defaultValue: true, description: 'Build packages for CentOS 7')
    booleanParam(name: 'build_debian9', defaultValue: true, description: 'Build packages for Debian 9')
    booleanParam(name: 'build_opensuse423', defaultValue: true, description: 'Build packages for openSUSE 42.3')
    booleanParam(name: 'build_ubuntu1604', defaultValue: true, description: 'Build packages for Ubuntu 16.04')
    booleanParam(name: 'build_system', defaultValue: true, description: 'Build system packages')
    booleanParam(name: 'build_admin', defaultValue: true, description: 'Build admin packages')
    booleanParam(name: 'build_services', defaultValue: true, description: 'Build service packages')
  }
  stages {
    stage('Build Parent') {
      steps {
        withMaven() {
          sh "mvn -N ${params.mvn_opts} ${params.mvn_goals}"
        }
      }
    }
    stage('Build Packages') {
      parallel {
        stage('CentOS 7') {
          agent {
            docker {
              image 'projectfactory/build:centos7'
              args '-v $HOME/.m2:/var/maven/.m2 -v $HOME/.m2/settings.xml:/var/maven/.m2/settings.xml -v $HOME/.m2/repository:/var/maven/.m2/repository -v $HOME/.gnupg:/var/maven/.gnupg'
            }
          }
          when {
            beforeAgent true
            expression { params.build_centos7 == true }
          }
          stages {
            stage('CentOS 7 System') {
              when {
                expression { params.build_system == true }
              }
              steps {
                sh "/bin/bash -l -c 'mvn -Duser.home=/var/maven -Dbuild.dir=/var/maven/build -Dgpg.homedir=/var/maven/.gnupg -fae -f system/pom.xml ${params.mvn_opts} ${params.mvn_goals} -Dproperties.product.groupId=${params.product_groupId} -Dproperties.product.artifactId=${params.product_artifactId} -Dproperties.product.version=${params.product_version} -Dproperties.product.file=${params.product_file} -Dproperties.system.file=system-el7-x86_64.properties -P !deb'"
              }
            }
            stage('CentOS 7 Admin') {
              when {
                expression { params.build_admin == true }
              }
              steps {
                sh "/bin/bash -l -c 'mvn -Duser.home=/var/maven -Dbuild.dir=/var/maven/build -Dgpg.homedir=/var/maven/.gnupg -fae -f admin/pom.xml ${params.mvn_opts} ${params.mvn_goals} -Dproperties.product.groupId=${params.product_groupId} -Dproperties.product.artifactId=${params.product_artifactId} -Dproperties.product.version=${params.product_version} -Dproperties.product.file=${params.product_file} -Dproperties.system.file=system-el7-x86_64.properties -P !deb'"
              }
            }
            stage('CentOS 7 Services') {
              when {
                expression { params.build_services == true }
              }
              steps {
                sh "/bin/bash -l -c 'mvn -Duser.home=/var/maven -Dbuild.dir=/var/maven/build -Dgpg.homedir=/var/maven/.gnupg -fae -f services/pom.xml ${params.mvn_opts} ${params.mvn_goals} -Dproperties.product.groupId=${params.product_groupId} -Dproperties.product.artifactId=${params.product_artifactId} -Dproperties.product.version=${params.product_version} -Dproperties.product.file=${params.product_file} -Dproperties.system.file=system-el7-x86_64.properties -P !deb'"
              }
            }
          }
        }
        stage('Debian 9') {
          agent {
            docker {
              image 'projectfactory/build:debian9'
              args '-v $HOME/.m2:/var/maven/.m2 -v $HOME/.m2/settings.xml:/var/maven/.m2/settings.xml -v $HOME/.m2/repository:/var/maven/.m2/repository -v $HOME/.gnupg:/var/maven/.gnupg'
            }
          }
          when {
            beforeAgent true
            expression { params.build_debian9 == true }
          }
          stages {
            stage('Debian 9 System') {
              when {
                expression { params.build_system == true }
              }
              steps {
                sh "/bin/bash -l -c 'mvn -Duser.home=/var/maven -Dbuild.dir=/var/maven/build -Dgpg.homedir=/var/maven/.gnupg -fae -f system/pom.xml ${params.mvn_opts} ${params.mvn_goals} -Dproperties.product.groupId=${params.product_groupId} -Dproperties.product.artifactId=${params.product_artifactId} -Dproperties.product.version=${params.product_version} -Dproperties.product.file=${params.product_file} -Dproperties.system.file=system-debian9-amd64.properties -P !rpm'"
              }
            }
            stage('Debian 9 Admin') {
              when {
                expression { params.build_admin == true }
              }
              steps {
                sh "/bin/bash -l -c 'mvn -Duser.home=/var/maven -Dbuild.dir=/var/maven/build -Dgpg.homedir=/var/maven/.gnupg -fae -f admin/pom.xml ${params.mvn_opts} ${params.mvn_goals} -Dproperties.product.groupId=${params.product_groupId} -Dproperties.product.artifactId=${params.product_artifactId} -Dproperties.product.version=${params.product_version} -Dproperties.product.file=${params.product_file} -Dproperties.system.file=system-debian9-amd64.properties -P !rpm'"
              }
            }
            stage('Debian 9 Services') {
              when {
                expression { params.build_services == true }
              }
              steps {
                sh "/bin/bash -l -c 'mvn -Duser.home=/var/maven -Dbuild.dir=/var/maven/build -Dgpg.homedir=/var/maven/.gnupg -fae -f services/pom.xml ${params.mvn_opts} ${params.mvn_goals} -Dproperties.product.groupId=${params.product_groupId} -Dproperties.product.artifactId=${params.product_artifactId} -Dproperties.product.version=${params.product_version} -Dproperties.product.file=${params.product_file} -Dproperties.system.file=system-debian9-amd64.properties -P !rpm'"
              }
            }
          }
        }
        stage('openSUSE 42.3') {
          agent {
            docker {
              image 'projectfactory/build:opensuse423'
              args '-v $HOME/.m2:/var/maven/.m2 -v $HOME/.m2/settings.xml:/var/maven/.m2/settings.xml -v $HOME/.m2/repository:/var/maven/.m2/repository -v $HOME/.gnupg:/var/maven/.gnupg'
            }
          }
          when {
            beforeAgent true
            expression { params.build_opensuse423 == true }
          }
          stages {
            stage('openSUSE 42.3 System') {
              when {
                expression { params.build_system == true }
              }
              steps {
                sh "/bin/bash -l -c 'mvn -Duser.home=/var/maven -Dbuild.dir=/var/maven/build -Dgpg.homedir=/var/maven/.gnupg -fae -f system/pom.xml ${params.mvn_opts} ${params.mvn_goals} -Dproperties.product.groupId=${params.product_groupId} -Dproperties.product.artifactId=${params.product_artifactId} -Dproperties.product.version=${params.product_version} -Dproperties.product.file=${params.product_file} -Dproperties.system.file=system-opensuse423-x86_64.properties -P !deb'"
              }
            }
            stage('openSUSE 42.3 Admin') {
              when {
                expression { params.build_admin == true }
              }
              steps {
                sh "/bin/bash -l -c 'mvn -Duser.home=/var/maven -Dbuild.dir=/var/maven/build -Dgpg.homedir=/var/maven/.gnupg -fae -f admin/pom.xml ${params.mvn_opts} ${params.mvn_goals} -Dproperties.product.groupId=${params.product_groupId} -Dproperties.product.artifactId=${params.product_artifactId} -Dproperties.product.version=${params.product_version} -Dproperties.product.file=${params.product_file} -Dproperties.system.file=system-opensuse423-x86_64.properties -P !deb'"
              }
            }
            stage('openSUSE 42.3 Services') {
              when {
                expression { params.build_services == true }
              }
              steps {
                sh "/bin/bash -l -c 'mvn -Duser.home=/var/maven -Dbuild.dir=/var/maven/build -Dgpg.homedir=/var/maven/.gnupg -fae -f services/pom.xml ${params.mvn_opts} ${params.mvn_goals} -Dproperties.product.groupId=${params.product_groupId} -Dproperties.product.artifactId=${params.product_artifactId} -Dproperties.product.version=${params.product_version} -Dproperties.product.file=${params.product_file} -Dproperties.system.file=system-opensuse423-x86_64.properties -P !deb'"
              }
            }
          }
        }
        stage('Ubuntu 16.04') {
          agent {
            docker {
              image 'projectfactory/build:ubuntu1604'
              args '-v $HOME/.m2:/var/maven/.m2 -v $HOME/.m2/settings.xml:/var/maven/.m2/settings.xml -v $HOME/.m2/repository:/var/maven/.m2/repository -v $HOME/.gnupg:/var/maven/.gnupg'
            }
          }
          when {
            beforeAgent true
            expression { params.build_ubuntu1604 == true }
          }
          stages {
            stage('Ubuntu 16.04 System') {
              when {
                expression { params.build_system == true }
              }
              steps {
                sh "/bin/bash -l -c 'mvn -Duser.home=/var/maven -Dbuild.dir=/var/maven/build -Dgpg.homedir=/var/maven/.gnupg -fae -f system/pom.xml ${params.mvn_opts} ${params.mvn_goals} -Dproperties.product.groupId=${params.product_groupId} -Dproperties.product.artifactId=${params.product_artifactId} -Dproperties.product.version=${params.product_version} -Dproperties.product.file=${params.product_file} -Dproperties.system.file=system-ubuntu1604-amd64.properties -P !rpm'"
              }
            }
            stage('Ubuntu 16.04 Admin') {
              when {
                expression { params.build_admin == true }
              }
              steps {
                sh "/bin/bash -l -c 'mvn -Duser.home=/var/maven -Dbuild.dir=/var/maven/build -Dgpg.homedir=/var/maven/.gnupg -fae -f admin/pom.xml ${params.mvn_opts} ${params.mvn_goals} -Dproperties.product.groupId=${params.product_groupId} -Dproperties.product.artifactId=${params.product_artifactId} -Dproperties.product.version=${params.product_version} -Dproperties.product.file=${params.product_file} -Dproperties.system.file=system-ubuntu1604-amd64.properties -P !rpm'"
              }
            }
            stage('Ubuntu 16.04 Services') {
              when {
                expression { params.build_services == true }
              }
              steps {
                sh "/bin/bash -l -c 'mvn -Duser.home=/var/maven -Dbuild.dir=/var/maven/build -Dgpg.homedir=/var/maven/.gnupg -fae -f services/pom.xml ${params.mvn_opts} ${params.mvn_goals} -Dproperties.product.groupId=${params.product_groupId} -Dproperties.product.artifactId=${params.product_artifactId} -Dproperties.product.version=${params.product_version} -Dproperties.product.file=${params.product_file} -Dproperties.system.file=system-ubuntu1604-amd64.properties -P !rpm'"
              }
            }
          }
        }
      }
    }
  }
}