#!/bin/bash

# ==============================================================================
# Script: Parse-LGPDEvents.sh
# Operadora: Iza Lima (Arquiteta de Defesa)
# Descrição: Filtra logs brutos (GLPI/Apache) em busca de anomalias de acesso 
#            a dados sensíveis, gerando rastreabilidade para conformidade LGPD.
# ==============================================================================

LOG_FILE="/var/log/glpi/access.log"
AUDIT_REPORT="./LGPD_Audit_Report_$(date +%F).txt"

echo "[*] Dissecando a anatomia dos logs de acesso..."

# Racionalismo Integrativo: Separando o ruído da informação crítica (Status 403 e 500)
echo "--- EVENTOS CRÍTICOS DE ACESSO (Possível Violação de RBAC) ---" > "$AUDIT_REPORT"
grep -E " 403 | 500 " "$LOG_FILE" | awk '{print $1, $4, $7, $9}' >> "$AUDIT_REPORT"

# Contagem de Ocorrências para Análise de Padrão
ANOMALIES=$(wc -l < "$AUDIT_REPORT")

echo "[+] Processamento concluído. Throughput mantido."
echo "[!] Foram registradas $ANOMALIES anomalias estruturais. Relatório de auditoria gerado."
