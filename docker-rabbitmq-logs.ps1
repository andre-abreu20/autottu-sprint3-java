# ============================================
# Script: Ver Logs do RabbitMQ
# Projeto: AutoTTU
# ============================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  📝 Logs RabbitMQ - AutoTTU" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se container existe
$containerExists = docker ps -a --filter "name=rabbitmq-autottu" --format "{{.Names}}"

if (-not $containerExists) {
    Write-Host "❌ Container 'rabbitmq-autottu' não encontrado!" -ForegroundColor Red
    Write-Host "💡 Use o script 'docker-rabbitmq-start.ps1' para criar" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Pressione ENTER para sair"
    exit 1
}

Write-Host "Escolha uma opção:" -ForegroundColor Yellow
Write-Host "1. Ver últimas 50 linhas" -ForegroundColor White
Write-Host "2. Ver últimas 100 linhas" -ForegroundColor White
Write-Host "3. Acompanhar em tempo real (Ctrl+C para sair)" -ForegroundColor White
Write-Host "4. Ver todos os logs" -ForegroundColor White
Write-Host ""

$opcao = Read-Host "Digite o número da opção"

Write-Host ""
Write-Host "📝 Logs do RabbitMQ:" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor DarkGray

switch ($opcao) {
    "1" {
        docker logs --tail 50 rabbitmq-autottu
    }
    "2" {
        docker logs --tail 100 rabbitmq-autottu
    }
    "3" {
        Write-Host "Pressione Ctrl+C para parar..." -ForegroundColor Yellow
        docker logs -f rabbitmq-autottu
    }
    "4" {
        docker logs rabbitmq-autottu
    }
    default {
        Write-Host "❌ Opção inválida!" -ForegroundColor Red
        Write-Host "Mostrando últimas 50 linhas..." -ForegroundColor Yellow
        docker logs --tail 50 rabbitmq-autottu
    }
}

Write-Host ""
Write-Host "============================================" -ForegroundColor DarkGray
Write-Host ""
Read-Host "Pressione ENTER para sair"

