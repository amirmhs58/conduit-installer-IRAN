#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "ERROR: Run as root (sudo -i)"
  exit 1
fi

echo "=== Stop/disable service ==="
systemctl stop conduit 2>/dev/null || true
systemctl disable conduit 2>/dev/null || true

echo "=== Remove unit file ==="
rm -f /etc/systemd/system/conduit.service
systemctl daemon-reload

echo "=== Remove binary ==="
rm -f /usr/local/bin/conduit

echo "=== Note ==="
echo "Data directory NOT deleted automatically."
echo "If you want to remove data too:"
echo "  rm -rf /var/lib/conduit   (or your chosen data dir)"

echo "Done."
