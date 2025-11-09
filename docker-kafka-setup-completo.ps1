# ============================================
# Script: Setup Completo Kafka + Configuração
# Projeto: AutoTTU
# ============================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  [*] Setup Completo Kafka - AutoTTU" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$problemas = 0

# --------------------------------------------
# 1. Verificar Docker
# --------------------------------------------
Write-Host "[1/4] Verificando Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "[OK] Docker encontrado: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERRO] Docker não encontrado!" -ForegroundColor Red
    Write-Host "Instale o Docker Desktop antes de continuar." -ForegroundColor Yellow
    $problemas++
}

if ($problemas -gt 0) {
    Write-Host ""
    Read-Host "Pressione ENTER para sair"
    exit 1
}

Write-Host ""

# --------------------------------------------
# 2. Garantir container Kafka rodando
# --------------------------------------------
Write-Host "[2/4] Garantindo Kafka Docker rodando..." -ForegroundColor Yellow

$containerRunning = docker ps --filter "name=kafka-autottu" --format "{{.Names}}"
$containerExists = docker ps -a --filter "name=kafka-autottu" --format "{{.Names}}"

if ($containerRunning) {
    Write-Host "[OK] Kafka já está rodando." -ForegroundColor Green
} elseif ($containerExists) {
    Write-Host "[INFO] Kafka existe mas está parado. Iniciando..." -ForegroundColor Yellow
    docker start kafka-autottu | Out-Null
    Write-Host "[OK] Kafka iniciado." -ForegroundColor Green
} else {
    $imageName = "apache/kafka:3.7.0"
    $envCommon = @{
        "KAFKA_NODE_ID" = "1";
        "KAFKA_PROCESS_ROLES" = "broker,controller";
        "KAFKA_CONTROLLER_QUORUM_VOTERS" = "1@localhost:9093";
        "KAFKA_LISTENERS" = "PLAINTEXT://:9092,CONTROLLER://:9093";
        "KAFKA_ADVERTISED_LISTENERS" = "PLAINTEXT://localhost:9092";
        "KAFKA_LISTENER_SECURITY_PROTOCOL_MAP" = "PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT";
        "KAFKA_CONTROLLER_LISTENER_NAMES" = "CONTROLLER";
        "KAFKA_INTER_BROKER_LISTENER_NAME" = "PLAINTEXT";
        "KAFKA_AUTO_CREATE_TOPICS_ENABLE" = "true";
        "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR" = "1";
        "KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR" = "1";
        "KAFKA_TRANSACTION_STATE_LOG_MIN_ISR" = "1";
        "KAFKA_LOG_DIRS" = "/var/lib/kafka/data";
        "KAFKA_CLUSTER_ID" = "autottuClusterId1234567890"
    }

    Write-Host "[INFO] Criando container Kafka ($imageName)..." -ForegroundColor Yellow
    docker pull $imageName | Out-Null

    Write-Host "[INFO] Gerando Cluster ID e formatando armazenamento (KRaft)..." -ForegroundColor Yellow
    $clusterId = (docker run --rm --entrypoint /opt/kafka/bin/kafka-storage.sh $imageName random-uuid).Trim()
    if (-not [string]::IsNullOrWhiteSpace($clusterId)) {
        $envCommon["KAFKA_CLUSTER_ID"] = $clusterId
    }

    $formatArgs = @("--rm", "--entrypoint", "/opt/kafka/bin/kafka-storage.sh", "-v", "kafka_autottu_data:/var/lib/kafka/data")
    foreach ($item in $envCommon.GetEnumerator()) {
        $formatArgs += "-e"
        $formatArgs += "$($item.Key)=$($item.Value)"
    }
    $formatArgs += $imageName
    $formatArgs += @("format", "--ignore-formatted", "--config", "/opt/kafka/config/kraft/server.properties", "--cluster-id", $envCommon["KAFKA_CLUSTER_ID"])
    docker run @formatArgs | Out-Null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERRO] Falha ao formatar o armazenamento do Kafka!" -ForegroundColor Red
        $problemas++
    } else {
        $runArgs = @("-d", "--name", "kafka-autottu", "-p", "9092:9092", "-p", "9093:9093", "-v", "kafka_autottu_data:/var/lib/kafka/data")
        foreach ($item in $envCommon.GetEnumerator()) {
            $runArgs += "-e"
            $runArgs += "$($item.Key)=$($item.Value)"
        }
        $runArgs += $imageName
        docker run @runArgs | Out-Null

        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] Kafka criado e iniciado." -ForegroundColor Green
        } else {
            Write-Host "[ERRO] Falha ao criar o container Kafka!" -ForegroundColor Red
            Write-Host "Verifique o Docker e tente novamente." -ForegroundColor Yellow
            $problemas++
        }
    }
}

if ($problemas -gt 0) {
    Write-Host ""
    Read-Host "Pressione ENTER para sair"
    exit 1
}

Write-Host "[INFO] Aguardando Kafka iniciar (10s)..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host ""

# --------------------------------------------
# 3. Atualizar application.properties
# --------------------------------------------
Write-Host "[3/4] Atualizando application.properties..." -ForegroundColor Yellow

$propertiesPath = "src\main\resources\application.properties"
if (-not (Test-Path $propertiesPath)) {
    Write-Host "[ERRO] Arquivo application.properties não encontrado!" -ForegroundColor Red
    Write-Host "Execute este script na pasta autottu." -ForegroundColor Yellow
    $problemas++
} else {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPath = "src\main\resources\application.properties.kafka_backup_$timestamp"
    Copy-Item $propertiesPath $backupPath -Force
    Write-Host "[OK] Backup criado: $backupPath" -ForegroundColor Green

    $content = Get-Content $propertiesPath -Raw

    # Garantir bootstrap servers
    $content = $content -replace "spring\.kafka\.bootstrap-servers=.*", "spring.kafka.bootstrap-servers=localhost:9092"

    # Habilitar auto startup
    $content = $content -replace "spring\.kafka\.consumer\.auto-startup=false", "spring.kafka.consumer.auto-startup=true"
    $content = $content -replace "spring\.kafka\.listener\.auto-startup=false", "spring.kafka.listener.auto-startup=true"

    if ($content -notmatch "spring\.kafka\.consumer\.auto-startup") {
        $content = $content + "`nspring.kafka.consumer.auto-startup=true"
    }
    if ($content -notmatch "spring\.kafka\.listener\.auto-startup") {
        $content = $content + "`nspring.kafka.listener.auto-startup=true"
    }

    # Opcional: habilitar health check
    if ($content -match "management\.health\.kafka\.enabled=false") {
        $content = $content -replace "management\.health\.kafka\.enabled=false", "management.health.kafka.enabled=true"
    } elseif ($content -notmatch "management\.health\.kafka\.enabled") {
        $content = $content + "`nmanagement.health.kafka.enabled=true"
    }

    Set-Content $propertiesPath $content -NoNewline
    Write-Host "[OK] Configurações atualizadas." -ForegroundColor Green
}

if ($problemas -gt 0) {
    Write-Host ""
    Read-Host "Pressione ENTER para sair"
    exit 1
}

Write-Host ""

# --------------------------------------------
# 4. Resumo
# --------------------------------------------
Write-Host "[4/4] Resumo do setup" -ForegroundColor Yellow
Write-Host "   - Kafka container: kafka-autottu" -ForegroundColor White
Write-Host "   - Porta: 9092" -ForegroundColor White
Write-Host "   - Volume: kafka_autottu_data" -ForegroundColor White
Write-Host "   - application.properties atualizado" -ForegroundColor White
Write-Host ""

Write-Host "============================================" -ForegroundColor Green
Write-Host "  [OK] SETUP KAFKA CONCLUÍDO" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Yellow
Write-Host "   1. Reinicie a aplicação: mvn spring-boot:run" -ForegroundColor White
Write-Host "   2. Gere eventos (Check-in, Manutenção, Auditoria)" -ForegroundColor White
Write-Host "   3. Acompanhe os logs no console" -ForegroundColor White
Write-Host "   4. Use .\docker-kafka-status.ps1 para ver topicos" -ForegroundColor White
Write-Host ""

Read-Host "Pressione ENTER para sair"
