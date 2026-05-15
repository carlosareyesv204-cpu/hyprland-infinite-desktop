#!/usr/bin/env bash
sleep 3
SPEED=1.6

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

KBD_DEV=$(python3 -c "
import glob, os

# Palabras que indican que NO es un teclado real
ignore_words = ['mouse', 'optical', 'system control', 'consumer control']
real_keyboard = None

for dev in sorted(glob.glob('/dev/input/event*')):
    try:
        with open('/sys/class/input/'+os.path.basename(dev)+'/device/name') as f:
            name = f.read().strip().lower()
        
        # Si tiene palabras a ignorar, saltar
        if any(word in name for word in ignore_words):
            continue
            
        # Verificar que sea un teclado
        if 'keyboard' in name or 'kbd' in name or 'gaming keyboard' in name:
            with open('/sys/class/input/'+os.path.basename(dev)+'/device/capabilities/ev') as f:
                caps = int(f.read().strip(), 16)
            if caps & 0x1:  # Tiene EV_KEY
                real_keyboard = dev
                break
    except:
        continue

# Si no encontramos un teclado "limpio", buscar cualquier teclado que no sea del ratón
if not real_keyboard:
    for dev in sorted(glob.glob('/dev/input/event*')):
        try:
            with open('/sys/class/input/'+os.path.basename(dev)+'/device/name') as f:
                name = f.read().strip().lower()
            
            # Excluir explícitamente el teclado del ratón
            if 'optical mouse keyboard' in name:
                continue
                
            if 'keyboard' in name or 'kbd' in name:
                with open('/sys/class/input/'+os.path.basename(dev)+'/device/capabilities/ev') as f:
                    caps = int(f.read().strip(), 16)
                if caps & 0x1:
                    real_keyboard = dev
                    break
        except:
            continue

print(real_keyboard if real_keyboard else '')
")

MOUSE_DEV=$(python3 -c "
import glob, os
mouse_found = None
for dev in sorted(glob.glob('/dev/input/event*')):
    try:
        # Verificar que tenga capacidades de movimiento
        with open('/sys/class/input/'+os.path.basename(dev)+'/device/capabilities/rel') as f:
            caps = int(f.read().strip(), 16)
        if caps & 0b11:
            with open('/sys/class/input/'+os.path.basename(dev)+'/device/name') as f:
                name = f.read().strip().lower()
            
            # Priorizar el que dice "mouse" y no tiene "keyboard"
            if 'mouse' in name and 'keyboard' not in name:
                print(dev)
                break
            elif 'optical' in name and not mouse_found:
                mouse_found = dev
    except:
        continue

if not mouse_found:
    print('')
")

if [ -z "$KBD_DEV" ]; then
    echo "❌ Error: No se pudo detectar el teclado" >&2
    echo "Dispositivos de teclado encontrados:" >&2
    for dev in /dev/input/event*; do
        name=$(cat "/sys/class/input/$(basename $dev)/device/name" 2>/dev/null)
        if echo "$name" | grep -qi "keyboard\|kbd"; then
            echo "  $dev: $name" >&2
        fi
    done
    exit 1
fi

if [ -z "$MOUSE_DEV" ]; then
    echo "❌ Error: No se pudo detectar el ratón" >&2
    echo "Dispositivos de ratón encontrados:" >&2
    for dev in /dev/input/event*; do
        name=$(cat "/sys/class/input/$(basename $dev)/device/name" 2>/dev/null)
        if echo "$name" | grep -qi "mouse\|optical"; then
            echo "  $dev: $name" >&2
        fi
    done
    exit 1
fi

echo "Detectados: teclado=$KBD_DEV ratón=$MOUSE_DEV"

if [ "$KBD_DEV" = "$MOUSE_DEV" ]; then
    echo "ERROR: Teclado y ratón son el mismo dispositivo" >&2
    exit 1
fi

exec python3 "$SCRIPT_DIR/infinite_desktop_core.py" "$KBD_DEV" "$MOUSE_DEV" "$SPEED"
