#!/bin/sh
export PROJECT_NAME=joget-openshift
export REGISTRY_USERNAME=email@domain
export REGISTRY_PASSWORD=password
export REGISTRY_EMAIL=email@domain
export REGISTRY_SERVER=registry.connect.redhat.com
export IMAGE_NAMESPACE=joget
export IMAGE_NAME=joget-dx7-eap7
export IMAGE_TAG=latest
export APP_NAME=joget-dx7-eap7
export DB_APP_NAME=jogetdb
export STORAGE_NAME=joget-data
export MYSQL_DATABASE=jwdb
export MYSQL_USER=joget
export MYSQL_PASSWORD=joget
 
echo === deploy Joget on OpenShift ===
echo PROJECT_NAME: $PROJECT_NAME
echo REGISTRY_SERVER: $REGISTRY_SERVER
echo REGISTRY_USERNAME: $REGISTRY_USERNAME
echo REGISTRY_EMAIL: $REGISTRY_EMAIL
echo IMAGE_NAMESPACE: $IMAGE_NAMESPACE
echo IMAGE_NAME: $IMAGE_NAME
echo IMAGE_TAG $IMAGE_TAG
echo IMAGE_NAME: $IMAGE_NAME
echo APP_NAME: $APP_NAME
echo DB_APP_NAME: $DB_APP_NAME
echo STORAGE_NAME: $STORAGE_NAME
echo MYSQL_DATABASE: $MYSQL_DATABASE
echo MYSQL_USER: $MYSQL_USER
echo MYSQL_PASSWORD: $MYSQL_PASSWORD
  
echo === create project ===
oc new-project $PROJECT_NAME
  
echo === deploy MySQL ===
oc new-app openshift/mysql:8.0 --name $DB_APP_NAME -e MYSQL_USER=$MYSQL_USER -e MYSQL_PASSWORD=$MYSQL_PASSWORD -e MYSQL_DATABASE=$MYSQL_DATABASE
  
echo === create and bind secret to pull Joget image ===
oc create secret docker-registry $REGISTRY_SERVER --docker-server=$REGISTRY_SERVER --docker-username=$REGISTRY_USERNAME --docker-password=$REGISTRY_PASSWORD --docker-email=$REGISTRY_EMAIL
oc secrets link default $REGISTRY_SERVER --for=pull
  
echo === assign cluster role view permission for the project service account to read deployment info for licensing ===
oc create clusterrolebinding default-view --clusterrole=view --serviceaccount=$PROJECT_NAME:default --namespace=$PROJECT_NAME
  
echo === create joget deployment, service and persistent volume claim ===
cat <<EOF > joget.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $APP_NAME-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: v1
kind: Service
metadata:
  name: $APP_NAME
  labels:
    app: $APP_NAME
spec:
  ports:
  - port: 8080
  selector:
    app: $APP_NAME
  type: NodePort
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $APP_NAME
spec:
  selector:
    matchLabels:
      app: $APP_NAME
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: $APP_NAME
    spec:
      containers:
      - image: registry.connect.redhat.com/joget/joget-dx7-eap7:latest
        name: $APP_NAME
        env:
        - name: JGROUPS_PING_PROTOCOL
          value: "openshift.DNS_PING"
        - name: OPENSHIFT_DNS_PING_SERVICE_NAME
          value: "$APP_NAME-ping"
        - name: OPENSHIFT_DNS_PING_SERVICE_PORT
          value: "8888"
        - name: CACHE_NAME
          value: "http-session-cache"
        ports:
        - containerPort: 8080
          name: $APP_NAME
        volumeMounts:
        - name: $APP_NAME-persistent-storage
          mountPath: /home/jboss/wflow
      volumes:
      - name: $APP_NAME-persistent-storage
        persistentVolumeClaim:
          claimName: $APP_NAME-pvc
---       
kind: Service
apiVersion: v1
metadata:
  name: $APP_NAME-ping
  labels:
    app: $APP_NAME
spec:
  clusterIP: None
  ports:
    - name: $APP_NAME-ping
      port: 8888
  selector:
    app: $APP_NAME
---
kind: Route
apiVersion: route.openshift.io/v1
metadata:
  name: $APP_NAME
  labels:
    app: $APP_NAME
  annotations:
    haproxy.router.openshift.io/timeout: 600s
    openshift.io/host.generated: 'true'
spec:
  path: /jw
  to:
    kind: Service
    name: $APP_NAME
    weight: 100
  port:
    targetPort: 8080
  wildcardPolicy: None
EOF
oc apply -f joget.yaml
