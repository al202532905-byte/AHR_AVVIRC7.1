#!/bin/bash

# Variables
ZBX_SERVER_IP="192.168.3.103"   # Cambia por la IP de tu servidor Zabbix
ZBX_HOSTNAME="rocky-vm"         # Nombre que aparecerá en la interfaz de Zabbix

echo "=== Instalando repositorio de Zabbix para RHEL/Rocky Linux 8 ==="
sudo rpm -Uvh https://repo.zabbix.com/zabbix/6.4/rhel/8/x86_64/zabbix-release-6.4-1.el8.noarch.rpm
sudo dnf clean all

echo "=== Instalando Zabbix Agent ==="
sudo dnf install -y zabbix-agent

echo "=== Configurando Zabbix Agent ==="
sudo sed -i "s/^Server=.*/Server=${ZBX_SERVER_IP}/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^ServerActive=.*/ServerActive=${ZBX_SERVER_IP}/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^Hostname=.*/Hostname=${ZBX_HOSTNAME}/" /etc/zabbix/zabbix_agentd.conf

echo "=== Habilitando y arrancando el servicio ==="
sudo systemctl enable zabbix-agent
sudo systemctl restart zabbix-agent

echo "=== Abriendo puerto 10050 en firewall ==="
sudo firewall-cmd --add-port=10050/tcp --permanent
sudo firewall-cmd --reload

echo "=== Instalación y configuración completadas ==="
sudo systemctl status zabbix-agent --no-pager

