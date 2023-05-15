This is the folder that explains how to configure Joget for the low-code frontend design

The installation of Joget on OpenShift is described here - https://dev.joget.org/community/display/DX8/Joget+on+OpenShift

Step 1: Create OpenShift Project
Step 2: Deploy MySQL Database
Step 3: Deploy Joget Certified Container Image
Step 4: Configure Persistent Storage
Step 5: Configure for Clustering and Licensing


oc adm policy add-scc-to-user anyuid -z default
