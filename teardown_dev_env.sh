#!/bin/bash
source libvirt_utils.sh

VM_NAME_PREFIX='dummy_vm'
NETWORK_NAME='dev01'
VOLUME_POSTFIX='vol'
VM_COUNT=2 
CPU_COUNT=1

delete_dev_env ${VM_NAME_PREFIX} ${NETWORK_NAME} ${VOLUME_POSTFIX} ${VM_COUNT}