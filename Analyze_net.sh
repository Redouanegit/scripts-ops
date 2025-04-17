#!/bin/bash

# Vérifie si le script est lancé avec les privilèges root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (sudo)."
  exit
fi

echo "=== Connexions réseau totales (TCP) ==="
netstat -ant | grep -v "127.0.0.1" | grep -v "::1" | wc -l

echo ""
echo "=== Répartition des états de connexion ==="
netstat -ant | awk '{print $6}' | grep -v "^State" | sort | uniq -c | sort -nr

echo ""
echo "=== Top 10 adresses IP connectées ==="
netstat -ntu | awk '{print $5}' | cut -d: -f1 | grep -v "^$" | sort | uniq -c | sort -nr | head

echo ""
echo "=== Nombre de connexions ESTABLISHED par port ==="
netstat -ant | grep ESTABLISHED | awk '{print $4}' | cut -d: -f2 | sort | uniq -c | sort -nr

echo ""
echo "=== Processus écoutant sur le réseau ==="
netstat -tulnp | grep LISTEN

echo ""
echo "=== Analyse de trafic avec iftop (5 secondes) ==="
echo "Appuyez sur q pour quitter iftop..."
sleep 2
iftop -t -s 5

echo ""
echo "=== Capture de trafic avec tcpdump (10 paquets sur port 443) ==="
tcpdump -n -i any port 443 -c 10

echo ""
echo "=== Fin de l’analyse ==="
