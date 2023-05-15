# NaaS-demo


This folder contains an simple overview on how to produce a Network as a Service (NaaS) solution.

A video of the demonstration is available [here](https://www.youtube.com/watch?v=HdjCVgJ63RY).

NaaS provides a complete operational framework that leverages:
- Event and  model-driven abstraction
- Standard Application Program Interfaces (APIs)
- Service lifecycle automation
- Microservices based architecture

![Browser](https://github.com/SimonDelord/NaaS-demo/blob/main/images/NaaS-HLA.png)


## NaaS high level building blocks

In this solution, a collection of network elements (physical appliances of various vendors send notification to the NaaS platform using events.

- the Broker Those events get published on the broker layer (e.g Kafka). [TBD]
- the API Gateway [TBD]
- the Platform [TBD]
- the microservices [TBD] -e.g the functions

All microservices / functions that need to access those events retrieve them from the broker to do whatever function they need to do (alarming, monitoring, performance, security, provisioning, etc...).

All microservices communicate between them using APIs.


## Example of a NaaS platform using Red Hat products

The following figure shows how a NaaS platform can be built using some of the Red Hat product portfolio.

![Browser](https://github.com/SimonDelord/NaaS-demo/blob/main/images/NaaS-using-RedHat-products.png)


Red Hat products used as part of the demo:
- NaaS hosting platform: OpenShift (OCP)
- Broker: AMQ Streams
- Network Stack: Ansible Automation Platform (AAP)

The following components could be added but due to lack of time have not:
- Object Store for long term retention of data: CEPH / ODF
- API Gateway: 3Scale

## platform Setup

The order in which the components are deployed:
 - OCP
 - ACM (as a way of automating the deployment of the rest of the environment)
 - Ansible Configuration (e.g authentication token) - more details is available in the Ansible subfolder of this Git Repo
 - AMQ Streams - more details is available in the AMQStreams subfolder of this Git Repo
 - Joget - more details is available in the Joget subfolder of this Git Repo

## Example of a simple VPN configuration 

This is the example of the demo. 

