# ============================================
# Script: Iniciar Kafka com Docker
# Projeto: AutoTTU
# ============================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  [*] Kafka Docker - AutoTTU" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

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

# Verificar se Docker está instalado
Write-Host "[INFO] Verificando Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "[OK] Docker encontrado: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERRO] Docker não encontrado!" -ForegroundColor Red
    Write-Host "Instale o Docker Desktop: https://www.docker.com/products/docker-desktop/" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Pressione ENTER para sair"
    exit 1
}

Write-Host ""

# Verificar se container já existe
$containerExists = docker ps -a --filter "name=kafka-autottu" --format "{{.Names}}"

if ($containerExists) {
    Write-Host "[INFO] Container 'kafka-autottu' já existe" -ForegroundColor Yellow
    
    # Verificar se está rodando
    $containerRunning = docker ps --filter "name=kafka-autottu" --format "{{.Names}}"
    
    if ($containerRunning) {
        Write-Host "[OK] Kafka já está rodando!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Status:" -ForegroundColor Cyan
        docker ps --filter "name=kafka-autottu"
    } else {
        Write-Host "[INFO] Iniciando container existente..." -ForegroundColor Yellow
        docker start kafka-autottu | Out-Null
        Write-Host "[OK] Kafka iniciado!" -ForegroundColor Green
    }
} else {
    Write-Host "[INFO] Baixando imagem Kafka ($imageName)" -ForegroundColor Yellow
    docker pull $imageName | Out-Null

    # gerar cluster id randomico
    $clusterId = (docker run --rm --entrypoint /opt/kafka/bin/kafka-storage.sh $imageName random-uuid).Trim()
    if (-not [string]::IsNullOrWhiteSpace($clusterId)) {
        $envCommon["KAFKA_CLUSTER_ID"] = $clusterId
    }

    Write-Host "[INFO] Formatando armazenamento KRaft..." -ForegroundColor Yellow
    $formatArgs = @("--rm", "--entrypoint", "/opt/kafka/bin/kafka-storage.sh", "-v", "kafka_autottu_data:/var/lib/kafka/data")
    foreach ($item in $envCommon.GetEnumerator()) {
        $formatArgs += "-e"
        $formatArgs += "$($item.Key)=$($item.Value)"
    }
    $formatArgs += $imageName
    $formatArgs += @("format", "--ignore-formatted", "--config", "/opt/kafka/config/kraft/server.properties", "--cluster-id", $envCommon["KAFKA_CLUSTER_ID"])
    docker run @formatArgs | Out-Null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERRO] Falha ao formatar diretórios KRaft" -ForegroundColor Red
        Read-Host "Pressione ENTER para sair"
        exit 1
    }

    Write-Host "[INFO] Criando e iniciando container Kafka..." -ForegroundColor Yellow
    $runArgs = @("-d", "--name", "kafka-autottu", "-p", "9092:9092", "-p", "9093:9093", "-v", "kafka_autottu_data:/var/lib/kafka/data")
    foreach ($item in $envCommon.GetEnumerator()) {
        $runArgs += "-e"
        $runArgs += "$($item.Key)=$($item.Value)"
    }
    $runArgs += $imageName
    docker run @runArgs | Out-Null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Kafka criado e iniciado com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "[ERRO] Erro ao criar container Kafka!" -ForegroundColor Red
        Write-Host ""
        Read-Host "Pressione ENTER para sair"
        exit 1
    }
}

Write-Host ""
Write-Host "[INFO] Aguardando Kafka inicializar (10s)..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "  [OK] KAFKA PRONTO!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Informações de Acesso:" -ForegroundColor Cyan
Write-Host "   Broker: localhost:9092" -ForegroundColor White
Write-Host "   Container: kafka-autottu" -ForegroundColor White
Write-Host "   Volume de dados: kafka_autottu_data" -ForegroundColor White
Write-Host ""
Write-Host "Comandos úteis:" -ForegroundColor Cyan
Write-Host "   Ver tópicos:    docker exec kafka-autottu /opt/kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092" -ForegroundColor White
Write-Host "   Criar tópico:   docker exec kafka-autottu /opt/kafka/bin/kafka-topics.sh --create --topic teste --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1" -ForegroundColor White
Write-Host "   Ver mensagens:  docker exec kafka-autottu /opt/kafka/bin/kafka-console-consumer.sh --topic teste --from-beginning --bootstrap-server localhost:9092" -ForegroundColor White
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Yellow
Write-Host "   1. Ajuste o application.properties para habilitar Kafka" -ForegroundColor White
Write-Host "   2. Reinicie a aplicação: mvn spring-boot:run" -ForegroundColor White
Write-Host "   3. Gere eventos (check-in, manutenção)" -ForegroundColor White
Write-Host "   4. Acompanhe os logs e o Kafka" -ForegroundColor White
Write-Host ""

Read-Host "Pressione ENTER para sair"
