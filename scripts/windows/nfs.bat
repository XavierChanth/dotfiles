umount -f N:
mount -o retry=5 -o fileaccess=755 -o nolock -u:chant <nfs-domain>:<nfs-path> N:
