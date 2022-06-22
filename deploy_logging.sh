set -e

BRANCH=${1:-release-5.3}

echo "Deploying elasticsearch-operator"
if [ ! -d elasticsearch-operator ]; then
  git clone https://github.com/openshift/elasticsearch-operator.git
fi
cd elasticsearch-operator 
git checkout "$BRANCH"
git pull
make elasticsearch-catalog-deploy
make elasticsearch-operator-install
cd ..

echo
echo "Deploying cluster-logging-operator"
if [ ! -d cluster-logging-operator ]; then
  git clone https://github.com/openshift/cluster-logging-operator.git
fi
cd cluster-logging-operator
git checkout "$BRANCH"
git pull

#make deploy-image
#export IMAGE_CLUSTER_LOGGING_OPERATOR=image-registry.openshift-image-registry.svc:5000/openshift/origin-cluster-logging-operator
#make deploy-catalog

make cluster-logging-catalog-deploy
make cluster-logging-operator-install

echo

echo "To delete cluster-logging operator do: make undeploy"
echo "To delete elasticsearch-operator do: make elasticsearch-cleanup"
echo "Now you can: oc create -f cr.yaml"
