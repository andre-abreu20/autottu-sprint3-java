# 🔍 Guia: Onde Ver Mensagens do RabbitMQ

## ⚠️ IMPORTANTE: Reiniciar a Aplicação

Após alterar o `application.properties`, você **PRECISA** reiniciar a aplicação!

### Como Reiniciar:

```powershell
# No terminal onde a aplicação está rodando:
# Pressione Ctrl+C para parar

# Depois inicie novamente:
mvn spring-boot:run
```

---

## 📊 PARTE 1: Logs no Console da Aplicação

### O que você vai ver ao iniciar:

#### ✅ Modo REAL (correto):
```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/

2025-11-09 15:30:45 INFO  - Started AutottuApplication in 5.234 seconds
```

**SEM** mensagens de:
```
[X] Modo Mock ativado
[X] Simulando envio para RabbitMQ
```

#### ❌ Modo MOCK (errado):
```
⚠️ MODO MOCK ATIVADO - RabbitMQ e Kafka serão simulados
```

---

## 🎯 PARTE 2: Testar Envio de Mensagem

### Passo a Passo:

1. **Acesse a aplicação**: http://localhost:8080
2. **Faça login**: admin / admin123
3. **Vá em "Test Rides"**
4. **Clique em "Novo Test Ride"**
5. **Preencha o formulário:**
   - Escolha uma moto
   - Escolha uma data futura
   - Propósito: "Teste RabbitMQ"
6. **Clique em "Solicitar"**
7. **Na lista, clique em "Aprovar"** no Test Ride criado

---

## 📝 PARTE 3: Ver Logs no Console (Terminal)

### Após aprovar o Test Ride, você deve ver:

```
====================================================
📨 ENVIANDO NOTIFICAÇÃO VIA RABBITMQ
====================================================
Test Ride ID: 1
Usuário: Admin User
Email: admin@autottu.com
Moto: Honda CB 500X
Data: 2025-11-15
Status: APROVADO
====================================================

✅ Mensagem enviada para RabbitMQ com sucesso!

====================================================
🎯 MENSAGEM RECEBIDA DO RABBITMQ
====================================================
📩 Notificação de Test Ride Aprovado
👤 Usuário: Admin User
📧 Email: admin@autottu.com
🏍️ Moto: Honda CB 500X
📅 Data Desejada: 2025-11-15
✅ Status: APROVADO
📝 Propósito: Teste RabbitMQ
====================================================
```

**Se você ver isso = RabbitMQ funcionando! ✅**

---

## 🌐 PARTE 4: Ver no Painel Web RabbitMQ

### 1. Acessar o Painel

**URL**: http://localhost:15672

**Login:**
- Usuário: `guest`
- Senha: `guest`

### 2. Navegar até Queues (Filas)

```
┌─────────────────────────────────────────┐
│  RabbitMQ Management                    │
├─────────────────────────────────────────┤
│  [Overview] [Connections] [Channels]    │
│  [Exchanges] [QUEUES] [Admin]           │  ← Clique aqui
└─────────────────────────────────────────┘
```

**Clique na aba "Queues"**

### 3. Encontrar a Fila

Você deve ver uma fila chamada:

```
📬 autottu-testride-fila
```

**Informações importantes:**

| Campo | O que significa |
|-------|----------------|
| **Ready** | Mensagens aguardando processamento |
| **Unacked** | Mensagens sendo processadas |
| **Total** | Total de mensagens |
| **Message rate** | Taxa de mensagens/segundo |

### 4. Ver Detalhes da Fila

**Clique no nome da fila:** `autottu-testride-fila`

Você verá:

```
┌─────────────────────────────────────────┐
│  Queue: autottu-testride-fila           │
├─────────────────────────────────────────┤
│  Overview                               │
│    Ready: 0                             │
│    Unacknowledged: 0                    │
│    Total: 5  ← Total de msgs enviadas  │
│                                          │
│  Message rates                          │
│    Incoming: 0.5/s                      │
│    Deliver: 0.5/s                       │
│                                          │
│  Get messages  ← Clique aqui            │
└─────────────────────────────────────────┘
```

### 5. Ler Mensagens da Fila

**Role para baixo até "Get messages"**

```
┌─────────────────────────────────────────┐
│  Get messages                           │
├─────────────────────────────────────────┤
│  Number of messages: [1]                │
│  Ackmode: [Automatic ack ▼]             │
│  Encoding: [Auto ▼]                     │
│                                          │
│  [Get Message(s)]  ← Clique aqui        │
└─────────────────────────────────────────┘
```

**Resultado esperado:**

```json
{
  "testRideId": 1,
  "nomeUsuario": "Admin User",
  "emailUsuario": "admin@autottu.com",
  "nomeMoto": "Honda CB 500X",
  "dataDesejada": "2025-11-15",
  "status": "APROVADO",
  "proposito": "Teste RabbitMQ"
}
```

---

## 📊 PARTE 5: Verificar Estatísticas

### Na aba "Overview" do painel:

```
┌─────────────────────────────────────────┐
│  Overview                               │
├─────────────────────────────────────────┐
│  Totals                                 │
│    Queued messages: 0                   │
│    Message rates: 1.2/s                 │
│    Total messages: 5  ← Mensagens       │
│                                          │
│  Nodes                                  │
│    rabbit@hostname: running ✅          │
└─────────────────────────────────────────┘
```

---

## 🔍 CHECKLIST COMPLETO

Use este checklist para verificar se tudo está funcionando:

### ✅ Configuração

- [ ] `spring.profiles.active=mock` está **comentado**
- [ ] RabbitMQ container está rodando (`docker ps`)
- [ ] Aplicação foi **reiniciada** após mudar configuração

### ✅ Envio

- [ ] Test Ride criado e aprovado
- [ ] Logs no console mostram "ENVIANDO VIA RABBITMQ"
- [ ] Logs no console mostram "MENSAGEM RECEBIDA DO RABBITMQ"
- [ ] **SEM** mensagens de "MODO MOCK"

### ✅ RabbitMQ Painel

- [ ] Consegue acessar http://localhost:15672
- [ ] Login com guest/guest funciona
- [ ] Aba "Queues" mostra `autottu-testride-fila`
- [ ] Total de mensagens > 0
- [ ] Consegue ler mensagens com "Get messages"

---

## 🆘 Troubleshooting

### Problema: "Modo Mock" aparece nos logs

**Solução:**
```powershell
# 1. Parar aplicação (Ctrl+C)
# 2. Verificar application.properties linha 37 - deve estar comentado:
# spring.profiles.active=mock

# 3. Reiniciar
mvn spring-boot:run
```

### Problema: Fila não aparece no painel

**Solução:**
```powershell
# Verificar se RabbitMQ está rodando
docker ps --filter name=rabbitmq-autottu

# Se não estiver, iniciar:
docker start rabbitmq-autottu
```

### Problema: "Connection refused" nos logs

**Solução:**
```powershell
# Verificar se RabbitMQ está acessível
docker logs rabbitmq-autottu

# Reiniciar RabbitMQ
docker restart rabbitmq-autottu

# Aguardar 10 segundos e reiniciar aplicação
mvn spring-boot:run
```

### Problema: Ready = 0, mas enviou mensagens

**✅ Isso é NORMAL!**

Significa que as mensagens foram:
1. Enviadas para a fila
2. Imediatamente processadas pelo consumidor
3. Removidas da fila

**Para ver mensagens acumuladas:**
1. Comente a classe `RabbitMQConsumidor` temporariamente
2. Reinicie a aplicação
3. Envie mensagens
4. Agora elas vão ficar na fila (Ready > 0)

---

## 📸 Screenshots de Referência

### Painel RabbitMQ - Queues

```
Name                       Ready  Unacked  Total  Rate in  Rate out
──────────────────────────────────────────────────────────────────
autottu-testride-fila      0      0        5      0.5/s    0.5/s
```

### Mensagem na Fila

```
Exchange: autottu-testride-roteador
Routing Key: autottu-testride-aprovado
Properties:
  content_type: application/json
  
Payload:
{
  "testRideId": 1,
  "nomeUsuario": "Admin User",
  ...
}
```

---

## 🎯 Resumo Visual

```
1. Aprovar Test Ride
        ↓
2. Aplicação envia para RabbitMQ
   (veja logs no console)
        ↓
3. RabbitMQ recebe na fila
   (veja em localhost:15672 > Queues)
        ↓
4. Consumidor processa
   (veja logs "MENSAGEM RECEBIDA")
        ↓
5. Fila fica vazia (Ready = 0)
   ✅ Funcionando!
```

---

**🎉 Pronto! Agora você sabe exatamente onde olhar!** 🚀

