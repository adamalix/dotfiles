#!/bin/sh

SCM_BREEZE_DIR=$HOME/.scm_breeze
REPO=git@github.com:scmbreeze/scm_breeze.git

if [ ! -d $SCM_BREEZE_DIR ]; then
  git clone $REPO $SCM_BREEZE_DIR
fi
