#!/bin/bash

# Start clamd in background
echo "[+] Starting clamd..."
/usr/sbin/clamd -c /etc/clamd.d/scan.conf --foreground=false &

# Wait for the socket to be created
echo "[+] Waiting for clamd to be ready..."
for i in {1..20}; do
    if [ -S /var/run/clamd.scan/clamd.sock ]; then
        echo "[+] clamd is ready!"
        break
    fi
    sleep 1
done

# Show usage help
echo ""
echo "ClamAV container is running."
echo "You can now use:"
echo "  clamscan /scan               # Standalone scan"
echo "  clamdscan /scan              # Fast scan via clamd"
echo ""
exec /bin/bash
