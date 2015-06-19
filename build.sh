#!/bin/sh

PERL=`which perl`
PYTHON=`which python`

WHOAMI=`${PYTHON} -c 'import os, sys; print os.path.realpath(sys.argv[1])' $0`
WHEREAMI=`dirname $WHOAMI`

PROJECT=`${PYTHON} -c 'import os, sys; print os.path.realpath(sys.argv[1])' $1`

if [ -e ${PROJECT} ]
then
    echo "${PROJECT} already exists. I'm scared..."
    exit 1
fi

mkdir -p ${PROJECT}

cp ${WHEREAMI}/Vagrantfile.template ${PROJECT}/Vagrantfile
cp ${WHEREAMI}/Makefile.template ${PROJECT}/Makefile
cp ${WHEREAMI}/.gitignore.template ${PROJECT}/.gitignore

NAME=`basename ${PROJECT}`

${PERL} -pi -e "s!__VAGRANT_NAME__!${NAME}!" ${PROJECT}/Vagrantfile
${PERL} -pi -e "s!__VAGRANT_HOSTNAME__!${NAME}!" ${PROJECT}/Vagrantfile

echo "What port should we forward port 80 to: "
read PORT

${PERL} -pi -e "s!__VAGRANT_HOST_80__!${PORT}!" ${PROJECT}/Vagrantfile

echo "What port should we forward port 443 to: "
read PORT

${PERL} -pi -e "s!__VAGRANT_HOST_443__!${PORT}!" ${PROJECT}/Vagrantfile

echo "Shell hoohah on build: "
read SHELL

if [ "${SHELL}" != "" ]
then
    if [ -e ${SHELL} ]
    then
	echo "reading data for shell hoohah from ${SHELL}"
	SHELL=`cat ${SHELL}`
    fi
fi

${PERL} -pi -e "s!__VAGRANT_SHELL__!${SHELL}!" ${PROJECT}/Vagrantfile

echo "Spin up ${NAME} now (y/n): "
read UP

if [ "${UP}" == "y" ]
then

    cd ${PROJECT}
    echo vagrant up
    cd -
fi

echo "all done"
exit 0