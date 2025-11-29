#!/bin/bash

ZBX_URL="http://192.168.3.107:8081/api_jsonrpc.php"
ZBX_USER="Admin"
ZBX_PASS="zabbix"
HOSTNAME="rocky-vm"
HOST_IP="192.168.3.110"  # IP de tu VM
GROUP_ID="2"             # Grupo de hosts (puedes ajustar según tu configuración)
TEMPLATE_ID="10001"      # ID del template OS Linux (ajústalo si es diferente)

# Obtener token de autenticación
AUTH_TOKEN=$(curl -s -X POST -H 'Content-Type: application/json' \
-d '{
  "jsonrpc": "2.0",
  "method": "user.login",
  "params": {
    "user": "'$ZBX_USER'",
    "password": "'$ZBX_PASS'"
  },
  "id": 1
}' $ZBX_URL | jq -r '.result')

# Crear el host
curl -s -X POST -H 'Content-Type: application/json' \
-d '{
  "jsonrpc": "2.0",
  "method": "host.create",
  "params": {
    "host": "'$HOSTNAME'",
    "interfaces": [
      {
        "type": 1,
        "main": 1,
        "useip": 1,
        "ip": "'$HOST_IP'",
        "dns": "",
        "port": "10050"
      }
    ],
    "groups": [
      {
        "groupid": "'$GROUP_ID'"
      }
    ],
    "templates": [
      {
        "templateid": "'$TEMPLATE_ID'"
      }
    ]
  },
  "auth": "'$AUTH_TOKEN'",
  "id": 2
}' $ZBX_URL

