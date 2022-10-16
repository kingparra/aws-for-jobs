#!/usr/bin/env bash

generateSgName() {
	pwmake 80 | tr -d '[:punct:]'
}

createSg() {
	aws ec2 create-security-group \
		--description "$1"\
		--group-name "$2" \
		--query 'GroupId' \
		--output text # prevent quotes around output
}

allowHttpsAndSsh() {
	group_id=$1
	aws ec2 authorize-security-group-ingress \
		 --group-id "$group_id" \
		 --protocol tcp \
		 --port 80
	aws ec2 authorize-security-group-ingress \
		 --group-id "$group_id" \
		 --protocol tcp \
		 --port 22
} &>/dev/null

getRegion() { aws configure get region; }

getLatestAmzlinuxAmi() {
	aws ssm get-parameters \
		--names /aws/service/ami-amazon-linux-latest\
/amzn2-ami-hvm-x86_64-gp2 \
		 --query 'Parameters[0].[Value]' \
		 --output text
}

getSubnetId() {
	local az="'$1'"
	aws ec2 describe-subnets \
		--query "Subnets[?AvailabilityZone==${az}].SubnetId" \
		--output text
}

getKeypairId() {
	local keyname="'$1'"
	aws ec2 describe-key-pairs \
		--query "KeyPairs[?KeyName==${keyname}].KeyPairId" \
		--output text
}

getSgId() {
	local group_name="'$1'"
	aws ec2 describe-security-groups \
		--query "SecurityGroups[?GroupName==${group_name}].GroupId"
}

main() {
	# Create a SG
	local sgid="$(createSg "mod1task1" "$(generateSgName)")"

	# Allow HTTP and SSH ingress on that SG
	allowHttpsAndSsh "$sgid"

	tagspec="ResourceType='instance'"
	tagspec+=","
	tagspec+="Tags=["
		tagspec+="{Key='Name',Value='DevServer'}"
		tagspec+=",{Key='Env',Value='Dev'}"
		tagspec+=",{Key='Terminate',Value='yes'}"
	tagspec+="]"

	read -r -d $'\0' instance_ids < \
		<(aws ec2 run-instances                                \
			`# dont bill me, im a poor student#`               \
			--instance-type t2.micro                           \
			`# deploy two ec2 instances#`                      \
			--count 2                                          \
			`# of the latest amazon linux ami#`                \
			--image-id "$(getLatestAmzlinuxAmi)"               \
			`# on subnet us-east-1c`                           \
			--subnet-id "$(getSubnetId us-east-1c)"            \
			`# with a security group that allows ssh and http` \
			--security-group-id "$sgid"                        \
			`# attach your keypair`                            \
			--key-name testsrv                                 \
			`# and bootstrap it with your user-data script`    \
			--user-data ./scripts/dev.bash                     \
			`# apply tags to instances`                        \
			--tag-specifications "$tagspec"                    \
			--query "Instances[*].InstanceId"                  \
			--output text
		)

	echo "$instance_ids"
}


main
