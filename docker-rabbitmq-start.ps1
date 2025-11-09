# ============================================
# Script: Iniciar RabbitMQ com Docker
# Projeto: AutoTTU
# ============================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  [*] RabbitMQ Docker - AutoTTU" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se Docker esta instalado
Write-Host "[INFO] Verificando Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "[OK] Docker encontrado: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERRO] Docker nao encontrado!" -ForegroundColor Red
    Write-Host "Instale o Docker Desktop: https://www.docker.com/products/docker-desktop/" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Pressione ENTER para sair"
    exit 1
}

Write-Host ""

# Verificar se container ja existe
$containerExists = docker ps -a --filter "name=rabbitmq-autottu" --format "{{.Names}}"

if ($containerExists) {
    Write-Host "[INFO] Container 'rabbitmq-autottu' ja existe" -ForegroundColor Yellow
    
    # Verificar se esta rodando
    $containerRunning = docker ps --filter "name=rabbitmq-autottu" --format "{{.Names}}"
    
    if ($containerRunning) {
        Write-Host "[OK] RabbitMQ ja esta rodando!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Status:" -ForegroundColor Cyan
        docker ps --filter "name=rabbitmq-autottu"
    } else {
        Write-Host "[INFO] Iniciando container existente..." -ForegroundColor Yellow
        docker start rabbitmq-autottu
        Write-Host "[OK] RabbitMQ iniciado!" -ForegroundColor Green
    }
} else {
    Write-Host "[INFO] Baixando imagem RabbitMQ (primeira vez)..." -ForegroundColor Yellow
    docker pull rabbitmq:management
    
    Write-Host ""
    Write-Host "[INFO] Criando e iniciando container RabbitMQ..." -ForegroundColor Yellow
    
    docker run -d `
        --name rabbitmq-autottu `
        -p 5672:5672 `
        -p 15672:15672 `
        -e RABBITMQ_DEFAULT_USER=guest `
        -e RABBITMQ_DEFAULT_PASS=guest `
        rabbitmq:management
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] RabbitMQ criado e iniciado com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "[ERRO] Erro ao criar container!" -ForegroundColor Red
        Write-Host ""
        Read-Host "Pressione ENTER para sair"
        exit 1
    }
}

Write-Host ""
Write-Host "[INFO] Aguardando RabbitMQ inicializar..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "  [OK] RABBITMQ PRONTO!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Informacoes de Acesso:" -ForegroundColor Cyan
Write-Host "   Painel Web: http://localhost:15672" -ForegroundColor White
Write-Host "   Usuario: guest" -ForegroundColor White
Write-Host "   Senha: guest" -ForegroundColor White
Write-Host ""
Write-Host "Conexao da Aplicacao:" -ForegroundColor Cyan
Write-Host "   Host: localhost" -ForegroundColor White
Write-Host "   Porta: 5672" -ForegroundColor White
Write-Host ""
Write-Host "Comandos Uteis:" -ForegroundColor Cyan
Write-Host "   Ver logs:     docker logs rabbitmq-autottu" -ForegroundColor White
Write-Host "   Parar:        docker stop rabbitmq-autottu" -ForegroundColor White
Write-Host "   Reiniciar:    docker restart rabbitmq-autottu" -ForegroundColor White
Write-Host "   Remover:      docker rm -f rabbitmq-autottu" -ForegroundColor White
Write-Host ""
Write-Host "Proximo passo:" -ForegroundColor Yellow
Write-Host "   1. Edite application.properties" -ForegroundColor White
Write-Host "      Comente a linha: spring.profiles.active=mock" -ForegroundColor White
Write-Host "   2. Rode a aplicacao: mvn spring-boot:run" -ForegroundColor White
Write-Host ""

Read-Host "Pressione ENTER para sair"

