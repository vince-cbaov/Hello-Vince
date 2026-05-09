#!/usr/bin/env bash
set -e

# ---- CONFIG ----
JENKINS_URL="http://localhost:8080"
JENKINS_JOB="Hello-Vince/main"
JENKINS_USER="admin"
JENKINS_API_TOKEN="113faa8dc3b462eacf5a70c285aa0c2848"

# ---- GET APP SERVER IP FROM TERRAFORM ----
APP_SERVER_IP=$(terraform output -raw app_server_ip)

echo "Deploying to app server: $APP_SERVER_IP"

# ---- TRIGGER JENKINS BUILD WITH PARAM ----
java -jar jenkins-cli.jar \
  -s "$JENKINS_URL" \
  -auth "$JENKINS_USER:$JENKINS_API_TOKEN" \
  build "$JENKINS_JOB" \
  -p APP_SERVER=$APP_SERVER_IP
