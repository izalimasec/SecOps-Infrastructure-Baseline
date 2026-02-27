<#
.SYNOPSIS
    Script de Rastreabilidade e Saneamento Forense de Active Directory.
.DESCRIPTION
    Este script varre o AD em busca de contas inativas há mais de 90 dias, 
    exportando um log de auditoria detalhado. Foco na redução da superfície 
    de ataque e mitigação de contas órfãs (Governança de Identidade).
.AUTHOR
    Iza Lima - Engenheira de SecOps
#>

# Definição do Perímetro de Tempo (90 dias)
$DiasInativo = 90
$DataLimite = (Get-Date).AddDays(-$DiasInativo)
$LogPath = "C:\SecOps\Logs\AD_Saneamento_$(Get-Date -Format 'yyyyMMdd').csv"

Write-Host "[*] Iniciando varredura de integridade no Active Directory..." -ForegroundColor Cyan

# Extração Cirúrgica de Dados
$UsuariosInativos = Get-ADUser -Filter {LastLogonDate -lt $DataLimite -and Enabled -eq $true} -Properties LastLogonDate, mail, Title | 
    Select-Object Name, SamAccountName, Title, mail, LastLogonDate

if ($UsuariosInativos) {
    # Exportação Verbosa para Auditoria
    $UsuariosInativos | Export-Csv -Path $LogPath -NoTypeInformation -Encoding UTF8
    Write-Host "[!] ALERTA: $($UsuariosInativos.Count) contas inativas identificadas. Log gerado em: $LogPath" -ForegroundColor Yellow
} else {
    Write-Host "[+] Integridade validada. Nenhuma conta fora do padrão de conformidade." -ForegroundColor Green
}
