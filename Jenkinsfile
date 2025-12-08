pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'selenium-tests'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }
        
        stage('Start HTTP Server') {
            steps {
                script {
                    echo 'Starting Python HTTP server on port 8000...'
                    sh '''
                        # Kill any existing server on port 8000
                        pkill -f "python.*http.server.*8000" || true
                        
                        # Start HTTP server in background
                        cd ${WORKSPACE}
                        nohup python3 -m http.server 8000 > server.log 2>&1 &
                        
                        # Wait for server to start
                        sleep 5
                        
                        # Verify server is running
                        curl http://localhost:8000 || exit 1
                        
                        echo "HTTP server started successfully"
                    '''
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image with Selenium and Chrome...'
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    echo 'Running Selenium tests in Docker container...'
                    sh '''
                        docker run --rm \
                            --network=host \
                            -v ${WORKSPACE}:/app \
                            ${DOCKER_IMAGE}
                    '''
                }
            }
        }
    }
    
    post {
        always {
            script {
                echo 'Stopping HTTP server...'
                sh 'pkill -f "python.*http.server.*8000" || true'
                
                echo 'Cleaning up Docker images...'
                sh "docker rmi ${DOCKER_IMAGE} || true"
                
                // Archive test results
                archiveArtifacts artifacts: 'report.html', allowEmptyArchive: true
                
                // Get test results summary
                def testResults = sh(
                    script: 'grep -o "passed.*failed.*" report.html | head -1 || echo "Test results not found"',
                    returnStdout: true
                ).trim()
                
                // Get git commit info
                def gitCommit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                def gitAuthor = sh(returnStdout: true, script: 'git log -1 --pretty=format:"%an"').trim()
                def gitEmail = sh(returnStdout: true, script: 'git log -1 --pretty=format:"%ae"').trim()
                def gitMessage = sh(returnStdout: true, script: 'git log -1 --pretty=format:"%s"').trim()
                
                // Build status
                def buildStatus = currentBuild.result ?: 'SUCCESS'
                def statusColor = buildStatus == 'SUCCESS' ? 'green' : 'red'
                def statusEmoji = buildStatus == 'SUCCESS' ? '✅' : '❌'
                
                // Send email notification
                emailext (
                    subject: "${statusEmoji} Selenium Test Results - ${buildStatus}",
                    body: """
                        <html>
                        <body style="font-family: Arial, sans-serif;">
                            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; color: white;">
                                <h1>Selenium Test Execution Report</h1>
                            </div>
                            
                            <div style="padding: 20px; background: #f8f9fa;">
                                <h2 style="color: ${statusColor};">Build Status: ${buildStatus} ${statusEmoji}</h2>
                                
                                <h3>📊 Test Summary:</h3>
                                <p><strong>${testResults}</strong></p>
                                
                                <h3>📝 Build Information:</h3>
                                <ul>
                                    <li><strong>Build Number:</strong> #${env.BUILD_NUMBER}</li>
                                    <li><strong>Build Duration:</strong> ${currentBuild.durationString}</li>
                                    <li><strong>Timestamp:</strong> ${new Date()}</li>
                                </ul>
                                
                                <h3>👤 Git Information:</h3>
                                <ul>
                                    <li><strong>Commit:</strong> ${gitCommit}</li>
                                    <li><strong>Author:</strong> ${gitAuthor}</li>
                                    <li><strong>Message:</strong> ${gitMessage}</li>
                                </ul>
                                
                                <h3>🔗 Links:</h3>
                                <ul>
                                    <li><a href="${env.BUILD_URL}">View Build Details</a></li>
                                    <li><a href="${env.BUILD_URL}console">View Console Output</a></li>
                                    <li><a href="${env.BUILD_URL}artifact/report.html">View Test Report</a></li>
                                </ul>
                                
                                <div style="margin-top: 30px; padding: 15px; background: #fff3cd; border-left: 4px solid #ffc107;">
                                    <p><strong>Note:</strong> This email was automatically generated by Jenkins CI/CD pipeline.</p>
                                </div>
                            </div>
                            
                            <div style="background: #343a40; padding: 15px; color: #adb5bd; text-align: center;">
                                <p>DevOps Assignment - Selenium + Jenkins + Docker Pipeline</p>
                                <p>&copy; 2025 | Powered by Jenkins</p>
                            </div>
                        </body>
                        </html>
                    """,
                    to: "${gitEmail}",
                    mimeType: 'text/html',
                    attachLog: true
                )
            }
        }
        
        success {
            echo '✅ Pipeline completed successfully!'
        }
        
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}

