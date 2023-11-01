##################################################
# Init local
##################################################
LOCAL_DIR="overlays/local"
TEMPLATE_DIR="overlays/local-template"
mkdir -p $LOCAL_DIR
cp -n $TEMPLATE_DIR/* $LOCAL_DIR/

export PV_HOST_PATH=$(cd $(dirname $0);pwd)/data/mysql
mkdir -p ${PV_HOST_PATH}
cat <<EOF > overlays/local/pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mimosa-db
  namespace: middleware
spec:
  hostPath:
    path: ${PV_HOST_PATH}
EOF

##################################################
# Service options
##################################################
# Common options
ENV_NAME=local
DEBUG=true
DB_LOG_MODE=true

## Core
OPEN_AI_TOKEN=your-token
CHAT_GPT_MODEL=gpt-3.5-turbo

## AWS SESSION (**do not commit credential**)
AWS_REGION=$AWS_REGION
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
### If not set aws session, set dummy data.
if [ -z "$AWS_REGION" ]; then
  AWS_REGION=ap-northeast-1
fi
if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  AWS_ACCESS_KEY_ID=dummy
fi
if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  AWS_SECRET_ACCESS_KEY=dummy
fi

# Service spcific options
## Diagnosis
WPSCAN_VULNDB_APIKEY=$WPSCAN_VULNDB_APIKEY

## Google
### Load form env
GOOGLE_SERVICE_ACCOUNT_JSON=$GOOGLE_SERVICE_ACCOUNT_JSON
GOOGLE_SERVICE_ACCOUNT_EMAIL=$GOOGLE_SERVICE_ACCOUNT_EMAIL
GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY=$GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY

### Set fixed value (dummy **dont commit credential**)
# GOOGLE_SERVICE_ACCOUNT_JSON='{"type": "service_account","project_id": "dummy","private_key_id":"dummy","private_key":"-----BEGIN PRIxxxx-----\nxxxx\n-----END PRIxxx-----\n","client_email":"dummy@dummy.iam.gserviceaccount.com","client_id": "xxx", "auth_uri":"https://accounts.google.com/o/oauth2/auth", "token_uri":"https://oauth2.googleapis.com/token", "auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs", "client_x509_cert_url":"https://www.googleapis.com/robot/v1/metadata/x509/dummy%40dummy.iam.gserviceaccount.com"}'
# GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY='-----BEGIN PRIxxx-----\\nxxx==\\n-----END PRIxxx-----'
# GOOGLE_SERVICE_ACCOUNT_EMAIL=dummy@dummy.iam.gserviceaccount.com

if [ -z "$GOOGLE_SERVICE_ACCOUNT_JSON" ]; then
  # set dummy key (datasource-api is required)
  GOOGLE_SERVICE_ACCOUNT_JSON='{"type": "service_account","project_id": "dummy","private_key_id":"dummy","private_key":"dummy","client_email":"dummy@dummy.iam.gserviceaccount.com","client_id": "dummy", "auth_uri":"https://accounts.google.com/o/oauth2/auth", "token_uri":"https://oauth2.googleapis.com/token", "auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs", "client_x509_cert_url":"https://www.googleapis.com/robot/v1/metadata/x509/dummy%40dummy.iam.gserviceaccount.com"}'
fi

## Code
GITHUB_DEFAULT_TOKEN=your-token
CODE_DATA_KEY=12345678901234567890123456789012

##################################################
# Make properties for configmap
##################################################
## Init
PROPERTIES_DIR="$LOCAL_DIR/properties"
mkdir -p $PROPERTIES_DIR
rm -f $PROPERTIES_DIR/*

## Core
### Alert
PROPERTIES_PATH="$PROPERTIES_DIR/core_alert.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "DB_LOG_MODE=$DB_LOG_MODE" >> "$PROPERTIES_PATH"

### Finding
PROPERTIES_PATH="$PROPERTIES_DIR/core_finding.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "DB_LOG_MODE=$DB_LOG_MODE" >> "$PROPERTIES_PATH"
echo "OPEN_AI_TOKEN=$OPEN_AI_TOKEN" >> "$PROPERTIES_PATH"
echo "CHAT_GPT_MODEL=$CHAT_GPT_MODEL" >> "$PROPERTIES_PATH"

### IAM
PROPERTIES_PATH="$PROPERTIES_DIR/core_iam.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "DB_LOG_MODE=$DB_LOG_MODE" >> "$PROPERTIES_PATH"

### Project
PROPERTIES_PATH="$PROPERTIES_DIR/core_project.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "DB_LOG_MODE=$DB_LOG_MODE" >> "$PROPERTIES_PATH"

### Report
PROPERTIES_PATH="$PROPERTIES_DIR/core_report.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "DB_LOG_MODE=$DB_LOG_MODE" >> "$PROPERTIES_PATH"

## Gateway
### Gateway
PROPERTIES_PATH="$PROPERTIES_DIR/gateway_gateway.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"

## DataSource
### API
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_api.properties"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"
echo "CODE_DATA_KEY=$CODE_DATA_KEY" >> "$PROPERTIES_PATH"
echo "GOOGLE_SERVICE_ACCOUNT_JSON=${GOOGLE_SERVICE_ACCOUNT_JSON//\\\n/\\\n}" >> "$PROPERTIES_PATH" # Google

### AccessAnalyzer
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_aws_accessanalyzer.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"

### AdminChecker
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_aws_adminchecker.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"

### CloudSploit
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_aws_cloudsploit.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"

### GuardDuty
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_aws_guardduty.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"

### Portscan
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_aws_portscan.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"

## Code
### Gitleaks
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_code_gitleaks.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"
echo "CODE_DATA_KEY=$CODE_DATA_KEY" >> "$PROPERTIES_PATH"
echo "GITHUB_DEFAULT_TOKEN=$GITHUB_DEFAULT_TOKEN" >> "$PROPERTIES_PATH"

### Dependency
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_code_dependency.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"
echo "CODE_DATA_KEY=$CODE_DATA_KEY" >> "$PROPERTIES_PATH"

### CodeScan
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_code_codescan.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"
echo "CODE_DATA_KEY=$CODE_DATA_KEY" >> "$PROPERTIES_PATH"
echo "GITHUB_DEFAULT_TOKEN=$GITHUB_DEFAULT_TOKEN" >> "$PROPERTIES_PATH"

## Diagnosis
### Diagnosis
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_diagnosis_diagnosis.properties"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"

### WPScan
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_diagnosis_wpscan.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"
echo "WPSCAN_VULNDB_APIKEY=$WPSCAN_VULNDB_APIKEY" >> "$PROPERTIES_PATH"

### Portscan
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_diagnosis_portscan.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"

### ApplicationScan
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_diagnosis_applicationscan.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"

## Google
### Asset
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_google_asset.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"
echo "GOOGLE_CREDENTIAL_PATH=$GOOGLE_CREDENTIAL_PATH" >> "$PROPERTIES_PATH"
echo "GOOGLE_SERVICE_ACCOUNT_JSON=${GOOGLE_SERVICE_ACCOUNT_JSON//\\\n/\\\n}" >> "$PROPERTIES_PATH"

### CloudSploit
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_google_cloudsploit.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"
echo "GOOGLE_SERVICE_ACCOUNT_EMAIL=$GOOGLE_SERVICE_ACCOUNT_EMAIL" >> "$PROPERTIES_PATH"

GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY_PROPERTIES_PATH="$PROPERTIES_DIR/GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY"
echo "$GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY" >> "$GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY_PROPERTIES_PATH"

### PortScan
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_google_portscan.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"
echo "GOOGLE_SERVICE_ACCOUNT_JSON=${GOOGLE_SERVICE_ACCOUNT_JSON//\\\n/\\\n}" >> "$PROPERTIES_PATH"

### SCC
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_google_scc.properties"
echo "DEBUG=$DEBUG" >> "$PROPERTIES_PATH"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"
echo "GOOGLE_SERVICE_ACCOUNT_JSON=${GOOGLE_SERVICE_ACCOUNT_JSON//\\\n/\\\n}" >> "$PROPERTIES_PATH"

## OSINT
### SubDomain
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_osint_subdomain.properties"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"

### Website
PROPERTIES_PATH="$PROPERTIES_DIR/datasource_osint_website.properties"
echo "AWS_REGION=$AWS_REGION" >> "$PROPERTIES_PATH"
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$PROPERTIES_PATH"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$PROPERTIES_PATH"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$PROPERTIES_PATH"
