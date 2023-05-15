This is the folder that explains how to configure Joget for the low-code frontend design

The installation of Joget on OpenShift is described here - https://dev.joget.org/community/display/DX7/Joget+on+OpenShift

 - Step 1: Create OpenShift Project
 - Step 2: Deploy MySQL Database
 - Step 3: Deploy Joget Certified Container Image
 - Step 4: Configure Persistent Storage
 - Step 5: Configure for Clustering and Licensing

For simplicity, I have been using the script on the landing page and changed the variables: 
 - export REGISTRY_USERNAME=email@domain
 - export REGISTRY_PASSWORD=password
 - export REGISTRY_EMAIL=email@domain

There seems to be a few issues:
 -  the DX8 documentation page doesn't pull the associated image - e.g there's a 503 error for registry.connect.redhat.com/joget/joget-dx8-eap7
 -  for both DX7 and DX8 documentation, if the namespace (e.g joget-openshift) is modified, the application deploys but cannot pass post DB configuration.
