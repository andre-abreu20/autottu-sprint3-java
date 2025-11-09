# ============================================
# Script: Remover RabbitMQ Docker
# Projeto: AutoTTU
# ============================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  🗑️ Remover RabbitMQ - AutoTTU" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se container existe
$containerExists = docker ps -a --filter "name=rabbitmq-autottu" --format "{{.Names}}"

if (-not $containerExists) {
    Write-Host "⚠️ Container 'rabbitmq-autottu' não encontrado!" -ForegroundColor Yellow
    Write-Host "✅ Nada para remover" -ForegroundColor Green
    Write-Host ""
    Read-Host "Pressione ENTER para sair"
    exit 0
}

Write-Host "⚠️ ATENÇÃO: Isso irá remover o container RabbitMQ" -ForegroundColor Yellow
Write-Host "⚠️ Todas as mensagens e configurações serão perdidas!" -ForegroundColor Yellow
Write-Host ""

$confirmacao = Read-Host "Tem certeza? Digite 'SIM' para confirmar"

if ($confirmacao -eq "SIM") {
    Write-Host ""
    Write-Host "🛑 Parando container..." -ForegroundColor Yellow
    docker stop rabbitmq-autottu 2>$null
    
    Write-Host "🗑️ Removendo container..." -ForegroundColor Yellow
    docker rm -v rabbitmq-autottu
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ RabbitMQ removido com sucesso!" -ForegroundColor Green
        Write-Host ""
        Write-Host "💡 Para criar novamente: .\docker-rabbitmq-start.ps1" -ForegroundColor Cyan
    } else {
        Write-Host "❌ Erro ao remover container!" -ForegroundColor Red
    }
} else {
    Write-Host ""
    Write-Host "❌ Operação cancelada" -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Pressione ENTER para sair"

