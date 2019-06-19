#!/bin/bash

export BASE_VER=R7.0.1.1
export PVA=
export BUSY_VER=1-7
export SEQ_VER=2.2.5
export ASYN_VER=4-33
export CALC_VER=3-7
export AUTOSAVE_VER=5-9
export SSCAN_VER=2-11-1
export MOTOR_VER=6-10
export AREADETECTOR_VER=3-2
export CI_TOP=/home/travis/ci
export CI_SCRIPTS=/home/travis/ci/ci-scripts
export EPICS_ON_TRAVIS_VERSION=0.8.1
export EPICS_ON_TRAVIS_PKG=0.8.1/epics-ci-0.8.1_R7.0.1.1_pva_areadetector3-2_motor6-10.tar.bz2
export EPICS_ON_TRAVIS_URL=https://github.com/klauer/epics-on-travis/releases/download/${EPICS_ON_TRAVIS_PKG}
export PUBLISH_DOCS=true
export TEST_CL=pyepics

if [ -f "$CI_SCRIPTS/epics-config.sh" ]; then
    source "${CI_SCRIPTS}/epics-config.sh"
fi

export EPICS_CA_ADDR_LIST=
export EPICS_CA_AUTO_ADDR_LIST=YES
