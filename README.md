#Rearc Quest notes

As an Azure native for the last 3 years, I opted to do this in AWS as a way to hopefully show versatility in the cloud.

Upon Dockerizing and running the image locally, there is a message on the terminal saying "ReArc is listening on port 3000", and the browser that told me: "It seems like you're not running this in the cloud" which was reassurance that I successfully compiled the image. Adjusted my Dockerfile to expose 3000 and off to AWS I go.

I felt like it was important for me to go through the steps manually on AWS console as a way to better determine how to set this up with IAC.

I created a public repo in Amazon ECR: `quest-repository` (to avoid having to set up IAM initially), here is where I found the push commands to get my image in this repository.

After successfully pushing the image to ECR, I then set up an EC2 Linux + Networking cluster using the default VPC and security group.

Then I went to create a new Task Definition. In the Task Definition I added my container with port mapping 8080:3000 as well as various specs regarding the tasks memory / cpu values.

Finally, I ran the task inside the cluster that I created. After this succeeded, I went to the instances and found the Public DNS (IPv4) and pasted that in the browser with `:8080` and there sat little Yoda unsheathing his lightsaber.

As instructed by the rearc-quest documentation, I found the secret word on the index page to inject in the Dockerfile. I then created a new revision of my task definition after pushing an updated image with `ENV SECRET_WORD TwelveFactor` and after checking the link again I saw that it was able to read in my secret word.

I felt like now was a good time to start implementing the terraform logic as I understand how that was pieced together.
