mkdir -p "/var/lib/wemulate"

if [ -n "${MGMT_INTERFACE-}" ]; then
    wemulate config set -m $MGMT_INTERFACE --force
fi
