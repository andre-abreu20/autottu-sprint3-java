# ============================================
# Script: Logs Kafka Docker
# Projeto: AutoTTU
# ============================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  [*] Logs Kafka - AutoTTU" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$containerExists = docker ps -a --filter "name=kafka-autottu" --format "{{.Names}}"

if (-not $containerExists) {
    Write-Host "[ERRO] Container 'kafka-autottu' não encontrado" -ForegroundColor Red
    Write-Host "Execute primeiro: .\docker-kafka-start.ps1" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Pressione ENTER para sair"
    exit 1
}

Write-Host "Escolha uma opção:" -ForegroundColor Yellow
Write-Host "1. Ver últimas 50 linhas" -ForegroundColor White
Write-Host "2. Ver últimas 100 linhas" -ForegroundColor White
Write-Host "3. Seguir em tempo real (Ctrl+C para parar)" -ForegroundColor White
Write-Host "4. Ver logs completos" -ForegroundColor White
Write-Host ""

$opcao = Read-Host "Digite a opção desejada"

Write-Host ""
Write-Host "Logs Kafka:" -ForegroundColor Cyan
Write-Host "--------------------------------------------" -ForegroundColor DarkGray

switch ($opcao) {
    "1" {
        docker logs --tail 50 kafka-autottu
    }
    "2" {
        docker logs --tail 100 kafka-autottu
    }
    "3" {
        Write-Host "Pressione Ctrl+C para interromper" -ForegroundColor Yellow
        docker logs -f kafka-autottu
    }
    "4" {
        docker logs kafka-autottu
    }
    default {
        Write-Host "Opção inválida!" -ForegroundColor Red
        docker logs --tail 50 kafka-autottu
    }
}

Write-Host "--------------------------------------------" -ForegroundColor DarkGray
Write-Host ""
Read-Host "Pressione ENTER para sair"
