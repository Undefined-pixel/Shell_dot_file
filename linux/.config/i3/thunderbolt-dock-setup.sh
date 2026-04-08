#!/bin/bash
# Thunderbolt Dock Setup - HP Thunderbolt Dock G4
# Verhindert, dass das Dock nur als USB erkannt wird.
#
# Einmalig ausfuehren mit: sudo bash ~/.config/thunderbolt-dock-setup.sh

set -e

echo "=== Thunderbolt Dock Setup ==="

# 1. bolt-Dienst aktivieren und starten
echo "[1/3] Aktiviere bolt.service ..."
systemctl enable --now bolt.service

# 2. Warten bis bolt das Dock erkennt
echo "[2/3] Warte auf Thunderbolt-Geraete ..."
sleep 2

# 3. Dock dauerhaft autorisieren (enroll)
echo "[3/3] Enrolle alle Thunderbolt-Geraete ..."
boltctl list
echo ""
echo "Enrolle alle Geraete mit --policy=auto ..."
for uuid in $(boltctl list | grep -oP '[0-9a-f-]{36}'); do
    echo "  -> Enrolle $uuid"
    boltctl enroll --policy auto "$uuid" 2>/dev/null || echo "     (bereits enrolled oder Host-Controller)"
done

echo ""
echo "=== Fertig! ==="
echo "Das Dock wird ab jetzt beim Anstecken automatisch als Thunderbolt autorisiert."
echo "Pruefe mit: boltctl list"
