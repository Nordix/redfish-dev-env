#!/bin/bash
source libvirt_utils.sh

VM_NAME_PREFIX='dummy_vm'
NETWORK_NAME='dev01'
VOLUME_POSTFIX='vol'
VM_COUNT=2
CPU_COUNT=1

if [ -z "$(virsh net-info "${NETWORK_NAME}")" ]; then
    # Network not found, create network NETWORK_NAME
    create_network "${NETWORK_NAME}"
else
    echo Network exists.
fi

# Create pool
if [ -z "$(virsh pool-info default)" ]; then
    create_pool
else
    echo Pool exists.
fi

for ((n = 0; n < "${VM_COUNT}"; n++)); do
    VM_NAME="${VM_NAME_PREFIX}_${n}"
    VOLUME_NAME="${VM_NAME}_${VOLUME_POSTFIX}"
    create_domain "${VM_NAME}" "${VOLUME_NAME}" "${CPU_COUNT}" "${NETWORK_NAME}"
done