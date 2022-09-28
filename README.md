# sretest-niaga

This is for test on position for Site Reliability Engineer at Niagahoster.
This repository contained terraform for automation create VM, Chef for provisioning Infrastructure and repository of Swarm Example : Microservice App.

# Infrastructure Diagram
![Untitled Diagram drawio](https://user-images.githubusercontent.com/13705024/192669924-a00e9f24-fc83-4f6e-8c6a-bd3d193378c6.png)

In this diagram, We will provision each server using chef to automate :
- Install Jenkins Master on VM01
- Install Docker in every servers
- Configure Docker Swarm Manager on VM01
- Configure Docker Swarm Worker on VM02 & VM03
- Install depedencies

# How Pipeline Works
![Untitled Diagram drawio (1)](https://user-images.githubusercontent.com/13705024/192671096-73f23fec-f8a8-4dc0-8a37-5555d196f4a7.png)

- Developer push code changes to Github
- Github will trigger webhook to send build job to Jenkins
- Jenkins will build, compile and test docker image and then push image to Docker hub
- After build successfully done, it will trigger deployment job to apply rolling update to each servers.
