#!/bin/bash
source create_resource.sh

VM_NAME_PREFIX='dummy_vm'
NETWORK_NAME='dev01'
VOLUME_POSTFIX='vol'
VM_COUNT=2 
CPU_COUNT=1

if [ "$(virsh net-info "${NETWORK_NAME}")" ]; then
    virsh net-destroy ${NETWORK_NAME}
fi

for ((n=0;n<"${VM_COUNT}";n++))
do
    VM_NAME="${VM_NAME_PREFIX}_${n}"
    VOLUME_NAME="${VM_NAME}_${VOLUME_POSTFIX}"
    virsh destroy "${VM_NAME}"
    virsh vol-delete "${VOLUME_NAME}" default

done
