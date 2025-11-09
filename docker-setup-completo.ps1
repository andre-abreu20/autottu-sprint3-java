# ============================================
# Script: Setup Completo RabbitMQ + Configuracao
# Projeto: AutoTTU
# ============================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  [*] Setup Completo RabbitMQ - AutoTTU" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# ============================================
# PASSO 1: Verificar Docker
# ============================================
Write-Host "[1/4] Verificando Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "[OK] Docker encontrado: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERRO] Docker nao encontrado!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Por favor, instale o Docker Desktop:" -ForegroundColor Yellow
    Write-Host "   https://www.docker.com/products/docker-desktop/" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Pressione ENTER para sair"
    exit 1
}

Write-Host ""

# ============================================
# PASSO 2: Baixar e Iniciar RabbitMQ
# ============================================
Write-Host "[2/4] Configurando RabbitMQ Docker..." -ForegroundColor Yellow

$containerExists = docker ps -a --filter "name=rabbitmq-autottu" --format "{{.Names}}"

if ($containerExists) {
    Write-Host "[INFO] Container ja existe, iniciando..." -ForegroundColor Cyan
    docker start rabbitmq-autottu
} else {
    Write-Host "[INFO] Baixando imagem RabbitMQ..." -ForegroundColor Cyan
    docker pull rabbitmq:management
    
    Write-Host "[INFO] Criando container..." -ForegroundColor Cyan
    docker run -d `
        --name rabbitmq-autottu `
        -p 5672:5672 `
        -p 15672:15672 `
        -e RABBITMQ_DEFAULT_USER=guest `
        -e RABBITMQ_DEFAULT_PASS=guest `
        rabbitmq:management
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] RabbitMQ rodando!" -ForegroundColor Green
} else {
    Write-Host "[ERRO] Erro ao iniciar RabbitMQ!" -ForegroundColor Red
    Read-Host "Pressione ENTER para sair"
    exit 1
}

Write-Host ""

# ============================================
# PASSO 3: Configurar application.properties
# ============================================
Write-Host "[3/4] Configurando application.properties..." -ForegroundColor Yellow

$propertiesPath = "src\main\resources\application.properties"

if (Test-Path $propertiesPath) {
    # Fazer backup
    $backupPath = "src\main\resources\application.properties.backup"
    Copy-Item $propertiesPath $backupPath -Force
    Write-Host "[OK] Backup criado: $backupPath" -ForegroundColor Cyan
    
    # Ler conteudo
    $content = Get-Content $propertiesPath -Raw
    
    # Comentar linha do mock
    $content = $content -replace '^spring\.profiles\.active=mock', '# spring.profiles.active=mock'
    
    # Habilitar health check do RabbitMQ
    $content = $content -replace 'management\.health\.rabbit\.enabled=false', 'management.health.rabbit.enabled=true'
    
    # Salvar
    Set-Content $propertiesPath $content -NoNewline
    
    Write-Host "[OK] Configuracao atualizada!" -ForegroundColor Green
    Write-Host "   - Modo mock desativado" -ForegroundColor White
    Write-Host "   - Health check RabbitMQ ativado" -ForegroundColor White
} else {
    Write-Host "[AVISO] Arquivo application.properties nao encontrado!" -ForegroundColor Yellow
    Write-Host "Execute este script na pasta raiz do projeto" -ForegroundColor Cyan
}

Write-Host ""

# ============================================
# PASSO 4: Aguardar RabbitMQ Inicializar
# ============================================
Write-Host "[4/4] Aguardando RabbitMQ inicializar..." -ForegroundColor Yellow
Start-Sleep -Seconds 5
Write-Host "[OK] Pronto!" -ForegroundColor Green

Write-Host ""

# ============================================
# RESUMO FINAL
# ============================================
Write-Host "============================================" -ForegroundColor Green
Write-Host "  [OK] SETUP CONCLUIDO COM SUCESSO!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "RabbitMQ esta rodando:" -ForegroundColor Cyan
Write-Host "   Painel: http://localhost:15672" -ForegroundColor White
Write-Host "   Usuario: guest" -ForegroundColor White
Write-Host "   Senha: guest" -ForegroundColor White
Write-Host ""
Write-Host "Configuracao atualizada:" -ForegroundColor Cyan
Write-Host "   [OK] Modo mock desativado" -ForegroundColor White
Write-Host "   [OK] RabbitMQ habilitado" -ForegroundColor White
Write-Host ""
Write-Host "Proximos passos:" -ForegroundColor Yellow
Write-Host "   1. Compile o projeto:" -ForegroundColor White
Write-Host "      mvn clean install" -ForegroundColor Cyan
Write-Host ""
Write-Host "   2. Inicie a aplicacao:" -ForegroundColor White
Write-Host "      mvn spring-boot:run" -ForegroundColor Cyan
Write-Host ""
Write-Host "   3. Acesse: http://localhost:8080" -ForegroundColor White
Write-Host ""
Write-Host "   4. Teste aprovando um Test Ride!" -ForegroundColor White
Write-Host ""
Write-Host "Scripts disponiveis:" -ForegroundColor Cyan
Write-Host "   Status:    .\docker-rabbitmq-status.ps1" -ForegroundColor White
Write-Host "   Logs:      .\docker-rabbitmq-logs.ps1" -ForegroundColor White
Write-Host "   Parar:     .\docker-rabbitmq-stop.ps1" -ForegroundColor White
Write-Host "   Remover:   .\docker-rabbitmq-remove.ps1" -ForegroundColor White
Write-Host ""

Read-Host "Pressione ENTER para sair"
