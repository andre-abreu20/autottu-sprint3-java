# ============================================
# Script: Status Kafka Docker
# Projeto: AutoTTU
# ============================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  [*] Status Kafka - AutoTTU" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

try {
    docker ps | Out-Null
} catch {
    Write-Host "[ERRO] Docker não está rodando ou não foi encontrado" -ForegroundColor Red
    Write-Host "Abra o Docker Desktop e tente novamente." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Pressione ENTER para sair"
    exit 1
}

$containerRunning = docker ps --filter "name=kafka-autottu" --format "{{.Names}}"
$containerExists = docker ps -a --filter "name=kafka-autottu" --format "{{.Names}}"

if ($containerRunning) {
    Write-Host "[OK] Kafka está RODANDO" -ForegroundColor Green
    Write-Host ""
    docker ps --filter "name=kafka-autottu" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    Write-Host ""

    Write-Host "Tópicos disponíveis:" -ForegroundColor Cyan
    docker exec kafka-autottu /opt/kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092

} elseif ($containerExists) {
    Write-Host "[AVISO] Kafka está parado" -ForegroundColor Yellow
    Write-Host "Para iniciar: docker start kafka-autottu" -ForegroundColor Cyan
} else {
    Write-Host "[ERRO] Container 'kafka-autottu' não existe" -ForegroundColor Red
    Write-Host "Execute o script docker-kafka-start.ps1" -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Pressione ENTER para sair"
