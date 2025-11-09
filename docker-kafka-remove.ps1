# ============================================
# Script: Remover Kafka Docker
# Projeto: AutoTTU
# ============================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  [*] Remover Kafka - AutoTTU" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$containerExists = docker ps -a --filter "name=kafka-autottu" --format "{{.Names}}"

if (-not $containerExists) {
    Write-Host "[AVISO] Container 'kafka-autottu' não existe" -ForegroundColor Yellow
    Write-Host "Nada a remover." -ForegroundColor White
} else {
    Write-Host "ATENÇÃO! Esta ação vai remover o container e o volume kafka_autottu_data." -ForegroundColor Yellow
    $confirmar = Read-Host "Digite SIM para confirmar"

    if ($confirmar -eq "SIM") {
        Write-Host "[INFO] Parando container..." -ForegroundColor Yellow
        docker stop kafka-autottu | Out-Null

        Write-Host "[INFO] Removendo container e volume..." -ForegroundColor Yellow
        docker rm -v kafka-autottu | Out-Null

        Write-Host "[INFO] Removendo volume kafka_autottu_data (se existir)..." -ForegroundColor Yellow
        docker volume rm kafka_autottu_data | Out-Null

        Write-Host "[OK] Kafka removido com sucesso." -ForegroundColor Green
    } else {
        Write-Host "Operação cancelada." -ForegroundColor Yellow
    }
}

Write-Host ""
Read-Host "Pressione ENTER para sair"
