#!/usr/bin/env groovy
// Jenkins Pipeline for SimpleDaemons
// SimpleDaemons - A collection of lightweight and secure daemon implementations
// Copyright 2024 SimpleDaemons

pipeline {
    agent any
    
    parameters {
        choice(
            name: 'BUILD_TYPE',
            choices: ['Release', 'Debug'],
            description: 'Build type'
        )
        choice(
            name: 'PLATFORM',
            choices: ['linux', 'macos', 'windows', 'all'],
            description: 'Target platform'
        )
        choice(
            name: 'PROJECTS',
            choices: ['all', 'core', 'network', 'storage', 'security'],
            description: 'Projects to build'
        )
        booleanParam(
            name: 'RUN_TESTS',
            defaultValue: true,
            description: 'Run tests'
        )
        booleanParam(
            name: 'RUN_ANALYSIS',
            defaultValue: true,
            description: 'Run static analysis'
        )
        booleanParam(
            name: 'CREATE_PACKAGES',
            defaultValue: false,
            description: 'Create distribution packages'
        )
        booleanParam(
            name: 'DEPLOY',
            defaultValue: false,
            description: 'Deploy artifacts'
        )
        booleanParam(
            name: 'UPDATE_TEMPLATES',
            defaultValue: false,
            description: 'Update standardization templates'
        )
    }
    
    environment {
        PROJECT_NAME = 'SimpleDaemons'
        VERSION = '${env.BUILD_NUMBER}'
        BUILD_DIR = 'build'
        DIST_DIR = 'dist'
        DOCKER_IMAGE = "${PROJECT_NAME}:${VERSION}"
        DOCKER_REGISTRY = 'your-registry.com'
        CORE_PROJECTS = 'simple-ntpd,simple-httpd,simple-proxyd,simple-dhcpd,simple-dnsd'
        NETWORK_PROJECTS = 'simple-smtpd,simple-tftpd,simple-snmpd'
        STORAGE_PROJECTS = 'simple-nfsd,simple-rsyncd,simple-sftpd,simple-smbd'
        SECURITY_PROJECTS = 'simple-utcd,simple-dummy'
    }
    
    options {
        timeout(time: 120, unit: 'MINUTES')
        timestamps()
        ansiColor('xterm')
        buildDiscarder(logRotator(numToKeepStr: '20'))
        skipDefaultCheckout()
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    env.GIT_COMMIT_SHORT = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()
                    env.GIT_BRANCH = sh(
                        script: 'git rev-parse --abbrev-ref HEAD',
                        returnStdout: true
                    ).trim()
                }
            }
        }
        
        stage('Setup') {
            parallel {
                stage('Linux Setup') {
                    when {
                        anyOf {
                            equals expected: 'linux', actual: params.PLATFORM
                            equals expected: 'all', actual: params.PLATFORM
                        }
                    }
                    steps {
                        sh '''
                            sudo apt-get update -qq
                            sudo apt-get install -y -qq build-essential cmake libssl-dev libjsoncpp-dev pkg-config
                            sudo apt-get install -y -qq clang-format cppcheck python3-pip valgrind
                            sudo apt-get install -y -qq doxygen graphviz
                            pip3 install --user bandit semgrep safety
                        '''
                    }
                }
                
                stage('macOS Setup') {
                    when {
                        anyOf {
                            equals expected: 'macos', actual: params.PLATFORM
                            equals expected: 'all', actual: params.PLATFORM
                        }
                    }
                    steps {
                        sh '''
                            brew update
                            brew install cmake openssl jsoncpp clang-format cppcheck doxygen graphviz
                            pip3 install --user bandit semgrep safety
                        '''
                    }
                }
                
                stage('Windows Setup') {
                    when {
                        anyOf {
                            equals expected: 'windows', actual: params.PLATFORM
                            equals expected: 'all', actual: params.PLATFORM
                        }
                    }
                    steps {
                        bat '''
                            echo "Windows setup would go here"
                            echo "Install Visual Studio, CMake, vcpkg, etc."
                        '''
                    }
                }
            }
        }
        
        stage('Template Update') {
            when {
                expression { params.UPDATE_TEMPLATES == true }
            }
            steps {
                sh '''
                    echo "Updating standardization templates..."
                    cd projects/STANDARDIZATION_TEMPLATES
                    ./implement_standardization.sh --update-all
                '''
            }
        }
        
        stage('Build Core Projects') {
            when {
                anyOf {
                    equals expected: 'all', actual: params.PROJECTS
                    equals expected: 'core', actual: params.PROJECTS
                }
            }
            parallel {
                stage('Build simple-ntpd') {
                    steps {
                        buildProject('simple-ntpd')
                    }
                }
                stage('Build simple-httpd') {
                    steps {
                        buildProject('simple-httpd')
                    }
                }
                stage('Build simple-proxyd') {
                    steps {
                        buildProject('simple-proxyd')
                    }
                }
                stage('Build simple-dhcpd') {
                    steps {
                        buildProject('simple-dhcpd')
                    }
                }
                stage('Build simple-dnsd') {
                    steps {
                        buildProject('simple-dnsd')
                    }
                }
            }
        }
        
        stage('Build Network Projects') {
            when {
                anyOf {
                    equals expected: 'all', actual: params.PROJECTS
                    equals expected: 'network', actual: params.PROJECTS
                }
            }
            parallel {
                stage('Build simple-smtpd') {
                    steps {
                        buildProject('simple-smtpd')
                    }
                }
                stage('Build simple-tftpd') {
                    steps {
                        buildProject('simple-tftpd')
                    }
                }
                stage('Build simple-snmpd') {
                    steps {
                        buildProject('simple-snmpd')
                    }
                }
            }
        }
        
        stage('Build Storage Projects') {
            when {
                anyOf {
                    equals expected: 'all', actual: params.PROJECTS
                    equals expected: 'storage', actual: params.PROJECTS
                }
            }
            parallel {
                stage('Build simple-nfsd') {
                    steps {
                        buildProject('simple-nfsd')
                    }
                }
                stage('Build simple-rsyncd') {
                    steps {
                        buildProject('simple-rsyncd')
                    }
                }
                stage('Build simple-sftpd') {
                    steps {
                        buildProject('simple-sftpd')
                    }
                }
                stage('Build simple-smbd') {
                    steps {
                        buildProject('simple-smbd')
                    }
                }
            }
        }
        
        stage('Build Security Projects') {
            when {
                anyOf {
                    equals expected: 'all', actual: params.PROJECTS
                    equals expected: 'security', actual: params.PROJECTS
                }
            }
            parallel {
                stage('Build simple-utcd') {
                    steps {
                        buildProject('simple-utcd')
                    }
                }
                stage('Build simple-dummy') {
                    steps {
                        buildProject('simple-dummy')
                    }
                }
            }
        }
        
        stage('Test') {
            when {
                expression { params.RUN_TESTS == true }
            }
            parallel {
                stage('Test Core Projects') {
                    when {
                        anyOf {
                            equals expected: 'all', actual: params.PROJECTS
                            equals expected: 'core', actual: params.PROJECTS
                        }
                    }
                    steps {
                        testProjects('core')
                    }
                }
                stage('Test Network Projects') {
                    when {
                        anyOf {
                            equals expected: 'all', actual: params.PROJECTS
                            equals expected: 'network', actual: params.PROJECTS
                        }
                    }
                    steps {
                        testProjects('network')
                    }
                }
                stage('Test Storage Projects') {
                    when {
                        anyOf {
                            equals expected: 'all', actual: params.PROJECTS
                            equals expected: 'storage', actual: params.PROJECTS
                        }
                    }
                    steps {
                        testProjects('storage')
                    }
                }
                stage('Test Security Projects') {
                    when {
                        anyOf {
                            equals expected: 'all', actual: params.PROJECTS
                            equals expected: 'security', actual: params.PROJECTS
                        }
                    }
                    steps {
                        testProjects('security')
                    }
                }
            }
        }
        
        stage('Analysis') {
            when {
                expression { params.RUN_ANALYSIS == true }
            }
            parallel {
                stage('Code Style') {
                    steps {
                        sh '''
                            echo "Running code style checks across all projects..."
                            for project in projects/*/; do
                                if [ -f "$project/Makefile" ]; then
                                    echo "Checking style for $(basename $project)..."
                                    cd "$project"
                                    make check-style || true
                                    cd - > /dev/null
                                fi
                            done
                        '''
                    }
                }
                
                stage('Static Analysis') {
                    steps {
                        sh '''
                            echo "Running static analysis across all projects..."
                            for project in projects/*/; do
                                if [ -f "$project/Makefile" ]; then
                                    echo "Analyzing $(basename $project)..."
                                    cd "$project"
                                    make lint || true
                                    cd - > /dev/null
                                fi
                            done
                        '''
                    }
                }
                
                stage('Security Scan') {
                    steps {
                        sh '''
                            echo "Running security scans across all projects..."
                            for project in projects/*/; do
                                if [ -f "$project/Makefile" ]; then
                                    echo "Scanning $(basename $project)..."
                                    cd "$project"
                                    make security-scan || true
                                    cd - > /dev/null
                                fi
                            done
                        '''
                    }
                }
                
                stage('Documentation') {
                    steps {
                        sh '''
                            echo "Generating documentation..."
                            for project in projects/*/; do
                                if [ -f "$project/Makefile" ]; then
                                    echo "Generating docs for $(basename $project)..."
                                    cd "$project"
                                    make docs || true
                                    cd - > /dev/null
                                fi
                            done
                        '''
                    }
                }
            }
        }
        
        stage('Package') {
            when {
                expression { params.CREATE_PACKAGES == true }
            }
            steps {
                sh '''
                    echo "Creating packages for all projects..."
                    for project in projects/*/; do
                        if [ -f "$project/Makefile" ]; then
                            echo "Packaging $(basename $project)..."
                            cd "$project"
                            make package || true
                            cd - > /dev/null
                        fi
                    done
                    
                    # Create consolidated package
                    mkdir -p ${DIST_DIR}
                    tar -czf ${DIST_DIR}/SimpleDaemons-${VERSION}.tar.gz projects/
                '''
            }
        }
        
        stage('Docker') {
            steps {
                script {
                    def dockerfiles = sh(
                        script: 'find projects/ -name "Dockerfile" -type f',
                        returnStdout: true
                    ).trim().split('\n')
                    
                    for (dockerfile in dockerfiles) {
                        if (dockerfile) {
                            def projectName = dockerfile.split('/')[1]
                            sh '''
                                cd ${dockerfile%/*}
                                docker build -t ${PROJECT_NAME}-${projectName}:${VERSION} .
                                docker tag ${PROJECT_NAME}-${projectName}:${VERSION} ${DOCKER_REGISTRY}/${PROJECT_NAME}-${projectName}:${VERSION}
                            '''
                        }
                    }
                }
            }
        }
        
        stage('Deploy') {
            when {
                expression { params.DEPLOY == true }
            }
            steps {
                script {
                    // Deploy to artifact repository
                    sh '''
                        echo "Deploying artifacts..."
                        # Add your deployment logic here
                        # e.g., upload to Nexus, Artifactory, etc.
                    '''
                    
                    // Deploy Docker images
                    sh '''
                        for project in projects/*/; do
                            if [ -f "$project/Dockerfile" ]; then
                                projectName=$(basename $project)
                                docker push ${DOCKER_REGISTRY}/${PROJECT_NAME}-${projectName}:${VERSION}
                            fi
                        done
                    '''
                }
            }
        }
    }
    
    post {
        always {
            // Archive artifacts
            archiveArtifacts artifacts: 'dist/**', allowEmptyArchive: true
            archiveArtifacts artifacts: 'build/**', allowEmptyArchive: true
            
            // Publish test results
            publishTestResults testResultsPattern: '**/test-results.xml'
            
            // Clean up
            cleanWs()
        }
        
        success {
            echo 'Build succeeded!'
            // Send success notification
            emailext (
                subject: "Build Success: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: "Build ${env.BUILD_NUMBER} succeeded for ${env.PROJECT_NAME}",
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
        
        failure {
            echo 'Build failed!'
            // Send failure notification
            emailext (
                subject: "Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: "Build ${env.BUILD_NUMBER} failed for ${env.PROJECT_NAME}. Check the console output for details.",
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
        
        unstable {
            echo 'Build unstable!'
        }
    }
}

// Helper function to build a project
def buildProject(projectName) {
    sh """
        echo "Building ${projectName}..."
        cd projects/${projectName}
        
        # Create build directory
        mkdir -p ${BUILD_DIR}
        cd ${BUILD_DIR}
        
        # Configure CMake
        cmake .. -DCMAKE_BUILD_TYPE=${params.BUILD_TYPE}
        
        # Build
        make -j\$(nproc 2>/dev/null || sysctl -n hw.ncpu)
        
        # Create packages if requested
        if [ "${params.CREATE_PACKAGES}" == "true" ]; then
            make package
        fi
    """
}

// Helper function to test projects by category
def testProjects(category) {
    def projects = []
    switch(category) {
        case 'core':
            projects = env.CORE_PROJECTS.split(',')
            break
        case 'network':
            projects = env.NETWORK_PROJECTS.split(',')
            break
        case 'storage':
            projects = env.STORAGE_PROJECTS.split(',')
            break
        case 'security':
            projects = env.SECURITY_PROJECTS.split(',')
            break
    }
    
    for (project in projects) {
        sh """
            echo "Testing ${project}..."
            cd projects/${project}
            if [ -f "${BUILD_DIR}/Makefile" ]; then
                cd ${BUILD_DIR}
                make test || true
            fi
        """
    }
}
