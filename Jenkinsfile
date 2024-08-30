pipeline{
    agent any
    options {
        timeout(time: 1, unit: 'HOURS')
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        retry(3)
        timestamps()
    }
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '121196576469'
        AWS_ECS_SERVICE_NAME = 'shan-ecs-demo-service'
        AWS_ECS_TASK_DEFINITION = 'shan-ecs-demo-fargate'
        AWS_ECS_COMPATIBILITY = 'FARGATE'
        AWS_ECS_NETWORK_MODE = 'awsvpc'
        AWS_ECS_CPU = '1024'
        AWS_ECS_MEMORY = '2048'
        AWS_ECS_CLUSTER = 'shan-ecs-cluster'
        AWS_ECS_TASK_DEFINITION_PATH = './ecs-task-def/ecstaskdef.json'
        AWS_ECR_REPOSITORY_URI = '121196576469.dkr.ecr.us-east-1.amazonaws.com/shan-ecs-ecr-repo'
        IMAGE_REPO_NAME = 'shan-ecs-ecr-repo'
        IMAGE_TAG = "v1"
        GIT_URL = 'https://github.com/kumashan1102/shan-ecs-demo.git'
        GIT_BRANCH = 'main'
    }
    stages {
    stage ('Building Image') {
        steps {
            script {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'AWS_ACCESS_KEY'), string(credentialsId: 'AWS_SECRET_KEY', variable: 'AWS_SECRET_KEY')]) {
                    sh """/usr/local/bin/aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"""
                    dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                    sh """
                        docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:${IMAGE_TAG}
                        docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}
                       """
                }
            }
        }
    }
    stage('Deploying') {
        steps {
            script {
                sh """/usr/local/bin/aws ecs register-task-definition --cli-input-json file://ecs-task-def/ecstaskdef.json"""
                def SERVICES = sh """/usr/local/bin/aws ecs describe-services --services ${AWS_ECS_SERVICE_NAME} --cluster ${AWS_ECS_CLUSTER} --region ${AWS_DEFAULT_REGION} | jq .failures[]"""
                sh """
                      if [ "$SERVICES" == "" ]; then
                          echo "entered existing service"
                          DESIRED_COUNT=`/usr/local/bin/aws ecs describe-services --services ${AWS_ECS_SERVICE_NAME} --cluster ${AWS_ECS_CLUSTER} --region ${AWS_DEFAULT_REGION} | jq .services[].desiredCount`
                          if [ ${DESIRED_COUNT} = "0" ]; then
                             DESIRED_COUNT="1"
                          fi
                          /usr/local/bin/aws ecs update-service --cluster ${AWS_ECS_CLUSTER} --region ${AWS_DEFAULT_REGION} --service ${AWS_ECS_SERVICE_NAME} --task-definition ${AWS_ECS_TASK_DEFINITION} --desired-count ${DESIRED_COUNT}
                      else
                          echo "entered new service"
                          /usr/local/bin/aws ecs create-service --service-name ${AWS_ECS_SERVICE_NAME} --desired-count 1 --task-definition ${AWS_ECS_TASK_DEFINITION} --cluster ${AWS_ECS_CLUSTER} --region ${AWS_DEFAULT_REGION}
                      fi
                   """
                }

            }

        }
    }
    
    post {
        failure {
            // notify users when the Pipeline fails
            mail to: 'kshantanu1@gmail.com',
            subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
            body: "Something is wrong with ${env.BUILD_URL}"
        }
    }
}