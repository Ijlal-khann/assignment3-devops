# DevOps CI/CD Pipeline - Selenium + Jenkins + Docker

## Project Overview

This project demonstrates a complete CI/CD pipeline using:
- **Selenium** for automated web testing
- **Jenkins** for continuous integration
- **Docker** for containerized test execution
- **Email notifications** for test results

## 📁 Project Structure

```
devops-A3/
├── index.html              # Simple task manager web app
├── style.css               # Styling
├── script.js               # JavaScript functionality
├── test_app.py             # 15 Selenium test cases
├── config.py               # Test configuration
├── requirements.txt        # Python dependencies
├── Dockerfile              # Docker container definition
├── Jenkinsfile             # Jenkins pipeline script
├── setup_jenkins.sh        # EC2 Jenkins installation script
└── send_email.py           # Email utility (for local testing)
```

## 🧪 Test Cases (15 Total)

1. **test_01_homepage_loads** - Homepage loads successfully
2. **test_02_page_title_correct** - Page title is correct
3. **test_03_main_heading_exists** - Main heading is present
4. **test_04_navigation_menu_present** - Navigation menu with all links
5. **test_05_footer_exists** - Footer with correct content
6. **test_06_form_elements_present** - Task form and inputs accessible
7. **test_07_add_task_functionality** - Adding new task works
8. **test_08_css_loaded_correctly** - CSS styles applied
9. **test_09_javascript_works** - JavaScript functionality works
10. **test_10_clear_all_button_exists** - Clear all button visible
11. **test_11_responsive_design** - Mobile viewport functionality
12. **test_12_page_load_performance** - Page loads under 5 seconds
13. **test_13_task_list_displayed** - Task list section present
14. **test_14_feature_cards_present** - All feature cards displayed
15. **test_15_task_counter_accurate** - Task counter shows correct count

## 🚀 Pipeline Flow

```
GitHub Push → Jenkins Webhook → Checkout Code → Start HTTP Server → 
Build Docker Image → Run Selenium Tests → Stop Server → Email Results
```

## 📋 Prerequisites

- AWS EC2 instance (t2.medium or t3.small)
- Jenkins installed and running
- Docker installed
- GitHub repository
- Gmail account with App Password

## 🔧 Setup Instructions

### 1. EC2 & Jenkins Setup

**Launch EC2:**
- AMI: Amazon Linux 2023
- Type: t2.medium
- Security Group: Ports 22, 8080, 80

**SSH into EC2:**
```bash
ssh -i jenkins-key.pem ec2-user@YOUR_EC2_IP
```

**Run setup script:**
```bash
chmod +x setup_jenkins.sh
./setup_jenkins.sh
```

**Access Jenkins:**
```
http://YOUR_EC2_IP:8080
```

### 2. Configure Jenkins

**Install Plugins:**
- Manage Jenkins → Plugins → Available
- Install: GitHub Integration, Docker Pipeline, Email Extension

**Configure Email:**
- Manage Jenkins → Configure System
- Extended E-mail Notification:
  - SMTP: smtp.gmail.com:587
  - Credentials: Gmail + App Password
  - Use TLS: ✓

### 3. Create Pipeline Job

1. **New Item** → Name: `Selenium-Tests` → **Pipeline**
2. **Build Triggers**: ☑ GitHub hook trigger for GITScm polling
3. **Pipeline**:
   - Definition: Pipeline script from SCM
   - SCM: Git
   - Repository URL: Your GitHub repo
   - Branch: */main
   - Script Path: Jenkinsfile
4. **Save**

### 4. GitHub Webhook

**GitHub Repo → Settings → Webhooks:**
```
Payload URL: http://YOUR_EC2_IP:8080/github-webhook/
Content type: application/json
Events: Just the push event
```

## 🧪 Local Testing (Optional)

```bash
# Start HTTP server
python -m http.server 8000 &

# Install dependencies
pip install -r requirements.txt

# Run tests
pytest test_app.py -v

# Stop server
pkill -f "python.*http.server.*8000"
```

## 📧 Email Notifications

Pipeline automatically emails test results to the git commit author with:
- ✅ Build status (SUCCESS/FAILURE)
- 📊 Test summary (passed/failed counts)
- 📝 Build information
- 👤 Git commit details
- 🔗 Links to build and test report

## 🐳 Docker Container

The pipeline runs tests in a Docker container with:
- Python 3.9
- Chromium browser
- ChromeDriver
- Selenium & Pytest
- Network: host (to access HTTP server on EC2)

## 📊 Test Report

After each run, an HTML test report is generated and archived:
```
http://YOUR_JENKINS_URL/job/Selenium-Tests/lastBuild/artifact/report.html
```

## 🔄 Workflow

1. **Developer pushes code** to GitHub
2. **GitHub webhook** notifies Jenkins
3. **Jenkins pulls** latest code
4. **HTTP server starts** serving the website
5. **Docker builds** test environment
6. **Selenium tests run** in container
7. **Test results** archived
8. **Email sent** to commit author
9. **Server stops** and cleanup

## 🛠️ Technologies Used

- **Frontend**: HTML, CSS, JavaScript
- **Testing**: Selenium WebDriver, Pytest
- **CI/CD**: Jenkins, Docker
- **Cloud**: AWS EC2
- **VCS**: GitHub
- **Notifications**: Email Extension Plugin

## 📝 Assignment Requirements Met

✅ 10+ automated test cases using Selenium  
✅ Tests run in Docker with headless Chrome  
✅ Jenkins pipeline triggered by GitHub push  
✅ Pipeline executes test stage  
✅ Email sent to collaborator who made the push  
✅ Complete documentation with steps  

## 🎯 Key Features

- **Automated Testing**: 15 comprehensive Selenium tests
- **CI/CD Pipeline**: Fully automated Jenkins workflow
- **Containerized Execution**: Docker for consistent test environment
- **Email Notifications**: Detailed HTML email reports
- **Version Control**: GitHub integration with webhooks
- **Cloud Deployment**: AWS EC2 infrastructure

## 📞 Support

For issues or questions, check:
- Jenkins console output
- Docker logs: `docker logs <container_id>`
- HTTP server logs: `cat server.log`
- Email configuration in Jenkins

## 🏆 Success Criteria

Pipeline is successful when:
1. All 15 tests pass
2. Email notification received
3. Test report generated
4. No errors in Jenkins console

---

**Author**: DevOps Assignment  
**Date**: December 2025  
**Tech Stack**: Selenium | Jenkins | Docker | AWS EC2 | GitHub

