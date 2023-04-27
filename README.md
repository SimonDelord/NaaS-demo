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


## Example of a simple VPN configuration 

For this step, use the ACS-Operator.yaml file [here](https://github.com/SimonDelord/ACM-Templates/blob/master/resources12/ACS-Operator.yaml).
You could also enforce the creation of the stackrox namespace on each cluster as part of the policy.

## 2nd Step: Deploy ACS Central using an application

For this step, you can simply point the Application creation template to the ACS-Central folder in this Git Repo.
I selected local-cluster for the deployment of Central.
Once ACS Central has come up and is ready, you will need to generate a secret-bundle that will be imported for all clusters that need to be monitored by ACS. 

## 3rd step: Deploy ACS Secured Cluster using applications

For this step, you first need to deploy the secret-bundle in all the relevant clusters (e.g all) in the stackrox namespace.
Either create the namespace as part of this step or step 1 via the policy.

Deploy the bundle from the ACS-Init-Bundle folder in this Git Repo. Obviously it's not recommended but used only for the demo.
Several options are available: sealed secrets, integration into 3rd party systems like Hachicorp Vault, use the Hub cluster for storing those secrets and deploy from the Hub.

Finally use applications to deploy the ACS Secured Cluster to all those clusters. It would be good to have something that automatically generates the right configuration for each cluster rather than having but for the simplicity of the demo I splited those files into different repos.


![Browser](https://github.com/SimonDelord/ACM-Templates/blob/master/resources12/images/ACM-ACS-Integration-photo2.png)
Compliance Operator deployment and configuration by ACM


## 4th Step: ACM deploys the compliance operator on all clusters using a policy

This step is simple, it uses a pre-existing ACM policy for Compliance Operator.
Just go into the Governance section and apply the "compliance operator" policy to all clusters.

## 5th Step: ACM gets the Compliance Operator to run a Scan for E8 and CIS using an application

For this step use the files in the Compliance-Operator-Scan folder


## 6: ACS displays the results of the initial Compliance Operator E8 / CIS scan
Just log into ACS Central and displays the results (may take a few minutes to be displayed). 
