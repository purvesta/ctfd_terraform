#!/bin/bash

echo "$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).${ctfd-fs-id}.efs.${region}.amazonaws.com:/    /data   nfs4    defaults" >> /etc/fstab;
mkdir /data;
mount -a;
