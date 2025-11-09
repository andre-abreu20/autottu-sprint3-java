# ============================================
# Script: Parar RabbitMQ Docker
# Projeto: AutoTTU
# ============================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  🛑 Parar RabbitMQ - AutoTTU" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se container existe
$containerExists = docker ps -a --filter "name=rabbitmq-autottu" --format "{{.Names}}"

if ($containerExists) {
    Write-Host "🛑 Parando RabbitMQ..." -ForegroundColor Yellow
    docker stop rabbitmq-autottu
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ RabbitMQ parado com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "❌ Erro ao parar RabbitMQ!" -ForegroundColor Red
    }
} else {
    Write-Host "⚠️ Container 'rabbitmq-autottu' não encontrado!" -ForegroundColor Yellow
    Write-Host "💡 Use o script 'docker-rabbitmq-start.ps1' para criar" -ForegroundColor Cyan
}

Write-Host ""
Read-Host "Pressione ENTER para sair"

