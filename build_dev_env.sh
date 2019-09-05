#!/bin/bash
source create_resource.sh

VM_NAME_PREFIX='dummy_vm'
NETWORK_NAME='dev01'
VOLUME_POSTFIX='vol'
VM_COUNT=2 
CPU_COUNT=1

if ! [ "$(virsh net-info "${NETWORK_NAME}")" ]; then
    # Network not found, create network NETWORK_NAME
    create_network "${NETWORK_NAME}"
fi

# Create pool
if ! [ "$(virsh pool-info default)" ]; then
    #create_pool
    echo hep
fi

for ((n=0;n<"${VM_COUNT}";n++))
do
    VM_NAME="${VM_NAME_PREFIX}_${n}"
    VOLUME_NAME="${VM_NAME}_${VOLUME_POSTFIX}"
    create_domain "${VM_NAME}" "${VOLUME_NAME}" "${CPU_COUNT}" "${NETWORK_NAME}"

done
