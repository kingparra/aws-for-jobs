FROM ubuntu:latest

ENV AWS_ACCESS_KEY=$AWS_ACCESS_KEY \
    AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

# Install basic tools
RUN apt-get update && \
    apt-get install -y curl git sudo

# Install HashiCorp's official GPG key
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

# Add the HashiCorp official repository to the list of package sources
RUN sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Update package list and install packages
RUN apt-get update && \
    apt-get install -y terraform packer golang ansible

# Set the working directory to /project
WORKDIR /project

# Bind mount the current directory to /project
VOLUME [ "/project" ]

# Set the command to run the /project/run file
CMD [ "/bin/bash", "-c", "/project/run" ]
