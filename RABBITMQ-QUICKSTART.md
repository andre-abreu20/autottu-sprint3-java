# 🐰 RabbitMQ - Quick Start

## ⚡ Início Rápido (3 passos)

### 1️⃣ Setup Automático Completo

```powershell
.\docker-setup-completo.ps1
```

**Isso vai:**
- ✅ Verificar Docker
- ✅ Baixar e iniciar RabbitMQ
- ✅ Configurar application.properties
- ✅ Fazer backup das configurações

### 2️⃣ Compilar e Rodar

```powershell
mvn clean install
mvn spring-boot:run
```

### 3️⃣ Testar

1. Acesse: http://localhost:8080
2. Login: `admin` / `admin123`
3. Crie e aprove um Test Ride
4. Veja os logs no console! 🎉

---

## 🎮 Scripts Disponíveis

| Script | Função |
|--------|--------|
| `.\docker-setup-completo.ps1` | 🚀 Setup completo automático |
| `.\docker-rabbitmq-start.ps1` | ▶️ Iniciar RabbitMQ |
| `.\docker-rabbitmq-stop.ps1` | ⏹️ Parar RabbitMQ |
| `.\docker-rabbitmq-status.ps1` | 📊 Ver status e informações |
| `.\docker-rabbitmq-logs.ps1` | 📝 Ver logs |
| `.\docker-rabbitmq-remove.ps1` | 🗑️ Remover container |

---

## 🌐 Acessos

- **Aplicação**: http://localhost:8080
- **Painel RabbitMQ**: http://localhost:15672
  - Usuário: `guest`
  - Senha: `guest`

---

## 🔧 Comandos Docker Diretos

```powershell
# Iniciar
docker start rabbitmq-autottu

# Parar
docker stop rabbitmq-autottu

# Status
docker ps --filter name=rabbitmq-autottu

# Logs
docker logs -f rabbitmq-autottu

# Reiniciar
docker restart rabbitmq-autottu

# Remover
docker rm -f rabbitmq-autottu
```

---

## 🆘 Problemas Comuns

### Porta 5672 em uso

```powershell
# Ver o que está usando
netstat -ano | findstr :5672

# Matar processo (substitua PID)
taskkill /PID <PID> /F
```

### Docker não inicia

1. Abra Docker Desktop
2. Aguarde iniciar completamente
3. Tente novamente

### Container não sobe

```powershell
# Remover e recriar
docker rm -f rabbitmq-autottu
.\docker-rabbitmq-start.ps1
```

---

## 📚 Documentação Completa

Para guia detalhado: [GUIA-RABBITMQ-DOCKER.md](GUIA-RABBITMQ-DOCKER.md)

---

**✅ Pronto! RabbitMQ configurado em 3 minutos!** 🚀

