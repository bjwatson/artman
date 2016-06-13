#!/bin/bash

#
# Initialize environment variables
#

GAPI_API=logging
GAPI_LANG=python
GAPI_VERSION=v2

SRCDIR=`readlink -f output/${GAPI_API}-${GAPI_VERSION}-gapic-gen-${GAPI_LANG}`
PROTODIR=`readlink -f output/${GAPI_LANG}`
DSTDIR=`readlink -f ../gapi-${GAPI_API}-${GAPI_LANG}`
PCKDIR=`readlink -f ../packman`
WEBDIR=/google/data/rw/users/br/brianwatson/www/gapi-${GAPI_API}-${GAPI_LANG}-${GAPI_VERSION}

PACKAGE=gcloud/pubsub

CWD=`pwd`
export PATH=$PCKDIR/bin:$PATH

#
# Functions
#

function initializePackman {
  cd $PCKDIR

  echo ''
  echo '>>> Initializing Packman'

  npm install
}

function cleanTarget {
  cd $DSTDIR

  echo ''
  echo '>>> Cleaning up target directory'

  git cho .
  rm -rf .tox dist docs gax_google_${GAPI_API}_${GAPI_VERSION}.egg-info
  rm -rf google gcloud
  rm -f LICENSE MANIFEST.in PUBLISHING.rst setup.cfg
}

function runPipeline {
  cd $CWD

  echo ''
  echo '>>> Generating code'

  python execute_pipeline.py \
    --config "../googleapis/gapic/api/artman_${GAPI_API}.yaml:common|${GAPI_LANG},\
              ../googleapis/gapic/lang/common.yaml:default|${GAPI_LANG}" \
    PythonGapicClientPipeline
  rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
}

function removeProtos {
  cd $SRCDIR

  echo ''
  echo '>>> Removing proto files from pipeline output'

  rm -rf $PACKAGE/google
}

function copyPipelineOutput {
  cd $SRCDIR

  echo ''
  echo '>>> Copying code into repo'

  mv *.json $PACKAGE
  cp -av * $DSTDIR
}

function generatePackage {
  cd $DSTDIR

  echo ''
  echo '>>> Generating API package'

  gen-api-package --api_name=${GAPI_API}/${GAPI_VERSION} --gax_dir=$DSTDIR -l ${GAPI_LANG}
  rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
}

function runTest {
  cd $DSTDIR

  echo ''
  echo '>>> Running doctest'

  tox -e doctest
  #tox -e doctest && tox -e doctest
  rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
}

function genDocs {
  cd $DSTDIR

  echo ''
  echo '>>> Generating docs'

  # TODO: figure out why first run of tox usually fails
  tox -e docs || tox -e docs
  rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
}

function publishDocs {
  cd $DSTDIR

  echo ''
  echo '>>> Publishing to personal web space'

  rm -rf $WEBDIR
  cp -Rv docs/_build/html $WEBDIR
  find $WEBDIR -type d -exec chmod o+rx {} \;
  find $WEBDIR -type f -exec chmod o+r {} \;
}

#
# Control Logic
#

initializePackman

#cleanTarget
#runPipeline
#removeProtos
#copyPipelineOutput
#generatePackage
#runTest

cleanTarget
runPipeline
copyPipelineOutput
generatePackage
genDocs
publishDocs
