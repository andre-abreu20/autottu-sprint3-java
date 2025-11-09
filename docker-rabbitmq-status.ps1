# ============================================
# Script: Verificar Status RabbitMQ
# Projeto: AutoTTU
# ============================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  📊 Status RabbitMQ - AutoTTU" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se Docker está rodando
try {
    docker ps > $null 2>&1
    Write-Host "✅ Docker está rodando" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker não está rodando!" -ForegroundColor Red
    Write-Host "💡 Abra o Docker Desktop e aguarde iniciar" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Pressione ENTER para sair"
    exit 1
}

Write-Host ""

# Verificar se container existe
$containerExists = docker ps -a --filter "name=rabbitmq-autottu" --format "{{.Names}}"

if ($containerExists) {
    # Verificar se está rodando
    $containerRunning = docker ps --filter "name=rabbitmq-autottu" --format "{{.Names}}"
    
    if ($containerRunning) {
        Write-Host "✅ RabbitMQ está RODANDO" -ForegroundColor Green
        Write-Host ""
        Write-Host "📊 Detalhes do Container:" -ForegroundColor Cyan
        docker ps --filter "name=rabbitmq-autottu" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        
        Write-Host ""
        Write-Host "🌐 Acessos:" -ForegroundColor Cyan
        Write-Host "   Painel Web:  http://localhost:15672" -ForegroundColor White
        Write-Host "   API:         localhost:5672" -ForegroundColor White
        
        Write-Host ""
        Write-Host "📝 Últimas 10 linhas de log:" -ForegroundColor Cyan
        Write-Host "----------------------------------------" -ForegroundColor DarkGray
        docker logs --tail 10 rabbitmq-autottu
        Write-Host "----------------------------------------" -ForegroundColor DarkGray
        
    } else {
        Write-Host "⚠️ RabbitMQ está PARADO" -ForegroundColor Yellow
        Write-Host "💡 Para iniciar: docker start rabbitmq-autottu" -ForegroundColor Cyan
        Write-Host "💡 Ou use: .\docker-rabbitmq-start.ps1" -ForegroundColor Cyan
    }
} else {
    Write-Host "❌ Container 'rabbitmq-autottu' NÃO EXISTE" -ForegroundColor Red
    Write-Host "💡 Para criar: .\docker-rabbitmq-start.ps1" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "📋 Comandos Disponíveis:" -ForegroundColor Cyan
Write-Host "   Iniciar:   .\docker-rabbitmq-start.ps1" -ForegroundColor White
Write-Host "   Parar:     .\docker-rabbitmq-stop.ps1" -ForegroundColor White
Write-Host "   Logs:      .\docker-rabbitmq-logs.ps1" -ForegroundColor White
Write-Host "   Remover:   .\docker-rabbitmq-remove.ps1" -ForegroundColor White
Write-Host ""

Read-Host "Pressione ENTER para sair"

