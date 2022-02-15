set -e

BRANCH=${1:-release-5.3}

echo "Deploying elasticsearch-operator"
if [ ! -d elasticsearch-operator ]; then
  git clone https://github.com/openshift/elasticsearch-operator.git
fi
cd elasticsearch-operator || exit 1
git checkout "$BRANCH"
git pull
make elasticsearch-cleanup || exit 1
cd ..

echo
echo "Deploying cluster-logging-operator"
if [ ! -d cluster-logging-operator ]; then
  git clone https://github.com/openshift/cluster-logging-operator.git
fi
cd cluster-logging-operator || exit 1
git checkout "$BRANCH"
git pull

make undeploy || exit


