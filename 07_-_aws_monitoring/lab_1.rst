Lab 1
*****
Install CloudWatch agent on Amazon linux 2 AMI

Step1: Create IAM role and attached "CloudWatchAgentServerPolicy" permissions Policy

Step2: Create an EC2 instance and attached the role created earlier in IAM.

Open SSH port 22 for remote access to your instance.

Step3: Install CloudWatch agent on the EC2 instance

a. Become root:

sudo -i
b. Download the CW agent by running the command below:

wget https://s3.us-east-2.amazonaws.com/amazoncloudwatch-agent-us-east-2/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
c. Install the agent by running this command:

rpm -U ./amazon-cloudwatch-agent.rpm
d. Now  copy and run the below command of the wizard to configure our CW agent configuration file:

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
Follow the prompts in your terminal to configure cw agent file

e. Start the CW agent with the command below

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
Now we can head to CloudWatch in the console, by default cloudwatch agent pushes metrics to CloudWatch with this namespace CWAgent.

