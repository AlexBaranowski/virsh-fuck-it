#!/usr/bin/env bash
# author: Alex Baranowski
# License: MIT


set -euo pipefail


purge_virsh_doms(){
    for domain_name in $(virsh list --all --name ); do
        virsh destroy --domain "$domain_name" || echo "domain already destroyed"
        virsh undefine --domain "$domain_name" || virsh undefine --domain "$domain_name" --nvram || echo "domain already undefined"
    done
}

purge_virsh_vols(){
    # virsh vol-list does not have option like --id or something like it xDDD <lol>
    # tail -n +3 skip first two lines
    for i in $(virsh vol-list --pool default | tail -n +3 | awk '{print $1}'); do 
        echo "Removing $i libvirt volume"
        virsh vol-delete --pool default "$i"
    done
}


main(){
    purge_virsh_doms
    purge_virsh_vols
}

main
