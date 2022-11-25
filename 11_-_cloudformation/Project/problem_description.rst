Create a windows server and connect to it using RDP
***************************************************

In this project you will be deploying a Windows EC2 Instance.
For that, you will create an AWS CloudFormation template which
will create several resources: VPC, Internet Gateway, a public
subnet, a route table, a Windows EC2 instance, and a security
group. The main purpose of the guided Project is to teach how
create the template and ultimately how to connect to the Windows
Instance using RDP

Download VS code (It will be used to create the template) Choose
your Operating System: https://code.visualstudio.com/download

Let start creating the template! CloudFormation accepts two
types of languages: JSON (JavaScript Object Notation) and YAML
(YAML Ain’t Markup Language). For simplicity, we have decided to
use YAML to create the CloudFormation template. YAML works with
indentation. All sections in the template are in the same level.
Carefully consider the spaces in the template as that represents
the hierarchy of the elements.

Create a folder in your Desktop and name it Project

Inside the Project folder, create a file named
project-yellowtail.yaml

Open VS Code, drag the folder Project and drop it in VS Code (VS
Code will show the folder and file in the Explorer)

Now that we have created the file, it’s time to add code to it.
