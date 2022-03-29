# Rearc Quest | Anthony Ray

## Prerequisites:
* AWS CLI
* Terraform
* Docker
* Git

## Instructions:

After cloning the repo, cd into the root directory

`docker build -t quest-ecr-repo .`

After this, I went to the ECS console -> Repositories -> new repository and created an ECR repo: `quest-ecr-repo`
* following this is a `View Push Commands` link that will show you directly how to get this image on your repo

Next, we'll want to cd into `terraform-quest`
* `terraform init`
* `terraform plan`
* `terraform apply`

If all goes according to plan this should spin up the infrastructure required to launch the application from the load balancer public DNS.

## Future Developments

If I had more time to be able to spend on this project there are a few things I would do differently.

**.tfstate**: Using an S3 backened, it would be ideal to offload the `.tfstate` file there as a way of version control whilst working in a team environment.

**Manual processes**: I would have liked to fully implement IAC across the board, however, using the time I spent exploring AWS (as an Azure native); I wanted to understand more completely the ins and outs of AWS / TF Registry for AWS. To eliminate the manual process in the beginning which is required to get the application up and running; I would have liked to implement a github action which would build and send the latest version of the image from the git repo to the ECR repository when a new commit is pushed.

 **main.tf**: Another shortcoming I've identified in this submission is the fact that all (or most) of my TF logic is stored in `main.tf`. It's quite messy and would not be submitted in a production environment by me, however, with this quest I took as much time as I could to get a working solution. The reason for separating out into modules is reusability & versioning. If we wanted to get real fancy, I would also suggest using remote sources to a git repo for all of the modules. This could make versioning a little easier by utilizing git tags.

**vpc**: instead of directing the application to use the default VPC & subnets, it would be more efficient to include a module to be shared within the terraform logic outside of the defaults.

## My Process:

This is my attempt at the Rearc cloud technical quest, which includes a web app made with node.js and golang. With the provided code, I pulled that into my own repo and began working.

*TL;DR: started manually then converted & implemented most to IAC.*

As an Azure native for the last 3 years, I opted to do this in AWS as a way to hopefully show versatility in the cloud. I felt like it was important for me to go through the steps manually on AWS console so I could better determine how to set this up with IAC.

Upon Dockerizing and running the image locally, there is a message on the terminal saying ``"Rearc is listening on port 3000"``, and the browser that told me: ``"It seems like you're not running this in the cloud"`` - which was reassurance that I successfully compiled the image. Adjusted my Dockerfile to expose 3000 and off to AWS I go.

I created a public repo in Amazon ECR: `quest-repository` (to avoid having to set up IAM initially), here is where I found the push commands to get my image in this repository.

After successfully pushing the image to ECR, I then set up an EC2 Linux + Networking cluster using the default VPC and security group.

Then I went to create a new Task Definition. In the Task Definition I added my container with port mapping 8080:3000 as well as various specs regarding the tasks memory / cpu values.

Finally, I ran the task inside the cluster that I created. After this succeeded, I went to the instances and found the Public DNS (IPv4) and pasted that in the browser with `:8080` and there sat little Yoda unsheathing his :stars:lightsaber:stars:.

As instructed by the rearc-quest documentation, I found the secret word on the index page to inject in the Dockerfile. I then created a new revision of my task definition after pushing an updated image with `ENV SECRET_WORD TwelveFactor` and after checking the link again I saw that it was able to read in my secret word.

I felt like now was a good time to start implementing the terraform logic as I understand how that was pieced together. Utilizing the Terraform Registry as well as examples within community modules; I was able to get something built out using terraform.

In the `terraform-quest` folder, I have two files, `main.tf` and `references.tf`, based on your region, there may be a few alterations needed in order to get this application working on your own. Something I would have like to do is segregate a bit more some of the values in `main.tf` into other files for a cleaner look as well as read in the users default region, then updating the `main.tf` & `references.tf` using dot notation to specify the users region automatically.

Building out the load balancer was fairly painless when using community modules/registry as examples. In order for my load balancer to work, I needed to create a target group and a listener. Each target group will be used to route requests to the 3 our containers. I then linked my ECS service to my load balancer.

Finally, I was experiencing issues with the status of the containers reading `Unhealthy` -- I found out this was due to the ECS service not allowing traffic in by default. A security group was needed. Afterward the security group was added to the load balancer application, I was able to follow the public dns from the load balancer successfully

One thing I did notice was after deploying via a load balancer, it didn't recognize that I was running in a Docker Container but it was still able to read in the secret word that I injected into the image.

## Final Notes:
As I am very interested and eager to learn more about the tools involved in the request, I'm going to keep the resource alive for a bit to hopefully fine tune and improve on the application as I have time!

Yoda Link: http://test-lb-tf-397374605.us-east-2.elb.amazonaws.com/

## Screenshots:
* ![Alt text](/img/yoda1.png?raw=true "First take")
---

* ![Alt text](/img/yoda2.png?raw=true "Second take")
---

* ![Alt text](/img/yoda3.png?raw=true "Third take")
