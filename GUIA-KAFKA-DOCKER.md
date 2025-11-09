# ☕ Guia Completo: Kafka com Docker - AutoTTU

## 📋 Pré-requisitos

- Windows 10/11 com Docker Desktop ativo
- PowerShell (executar scripts na pasta `autottu`)
- Projeto AutoTTU clonado (mesmo diretório do RabbitMQ)

---

## 🚀 Passo 1: Garantir Docker OK

```powershell
docker --version
docker ps
```

Se não estiver instalado ou rodando, abra o **Docker Desktop** e aguarde o status *Running*.

---

## 🐳 Passo 2: Subir Kafka com Docker

### 2.1 Script pronto

```powershell
.\docker-kafka-start.ps1
```

O script:
- Usa a imagem oficial `apache/kafka:3.7.0`
- Gera automaticamente um Cluster ID KRaft e formata o volume (caso ainda não exista)
- Cria o container `kafka-autottu`
- Mapeia porta `9092`
- Habilita modo *KRaft* (sem ZooKeeper)
- Cria volume `kafka_autottu_data`

### 2.2 Setup completo em 1 comando

```powershell
.\docker-kafka-setup-completo.ps1
```

Além de subir o container, ele:
- Faz backup do `application.properties`
- Reabilita os listeners de RabbitMQ e Kafka
- Ajusta health check (`management.health.kafka.enabled=true`)

**Use esta opção depois da primeira vez também, se quiser garantir as configs.**

---

## ⚙️ Passo 3: Conferir container e tópicos

```powershell
.\docker-kafka-status.ps1
```

Saída esperada:
- Container rodando (`Up …`)
- Portas expostas (`0.0.0.0:9092->9092/tcp`)
- Lista de tópicos (vazio ou com os tópicos criados pelo app)

Comandos úteis:
```powershell
# Listar tópicos manualmente
docker exec kafka-autottu /opt/kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092

# Criar tópico manual
docker exec kafka-autottu /opt/kafka/bin/kafka-topics.sh --create --topic teste --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
```

---

## 🛠️ Passo 4: Ajustar `application.properties`

O script `docker-kafka-setup-completo.ps1` já faz isso, mas confira:

```properties
spring.kafka.bootstrap-servers=localhost:9092
spring.kafka.consumer.auto-startup=true
spring.kafka.listener.auto-startup=true
management.health.kafka.enabled=true
spring.rabbitmq.listener.simple.auto-startup=true
```

Se estiver usando perfil `mock`, comente: `# spring.profiles.active=mock`.

---

## ▶️ Passo 5: Reiniciar a aplicação

```powershell
mvn clean install
mvn spring-boot:run
```

**Importante:** Mantenha o console aberto para ver os logs `📡 [KAFKA] ...`.

---

## 🧪 Passo 6: Testar via AutoTTU

### 6.1 Eventos de Check-in
1. Acesse `http://localhost:8080`
2. Login `admin` / `admin123`
3. Menu **Check-ins**
4. Clique em **"Registrar Check-in"**
5. Preencha e salve

**Logs esperados:**
```
📡 [KAFKA] Evento Check-in enviado: CHECKIN_CRIADO
🎯 ======= EVENTO KAFKA: CHECK-IN =======
...
```

### 6.2 Eventos de Manutenção
1. Menu **Manutenções**
2. Nova manutenção
3. Preencha e salve

**Logs esperados:**
```
📡 [KAFKA] Evento Manutenção enviado: MANUTENCAO_AGENDADA
🎯 ====== EVENTO KAFKA: MANUTENÇÃO ======
...
```

### 6.3 Auditoria (opcional)
Grave ações relevantes (ex.: exclusão de moto) e verifique logs `EVENTO KAFKA: AUDITORIA`.

---

## 📊 Acompanhando o Kafka

Use os scripts auxiliares:

| Script | Função |
|--------|--------|
| `.\docker-kafka-start.ps1` | Iniciar container |
| `.\docker-kafka-stop.ps1` | Parar container |
| `.\docker-kafka-status.ps1` | Status + lista tópicos |
| `.\docker-kafka-logs.ps1` | Logs do broker |
| `.\docker-kafka-remove.ps1` | Remover container + volume |

---

## 🆘 Troubleshooting

| Problema | Causa provável | Solução |
|----------|----------------|---------|
| `Connection refused` nos logs | Kafka não iniciou ou porta em uso | `docker ps`, `docker logs kafka-autottu`, reiniciar container |
| Health check Kafka `DOWN` | Aplicação subiu antes do Kafka | Aguarde 5s, atualize `/telemetria`, certifique-se de rodar start primeiro |
| Nenhum log `📡 [KAFKA]` | Consumidores não iniciaram | Verifique se `spring.profiles.active` não está `mock`, reinicie aplicação |
| Tópicos não aparecem | Broker sem auto-create | Execute script `docker-kafka-setup-completo.ps1` ou crie manualmente |
| Porta 9092 ocupada | Outro Kafka/serviço usando | `netstat -ano | findstr :9092` → `taskkill /PID <pid> /F` ou alterar mapeamento `-p 9093:9092` |

---

## 🧹 Comandos úteis

```powershell
# Parar Kafka
docker stop kafka-autottu

# Iniciar novamente
docker start kafka-autottu

# Acompanhar logs tempo real
docker logs -f kafka-autottu

# Remover tudo (container + volume)
docker rm -f kafka-autottu
docker volume rm kafka_autottu_data
```

---

## ✅ Resumo Final

1. `.\docker-kafka-start.ps1` (ou `docker-kafka-setup-completo.ps1`)
2. Confirmar `application.properties`
3. `mvn spring-boot:run`
4. Registrar Check-in / Manutenção
5. Ver logs `📡 [KAFKA] ...` + consumers `🎯 ...`
6. Monitorar com `.\docker-kafka-status.ps1`

**Kafka + RabbitMQ funcionando em paralelo, sem mock!** 🎉
