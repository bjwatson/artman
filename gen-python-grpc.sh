#!/bin/bash

#
# Initialize environment variables
#

GAPI_API=logging
GAPI_LANG=python
GAPI_VERSION=v2

SRCDIR=`readlink -f output/${GAPI_LANG}`
DSTDIR=`readlink -f ../grpc-${GAPI_API}-${GAPI_LANG}`
PCKDIR=`readlink -f ../packman`

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

function cleanOutput {
  cd $CWD

  echo ''
  echo '>>> Cleaning up target directory'

  rm -rf $SRCDIR
}

function cleanTarget {
  cd $DSTDIR

  echo ''
  echo '>>> Cleaning up target directory'

  git cho .
  rm -rf .tox dist docs gax_google_${GAPI_API}_${GAPI_VERSION}.egg-info
  rm -rf google gcloud
  rm -f LICENSE MANIFEST.in PUBLISHING.rst setup.cfg
  find . -name '*.pyc' -exec rm {} \;
}

function runPipeline {
  cd $CWD

  echo ''
  echo '>>> Generating code'

  python execute_pipeline.py \
    --config "../googleapis/gapic/api/artman_${GAPI_API}.yaml:common|${GAPI_LANG},\
              ../googleapis/gapic/lang/common.yaml:default|${GAPI_LANG}" \
    PythonGrpcClientPipeline
  rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
}

function copyPipelineOutput {
  cd $SRCDIR

  echo ''
  echo '>>> Copying code into repo'

  cp -av google MANIFEST.in README.rst setup.py $DSTDIR
}

#
# Control Logic
#

initializePackman

cleanOutput
cleanTarget
runPipeline
copyPipelineOutput
