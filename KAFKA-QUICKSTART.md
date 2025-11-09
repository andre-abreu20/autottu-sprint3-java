# ⚡ Kafka Quickstart - AutoTTU

## 1️⃣ Subir Kafka

```powershell
cd "C:\Users\T-GAMER\Downloads\Arquivos da Aula - 12_09 - Turma_H 1\autottu"
.\docker-kafka-setup-completo.ps1
```

(O script usa a imagem oficial `apache/kafka:3.7.0`, formata automaticamente o armazenamento KRaft, cria o container, ajusta `application.properties` e habilita health checks.)

---

## 2️⃣ Reiniciar a aplicação

```powershell
mvn clean install
mvn spring-boot:run
```

---

## 3️⃣ Testar eventos

### Check-in
1. Acesse `http://localhost:8080`
2. Login `admin / admin123`
3. **Check-ins → Registrar Check-in → Salvar**
4. Veja no console:
```
📡 [KAFKA] Evento Check-in enviado...
🎯 ======= EVENTO KAFKA: CHECK-IN =======
```

### Manutenção
1. **Manutenções → Nova → Salvar**
2. Console:
```
📡 [KAFKA] Evento Manutenção enviado...
🎯 ====== EVENTO KAFKA: MANUTENÇÃO ======
```

---

## 4️⃣ Verificar Broker

```powershell
.\docker-kafka-status.ps1
```

Mostra status do container e lista de tópicos (`autottu-checkin-eventos`, `autottu-manutencao-eventos`, `autottu-auditoria-eventos`).

---

## 5️⃣ Encerrar

```powershell
.\docker-kafka-stop.ps1      # parar
.\docker-kafka-start.ps1     # iniciar depois
.\docker-kafka-remove.ps1    # remover completamente
```

Comandos extras:
```powershell
# Listar tópicos
.\docker-kafka-status.ps1

# Manual: listar tópicos diretamente
docker exec kafka-autottu /opt/kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092
```

---

✅ Pronto! Kafka rodando localmente, integrado ao AutoTTU.
