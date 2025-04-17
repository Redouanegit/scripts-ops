#!/bin/bash

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
echo "=== Fin de l'analyse ==="
