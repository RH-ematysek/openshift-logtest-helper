set -e

BRANCH=${1:-release-5.3}

echo "Deploying elasticsearch-operator"
if [ ! -d elasticsearch-operator ]; then
  git clone -b "$BRANCH" https://github.com/openshift/elasticsearch-operator.git --depth 1
  cd elasticsearch-operator || exit 1
else
  cd elasticsearch-operator || exit 1
  git checkout "$BRANCH"
  git pull
fi
make elasticsearch-cleanup || exit 1
cd ..

echo
echo "Deploying cluster-logging-operator"
if [ ! -d cluster-logging-operator ]; then
  git clone -b "$BRANCH" https://github.com/openshift/cluster-logging-operator.git --depth 1
  cd cluster-logging-operator || exit 1
else
  cd cluster-logging-operator || exit 1
  git checkout "$BRANCH"
  git pull
fi
make undeploy || exit


