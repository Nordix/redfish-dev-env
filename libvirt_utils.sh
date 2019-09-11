#!/bin/bash

create_network() {
    export NETWORK_NAME="${1}"
    envsubst <"./templates/network.xml" >"./templates/network_tmp.xml"
    if [ -z "$(virsh net-info "${NETWORK_NAME}")" ]; then
        # Network not found, create network NETWORK_NAME
        virsh net-create --file ./templates/network_tmp.xml
        echo Creating network "${NETWORK_NAME}"
    else
        echo Network already exists.
    fi
    rm -r ./templates/network_tmp.xml
}

create_pool() {
    # Create pool
    if [ -z "$(virsh pool-info default)" ]; then
        # Default pool not found, create pool
        echo Creating default pool
        virsh pool-create --file ./templates/pool.xml
    else
        echo Pool exists.
    fi
}

create_domain() {
    export VM_NAME="${1}"
    export VOLUME_NAME="${2}"
    export CPU_COUNT="${3}"
    export NETWORK_NAME="${4}"
    envsubst <"./templates/vm.xml" >"./templates/vm_tmp.xml"

    # Create volume
    if [ -z "$(virsh vol-info "${VOLUME_NAME}" default)" ]; then
        # Create volume
        echo Creating volume "${VOLUME_NAME}"
        virsh vol-create-as default "${VOLUME_NAME}" 8G
    else
        # Old volume with same name found, delete old one and create new
        echo Deleting old volume
        virsh vol-delete "${VOLUME_NAME}" default
        echo Creating volume
        virsh vol-create-as default "${VOLUME_NAME}" 8G
    fi

    # Create virtual machine
    if [ -z "$(virsh dominfo "${VM_NAME}")" ]; then
        # Create new virtual machine
        echo Creating "${VM_NAME}" virtual machine
        virsh create --file ./templates/vm_tmp.xml
    else
        # Old vm with same name found, delete old one and create new
        echo Deleting old virtual machine
        virsh destroy "${VM_NAME}"
        virsh undefine "${VM_NAME}"
        echo Creating virtual machine
        virsh create --file ./templates/vm_tmp.xml
    fi
    rm -r ./templates/vm_tmp.xml
}

delete_dev_env() {

    VM_NAME_PREFIX="${1}"
    NETWORK_NAME="${2}"
    VOLUME_POSTFIX="${3}"
    VM_COUNT="${4}"
    
    if [ "$(virsh net-info "${NETWORK_NAME}")" ]; then
        echo Deleting network ${NETWORK_NAME}
        virsh net-destroy ${NETWORK_NAME}
        virsh net-undefine ${NETWORK_NAME}
    fi

    for ((n = 0; n < "${VM_COUNT}"; n++)); do
        VM_NAME="${VM_NAME_PREFIX}_${n}"
        VOLUME_NAME="${VM_NAME}_${VOLUME_POSTFIX}"
        
        echo Destroying and undefining virtual machine "${VM_NAME}"
        virsh destroy "${VM_NAME}"
        virsh undefine "${VM_NAME}"
        echo Deleting volume "${VOLUME_NAME}"
        virsh vol-delete "${VOLUME_NAME}" default

    done
}