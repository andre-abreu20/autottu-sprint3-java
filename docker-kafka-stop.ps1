# ============================================
# Script: Parar Kafka Docker
# Projeto: AutoTTU
# ============================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  [*] Parar Kafka - AutoTTU" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$containerExists = docker ps -a --filter "name=kafka-autottu" --format "{{.Names}}"

if (-not $containerExists) {
    Write-Host "[AVISO] Container 'kafka-autottu' não encontrado" -ForegroundColor Yellow
    Write-Host "Nada a parar." -ForegroundColor White
} else {
    Write-Host "[INFO] Parando container..." -ForegroundColor Yellow
    docker stop kafka-autottu | Out-Null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Kafka parado com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "[ERRO] Falha ao parar o container!" -ForegroundColor Red
    }
}

Write-Host ""
Read-Host "Pressione ENTER para sair"
