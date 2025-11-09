# 🐰 Guia Completo: RabbitMQ com Docker - AutoTTU

## 📋 Pré-requisitos

- ✅ Windows 10/11
- ✅ Docker Desktop instalado
- ✅ PowerShell (já vem no Windows)

---

## 🚀 PASSO 1: Instalar Docker Desktop

### 1.1 Verificar se já tem Docker

Abra o **PowerShell** e execute:

```powershell
docker --version
```

**Se aparecer algo como:**
```
Docker version 24.0.7, build afdd53b
```
✅ **Docker já está instalado! Pule para o PASSO 2**

**Se aparecer erro:**
❌ **Precisa instalar Docker**

### 1.2 Baixar Docker Desktop

1. Acesse: https://www.docker.com/products/docker-desktop/
2. Clique em **"Download for Windows"**
3. Execute o instalador baixado
4. Siga o assistente (deixe as opções padrão)
5. **Reinicie o computador** quando solicitado
6. Após reiniciar, abra o **Docker Desktop** do menu iniciar
7. Aguarde o Docker iniciar (ícone de baleia no canto inferior direito)

### 1.3 Verificar Instalação

```powershell
docker --version
docker ps
```

Se não der erro, está pronto! ✅

---

## 🐰 PASSO 2: Baixar e Executar RabbitMQ

### 2.1 Baixar a Imagem do RabbitMQ

Abra o **PowerShell** e execute:

```powershell
docker pull rabbitmq:management
```

**O que isso faz?**
- Baixa a imagem oficial do RabbitMQ
- Inclui o painel de gerenciamento web
- Tamanho: ~200 MB
- **Precisa de internet apenas 1 vez**

**Resultado esperado:**
```
management: Pulling from library/rabbitmq
...
Status: Downloaded newer image for rabbitmq:management
```

### 2.2 Executar o Container RabbitMQ

```powershell
docker run -d `
  --name rabbitmq-autottu `
  -p 5672:5672 `
  -p 15672:15672 `
  -e RABBITMQ_DEFAULT_USER=guest `
  -e RABBITMQ_DEFAULT_PASS=guest `
  rabbitmq:management
```

**Explicação dos parâmetros:**
- `-d`: Roda em background (daemon)
- `--name rabbitmq-autottu`: Nome do container
- `-p 5672:5672`: Porta para aplicação conectar
- `-p 15672:15672`: Porta do painel web
- `-e`: Define usuário e senha padrão
- `rabbitmq:management`: Imagem a usar

**Resultado esperado:**
```
abc123def456...  (ID do container)
```

### 2.3 Verificar se está Rodando

```powershell
docker ps
```

**Deve aparecer algo assim:**
```
CONTAINER ID   IMAGE                  STATUS         PORTS
abc123def456   rabbitmq:management    Up 10 seconds  5672/tcp, 15672/tcp
```

✅ **RabbitMQ está rodando!**

---

## 🌐 PASSO 3: Acessar o Painel Web

### 3.1 Abrir no Navegador

Acesse: http://localhost:15672

### 3.2 Fazer Login

```
Usuário: guest
Senha: guest
```

### 3.3 O que você verá

- 📊 **Overview**: Status geral do RabbitMQ
- 📬 **Queues**: Filas de mensagens
- 🔄 **Exchanges**: Roteadores
- 🔗 **Connections**: Conexões ativas

✅ **Se conseguiu acessar, o RabbitMQ está funcionando perfeitamente!**

---

## ⚙️ PASSO 4: Configurar o AutoTTU

### 4.1 Editar application.properties

Abra: `autottu/src/main/resources/application.properties`

**ANTES (linha 37):**
```properties
spring.profiles.active=mock
```

**DEPOIS (comentar a linha):**
```properties
# spring.profiles.active=mock
```

### 4.2 Habilitar Health Check do RabbitMQ

**ANTES (linha 47):**
```properties
management.health.rabbit.enabled=false
```

**DEPOIS:**
```properties
management.health.rabbit.enabled=true
```

### 4.3 Verificar Configurações RabbitMQ

As configurações já estão corretas (linhas 26-30):
```properties
spring.rabbitmq.host=localhost
spring.rabbitmq.port=5672
spring.rabbitmq.username=guest
spring.rabbitmq.password=guest
```

✅ **Configuração concluída!**

---

## 🚀 PASSO 5: Executar a Aplicação

### 5.1 Parar a aplicação se estiver rodando

No terminal onde a aplicação está rodando:
- Pressione `Ctrl+C`

### 5.2 Limpar e Recompilar

```powershell
cd C:\Users\T-GAMER\Downloads\Arquivos da Aula - 12_09 - Turma_H 1\autottu
mvn clean install
```

### 5.3 Iniciar a Aplicação

```powershell
mvn spring-boot:run
```

### 5.4 O que Observar no Console

**Antes (modo mock):**
```
🧪 MODO MOCK - Simulando envio para RabbitMQ
```

**Agora (modo real):**
```
✅ Notificação enviada via RabbitMQ: {...}
```

✅ **Se viu mensagens de conexão RabbitMQ, está funcionando!**

---

## 🧪 PASSO 6: Testar Funcionalidade

### 6.1 Acessar a Aplicação

Abra o navegador: http://localhost:8080

### 6.2 Fazer Login

```
Usuário: admin
Senha: admin123
```

### 6.3 Criar e Aprovar um Test Ride

1. Clique em **"Test Rides"**
2. Clique em **"Novo Test Ride"**
3. Preencha:
   - Moto: Escolha qualquer uma
   - Data desejada: Escolha uma data futura
   - Propósito: "Teste do RabbitMQ"
4. Clique em **"Solicitar"**
5. De volta à lista, clique em **"Aprovar"**

### 6.4 Verificar os Logs

**No console da aplicação, você verá:**

```
✅ Notificação enviada via RabbitMQ: {"testRideId":1,"nomeUsuario":"Admin",...}
🎯 ====== MENSAGEM RABBITMQ RECEBIDA ======
📩 Notificação de Test Ride Aprovado
👤 Usuário: Admin
📧 Email: admin@autottu.com
🏍️ Moto: Honda CB 500X
📅 Data Desejada: 2025-11-15
✅ Status: APROVADO
📝 Propósito: Teste do RabbitMQ
===========================================
```

### 6.5 Verificar no Painel RabbitMQ

1. Acesse: http://localhost:15672
2. Clique na aba **"Queues"**
3. Você verá: `autottu-testride-fila`
4. Clique no nome da fila
5. Veja as estatísticas:
   - **Messages**: Mensagens na fila
   - **Get messages**: Buscar mensagens

✅ **Se viu tudo isso, o RabbitMQ está 100% funcional!**

---

## 📊 PASSO 7: Comandos Úteis Docker

### Verificar Status

```powershell
docker ps
```

### Ver Logs do RabbitMQ

```powershell
docker logs rabbitmq-autottu
```

### Ver últimas 50 linhas de log

```powershell
docker logs --tail 50 rabbitmq-autottu
```

### Acompanhar logs em tempo real

```powershell
docker logs -f rabbitmq-autottu
```

### Parar RabbitMQ

```powershell
docker stop rabbitmq-autottu
```

### Iniciar RabbitMQ

```powershell
docker start rabbitmq-autottu
```

### Reiniciar RabbitMQ

```powershell
docker restart rabbitmq-autottu
```

### Remover Container

```powershell
docker stop rabbitmq-autottu
docker rm rabbitmq-autottu
```

### Remover Container e Dados

```powershell
docker stop rabbitmq-autottu
docker rm -v rabbitmq-autottu
```

---

## 🔧 Troubleshooting

### Problema: Porta 5672 já em uso

**Erro:**
```
Error starting userland proxy: listen tcp4 0.0.0.0:5672: bind: address already in use
```

**Solução:**
```powershell
# Ver o que está usando a porta
netstat -ano | findstr :5672

# Matar o processo (substitua PID pelo número que apareceu)
taskkill /PID <PID> /F

# Ou use outra porta
docker run -d --name rabbitmq-autottu -p 5673:5672 -p 15673:15672 rabbitmq:management
```

### Problema: Docker não inicia

**Solução:**
1. Abra o Docker Desktop
2. Aguarde iniciar completamente
3. Tente novamente

### Problema: Erro de permissão

**Solução:**
- Execute o PowerShell como **Administrador**

### Problema: Container não sobe

**Verificar logs:**
```powershell
docker logs rabbitmq-autottu
```

**Remover e recriar:**
```powershell
docker rm -f rabbitmq-autottu
docker run -d --name rabbitmq-autottu -p 5672:5672 -p 15672:15672 rabbitmq:management
```

---

## 🎯 Resumo dos Status

| Item | Como Verificar | Status Esperado |
|------|---------------|-----------------|
| 🐳 Docker | `docker --version` | Versão instalada |
| 🐰 RabbitMQ | `docker ps` | Container UP |
| 🌐 Painel Web | http://localhost:15672 | Login funciona |
| ☕ AutoTTU | http://localhost:8080 | Aplicação rodando |
| 📡 Conexão | Logs da aplicação | Mensagens enviadas |
| 📬 Fila | Painel RabbitMQ > Queues | `autottu-testride-fila` |

---

## 🎓 Próximos Passos

Agora que o RabbitMQ está funcionando:

1. ✅ **Kafka**: Implementar Kafka com Docker também
2. ✅ **Monitoramento**: Observar filas no painel
3. ✅ **Testes**: Criar mais test rides
4. ✅ **Produção**: Considerar RabbitMQ na nuvem

---

## 📚 Recursos Adicionais

- 📖 Documentação RabbitMQ: https://www.rabbitmq.com/documentation.html
- 🐳 Docker Hub RabbitMQ: https://hub.docker.com/_/rabbitmq
- 💡 Tutoriais: https://www.rabbitmq.com/getstarted.html

---

**🎉 Parabéns! Você configurou o RabbitMQ com Docker com sucesso!** 🐰✨

