#!/usr/bin/env bash
set -euo pipefail

REL="2fd31d4"
BASE="https://github.com/ssmirr/conduit/releases/download/${REL}"

BIN="/usr/local/bin/conduit"
UNIT="/etc/systemd/system/conduit.service"

DEFAULT_DATA_DIR="/var/lib/conduit"
DEFAULT_MAX_CLIENTS="50"
DEFAULT_BANDWIDTH="40"
DEFAULT_VERBOSE="vv"      # "", "v", "vv"
DEFAULT_JOURNAL_MB="50"

echo "=== Conduit Universal Installer (REL=${REL}) ==="

ARCH="$(uname -m || true)"
case "${ARCH}" in
  aarch64|arm64)
    URL="${BASE}/conduit-linux-arm64"
    PLATFORM="ARM64"
    ;;
  x86_64|amd64)
    URL="${BASE}/conduit-linux-amd64"
    PLATFORM="AMD64"
    ;;
  *)
    echo "ERROR: Unsupported arch: ${ARCH}"
    echo "Supported: aarch64/arm64, x86_64/amd64"
    exit 1
    ;;
esac

if [[ $EUID -ne 0 ]]; then
  echo "ERROR: Run as root (sudo -i)"
  exit 1
fi

echo "Detected platform: ${PLATFORM} (${ARCH})"
echo "Download URL: ${URL}"

read -r -p "Data dir (default: ${DEFAULT_DATA_DIR}): " DATA_DIR
DATA_DIR="${DATA_DIR:-$DEFAULT_DATA_DIR}"

read -r -p "Max clients (1-1000, default: ${DEFAULT_MAX_CLIENTS}): " MAX_CLIENTS
MAX_CLIENTS="${MAX_CLIENTS:-$DEFAULT_MAX_CLIENTS}"

read -r -p "Bandwidth Mbps (-1 unlimited, default: ${DEFAULT_BANDWIDTH}): " BANDWIDTH
BANDWIDTH="${BANDWIDTH:-$DEFAULT_BANDWIDTH}"

read -r -p "Verbose (empty/v/vv, default: ${DEFAULT_VERBOSE}): " VERBOSE
VERBOSE="${VERBOSE:-$DEFAULT_VERBOSE}"

read -r -p "journald max disk usage MB (default: ${DEFAULT_JOURNAL_MB}): " JOURNAL_MB
JOURNAL_MB="${JOURNAL_MB:-$DEFAULT_JOURNAL_MB}"

VFLAG=""
case "${VERBOSE}" in
  "")  VFLAG="";;
  "v") VFLAG="-v";;
  "vv") VFLAG="-vv";;
  *) echo "ERROR: Verbose must be empty, v, or vv"; exit 1;;
esac

echo "=== Stop old service (if any) ==="
systemctl stop conduit 2>/dev/null || true
systemctl disable conduit 2>/dev/null || true

echo "=== Install/refresh binary ==="
TMP="/tmp/conduit.$$"
curl -fsSL -o "${TMP}" "${URL}"
install -m 0755 "${TMP}" "${BIN}"
rm -f "${TMP}"

echo "Binary info:"
file "${BIN}" || true

echo "=== Create persistent data dir ==="
mkdir -p "${DATA_DIR}"
chmod 0755 "${DATA_DIR}"

echo "=== Write systemd unit (NO STATS) ==="
cat > "${UNIT}" <<EOF_UNIT
[Unit]
Description=Conduit Psiphon Proxy (native ${PLATFORM})
Documentation=https://github.com/ssmirr/conduit
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=${DATA_DIR}
ExecStart=${BIN} start ${VFLAG} -m ${MAX_CLIENTS} -b ${BANDWIDTH} -d ${DATA_DIR}
Restart=always
RestartSec=3
User=root
Group=root
StandardOutput=journal
StandardError=journal
TimeoutStartSec=60
TimeoutStopSec=10

[Install]
WantedBy=multi-user.target
EOF_UNIT

echo "=== Configure journald retention (size + 7d) ==="
mkdir -p /etc/systemd/journald.conf.d
cat > /etc/systemd/journald.conf.d/20-conduit-retention.conf <<EOF_J
[Journal]
SystemMaxUse=${JOURNAL_MB}M
MaxRetentionSec=7d
EOF_J

systemctl daemon-reload
systemctl restart systemd-journald

echo "=== Enable & start ==="
systemctl daemon-reload
systemctl reset-failed conduit 2>/dev/null || true
systemctl enable --now conduit

echo "=== OK ==="
systemctl --no-pager -l status conduit
echo "Live logs: journalctl -fu conduit.service"
