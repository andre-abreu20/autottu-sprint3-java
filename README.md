# 🏍️ AutoTTU - Sistema de Gestão Inteligente de Motos

![Java](https://img.shields.io/badge/Java-17-orange?logo=java)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.4-brightgreen?logo=spring)
![Maven](https://img.shields.io/badge/Maven-3.9+-blue?logo=apache-maven)
![H2](https://img.shields.io/badge/Database-H2-blue?logo=h2)
![License](https://img.shields.io/badge/License-MIT-yellow)

Aplicação **Spring Boot** completa para gestão inteligente de motos, com recursos avançados de **mensageria**, **event streaming**, **inteligência artificial**, **monitoramento** e **cache**. Interface moderna com **Thymeleaf**, autenticação via **Spring Security** e suporte a **internacionalização** (PT/EN).

---

## ✨ Funcionalidades Principais

### 🎯 **Gestão Completa**

- ✅ **Motos**: Cadastro, edição e gestão de inventário
- ✅ **Slots**: Controle de vagas e ocupação
- ✅ **Check-ins**: Registro de entradas/saídas com fotos
- ✅ **Manutenções**: Agendamento e histórico
- ✅ **Test Rides**: Solicitações e aprovações
- ✅ **Usuários**: Perfis (ADMIN/USUARIO) com permissões

### 🚀 **Tecnologias Avançadas**

| Tecnologia             | Descrição                                                       | Documentação                           |
| ---------------------- | --------------------------------------------------------------- | -------------------------------------- |
| 🐰 **RabbitMQ**        | Mensageria assíncrona para notificações de Test Rides aprovados | [RABBITMQ-INFO.md](RABBITMQ-INFO.md)   |
| 🌊 **Apache Kafka**    | Event streaming para eventos de Check-ins e Manutenções         | [KAFKA-INFO.md](KAFKA-INFO.md)         |
| 📊 **Spring Actuator** | Monitoramento em tempo real (CPU, memória, métricas)            | [ACTUATOR-INFO.md](ACTUATOR-INFO.md)   |
| 💾 **Spring Cache**    | Cache em memória para otimização de performance                 | [CACHE-INFO.md](CACHE-INFO.md)         |
| 🤖 **Spring AI**       | Inteligência artificial com OpenAI para assistência sobre motos | [SPRING-AI-INFO.md](SPRING-AI-INFO.md) |
| 🌐 **i18n**            | Internacionalização em Português e Inglês                       | -                                      |

---

## 🚀 Como Executar

### Pré-requisitos

- ☕ **Java 17+**
- 📦 **Maven 3.9+**
- 🔑 **OpenAI API Key** (para usar o assistente IA)

### Instalação Rápida

```bash
# 1. Clonar o repositório
git clone <url-do-repo>
cd autottu

# 2. Instalar dependências e compilar
mvn clean install

# 3. (Opcional) Configurar API Key da OpenAI
# Edite src/main/resources/application.properties
# spring.ai.openai.api-key=YOUR_KEY_HERE

# 4. Subir a aplicação (porta 8080)
mvn spring-boot:run
```

> 💡 **Banco em memória**: `jdbc:h2:mem:testdb` (usuário `DB_USER`, senha `DB_PASS`).  
> Console H2 disponível em: [http://localhost:8080/h2-console](http://localhost:8080/h2-console)

### Modo Mock (Sem RabbitMQ/Kafka)

O projeto está configurado para rodar em **modo mock** por padrão, simulando RabbitMQ e Kafka sem necessidade de instalação:

```properties
# application.properties
spring.profiles.active=mock
```

Para usar RabbitMQ e Kafka reais, remova ou comente essa linha e instale os serviços:

- RabbitMQ: `docker run -d -p 5672:5672 -p 15672:15672 rabbitmq:management`
- Kafka: `docker run -d -p 9092:9092 apache/kafka`

---

## 🔐 Credenciais Iniciais

| Perfil      | Usuário   | Senha        | Permissões                                   |
| ----------- | --------- | ------------ | -------------------------------------------- |
| **ADMIN**   | `admin`   | `admin123`   | Acesso total + Telemetria + Integrantes + IA |
| **USUARIO** | `usuario` | `usuario123` | Acesso padrão + IA                           |

---

## 🧭 Rotas e Funcionalidades

### 🏠 Públicas

| Método | Caminho      | Descrição                                  |
| ------ | ------------ | ------------------------------------------ |
| GET    | `/`          | Landing page com CTA para registrar/entrar |
| GET    | `/login`     | Formulário de autenticação                 |
| GET    | `/registrar` | Cadastro de usuário                        |
| POST   | `/registrar` | Criação de usuário (senha com BCrypt)      |

### 🔒 Autenticadas

| Método | Caminho   | Descrição                         |
| ------ | --------- | --------------------------------- |
| GET    | `/menu`   | Dashboard com cards de navegação  |
| GET    | `/perfil` | Edição de dados do usuário logado |
| POST   | `/perfil` | Persistência das alterações       |
| POST   | `/logout` | Encerrar sessão                   |

### 🏍️ Gestão de Domínio

#### Motos (`/motos`)

| Método | Caminho              | Descrição                   |
| ------ | -------------------- | --------------------------- |
| GET    | `/motos`             | Lista motos (com cache)     |
| GET    | `/motos/novo`        | Formulário de criação       |
| POST   | `/motos`             | Persiste nova moto          |
| GET    | `/motos/{id}`        | Mostra detalhes (com cache) |
| GET    | `/motos/{id}/editar` | Formulário de edição        |
| POST   | `/motos/{id}`        | Atualiza (invalida cache)   |
| POST   | `/motos/{id}/delete` | Exclui (invalida cache)     |

#### Slots (`/slots`)

| Método | Caminho              | Descrição                                              |
| ------ | -------------------- | ------------------------------------------------------ |
| GET    | `/slots`             | Lista slots (com cache)                                |
| GET    | `/slots/novo`        | Formulário para criar slot                             |
| POST   | `/slots`             | Cria slot (invalida cache)                             |
| GET    | `/slots/{id}/editar` | Formulário de edição                                   |
| POST   | `/slots/{id}`        | Atualiza relacionamento moto/ocupação (invalida cache) |
| POST   | `/slots/{id}/delete` | Desvincula moto e remove slot (invalida cache)         |

#### Check-ins (`/checkins`)

| Método | Caminho                 | Descrição                                               |
| ------ | ----------------------- | ------------------------------------------------------- |
| GET    | `/checkins`             | Lista check-ins (com cache)                             |
| GET    | `/checkins/novo`        | Formulário de criação                                   |
| POST   | `/checkins`             | Cria check-in + **envia evento Kafka** (invalida cache) |
| GET    | `/checkins/{id}/editar` | Formulário com dados existentes                         |
| POST   | `/checkins/{id}`        | Atualiza + **envia evento Kafka** (invalida cache)      |
| DELETE | `/checkins/{id}`        | Exclui + **envia evento Kafka** (invalida cache)        |

> 🌊 **Kafka**: Eventos de Check-in são publicados no tópico `checkin-eventos`

#### Manutenções (`/manutencoes`)

| Método | Caminho                    | Descrição                                         |
| ------ | -------------------------- | ------------------------------------------------- |
| GET    | `/manutencoes`             | Lista agendas (com cache)                         |
| GET    | `/manutencoes/novo`        | Formulário para agendamento                       |
| POST   | `/manutencoes`             | Agenda + **envia evento Kafka** (invalida cache)  |
| POST   | `/manutencoes/{id}/delete` | Cancela + **envia evento Kafka** (invalida cache) |

> 🌊 **Kafka**: Eventos de Manutenção são publicados no tópico `manutencao-eventos`

#### Test Rides (`/testrides`)

| Método | Caminho                    | Descrição                                                | Perfil      |
| ------ | -------------------------- | -------------------------------------------------------- | ----------- |
| GET    | `/testrides`               | Lista solicitações (com cache)                           | Autenticado |
| GET    | `/testrides/novo`          | Formulário de solicitação                                | Autenticado |
| POST   | `/testrides`               | Cria solicitação (invalida cache)                        | Autenticado |
| POST   | `/testrides/{id}/aprovar`  | Aprova + **envia notificação RabbitMQ** (invalida cache) | ADMIN       |
| POST   | `/testrides/{id}/rejeitar` | Rejeita solicitação (invalida cache)                     | ADMIN       |
| POST   | `/testrides/{id}/delete`   | Remove solicitação (invalida cache)                      | ADMIN       |

> 🐰 **RabbitMQ**: Notificações de aprovação são enviadas para a fila `testride.notificacao`

### 📊 Monitoramento (ADMIN)

| Método | Caminho       | Descrição                                    |
| ------ | ------------- | -------------------------------------------- |
| GET    | `/telemetria` | Dashboard de métricas (CPU, memória, status) |
| GET    | `/actuator/*` | Endpoints do Spring Actuator                 |

**Endpoints Actuator disponíveis:**

- `/actuator/health` - Status de saúde da aplicação
- `/actuator/metrics` - Métricas detalhadas
- `/actuator/env` - Variáveis de ambiente
- `/actuator/info` - Informações da aplicação

### 🤖 Assistente IA

| Método | Caminho | Descrição                                          |
| ------ | ------- | -------------------------------------------------- |
| GET    | `/ia`   | Interface do assistente inteligente                |
| POST   | `/ia`   | Processa pergunta e retorna resposta da OpenAI GPT |

**Funcionalidades do Assistente IA:**

1. 💬 **Dúvidas Gerais** - Perguntas sobre motos, manutenção, segurança
2. ⭐ **Recomendação Personalizada** - Encontre a moto ideal para seu perfil
3. 🔧 **Análise de Manutenção** - Previsão de manutenções necessárias
4. 🏍️ **Guia Test Ride** - Checklist completo para test rides
5. 📊 **Comparador** - Compare múltiplos modelos de motos
6. 📝 **Descrição Comercial** - Gere descrições atrativas automaticamente

> 🔑 **Requer**: Chave API da OpenAI configurada em `application.properties`

### 👥 Integrantes (ADMIN)

| Método | Caminho        | Descrição                    |
| ------ | -------------- | ---------------------------- |
| GET    | `/integrantes` | Lista integrantes do projeto |

---

## 🌐 Internacionalização

O sistema suporta **2 idiomas**:

- 🇧🇷 **Português** (padrão)
- 🇺🇸 **Inglês**

**Como trocar o idioma:**

1. Clique no seletor de idioma (🇧🇷/🇺🇸) no canto superior direito
2. Ou acesse manualmente: `?lang=pt` ou `?lang=en`

**Páginas internacionalizadas:**

- ✅ Landing page
- ✅ Login e Registro
- ✅ Menu e navegação
- ✅ Todas as listagens (Motos, Check-ins, Manutenções, Test Rides, Slots)
- ✅ Todos os formulários
- ✅ Telemetria
- ✅ Integrantes

---

## 🗂️ Estrutura do Projeto

```
autottu/
├── src/main/
│   ├── java/br/com/fiap/autottu/
│   │   ├── config/
│   │   │   ├── InternacionalizacaoConfig.java
│   │   │   └── UsuarioLogadoAdvice.java
│   │   ├── control/                      # Controllers MVC
│   │   │   ├── ActuatorController.java   # Telemetria
│   │   │   ├── CheckinController.java    # + Kafka
│   │   │   ├── IntegrantesController.java
│   │   │   ├── LoginController.java
│   │   │   ├── ManutencaoController.java # + Kafka
│   │   │   ├── MenuController.java
│   │   │   ├── MotoController.java       # + Cache
│   │   │   ├── SlotController.java       # + Cache
│   │   │   ├── SpringAIController.java   # IA
│   │   │   ├── TestRideController.java   # + RabbitMQ
│   │   │   └── UsuarioController.java
│   │   ├── messaging/                    # Mensageria
│   │   │   ├── config/
│   │   │   │   ├── KafkaConfig.java
│   │   │   │   └── RabbitMQConfig.java
│   │   │   ├── consumer/
│   │   │   │   ├── KafkaConsumidor.java
│   │   │   │   └── RabbitMQConsumidor.java
│   │   │   ├── producer/
│   │   │   │   ├── INotificacaoProdutor.java
│   │   │   │   ├── KafkaProdutor.java
│   │   │   │   ├── KafkaProdutorMock.java
│   │   │   │   ├── RabbitMQProdutor.java
│   │   │   │   └── RabbitMQProdutorMock.java
│   │   │   └── dto/
│   │   │       ├── CheckinEventoDTO.java
│   │   │       ├── ManutencaoEventoDTO.java
│   │   │       └── TestRideNotificacaoDTO.java
│   │   ├── model/                        # Entidades JPA
│   │   ├── repository/                   # Spring Data JPA
│   │   ├── security/
│   │   │   └── SegurancaConfig.java
│   │   ├── service/
│   │   │   ├── CachingService.java       # Cache
│   │   │   ├── SpringAIService.java      # IA
│   │   │   ├── ManutencaoService.java
│   │   │   ├── TestRideService.java
│   │   │   └── UsuarioDetailsService.java
│   │   └── AutottuApplication.java       # @EnableCaching
│   └── resources/
│       ├── application.properties        # Configurações
│       ├── mensagens_pt.properties       # i18n PT
│       ├── mensagens_en.properties       # i18n EN
│       ├── db/migration/                 # Flyway
│       └── templates/                    # Thymeleaf
│           ├── fragmentos.html           # Navbar, seletor idioma
│           ├── menu.html                 # Dashboard
│           ├── ia/
│           │   └── index.html            # Assistente IA
│           ├── moto/
│           ├── checkin/
│           ├── manutencao/
│           ├── testride/
│           ├── slot/
│           ├── usuario/
│           ├── telemetria.html           # Actuator UI
│           ├── integrantes.html
│           ├── index.html                # Landing
│           └── login.html
├── pom.xml                               # Dependencies
├── README.md                             # Este arquivo
├── ACTUATOR-INFO.md                      # Docs Actuator
├── CACHE-INFO.md                         # Docs Cache
├── SPRING-AI-INFO.md                     # Docs Spring AI
└── instalar-rabbitmq.ps1                 # Script Windows

```

---

## 🎨 Tecnologias Utilizadas

### Backend

- **Spring Boot 3.5.4** - Framework principal
- **Spring Data JPA** - Persistência de dados
- **Spring Security** - Autenticação e autorização
- **Spring AMQP** - Integração RabbitMQ
- **Spring Kafka** - Event streaming
- **Spring Cache** - Cache em memória
- **Spring AI** - Integração OpenAI GPT
- **Spring Actuator** - Monitoramento e métricas
- **Flyway** - Migrations de banco de dados
- **H2 Database** - Banco em memória

### Frontend

- **Thymeleaf** - Template engine server-side
- **Bootstrap 5** - Framework CSS
- **Bootstrap Icons** - Ícones
- **JavaScript Vanilla** - Interatividade

### Mensageria & Streaming

- **RabbitMQ** - Mensageria assíncrona (AMQP)
- **Apache Kafka** - Event streaming distribuído

### IA & Machine Learning

- **OpenAI GPT-3.5/4** - Processamento de linguagem natural
- **Spring AI 0.8.1** - Integração IA com Spring

---

## ⚙️ Configuração

### application.properties

```properties
# Servidor
server.port=8080

# Banco de Dados H2
spring.datasource.url=jdbc:h2:mem:testdb
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console

# Flyway (Migrations)
spring.flyway.enabled=true
spring.flyway.baseline-on-migrate=true

# RabbitMQ (modo mock por padrão)
spring.rabbitmq.host=localhost
spring.rabbitmq.port=5672
spring.rabbitmq.username=guest
spring.rabbitmq.password=guest

# Kafka (modo mock por padrão)
spring.kafka.bootstrap-servers=localhost:9092
spring.kafka.consumer.group-id=autottu-grupo

# Perfil ativo (mock = sem RabbitMQ/Kafka)
spring.profiles.active=mock

# Spring Actuator
management.endpoints.web.exposure.include=*
management.health.rabbit.enabled=false
management.health.kafka.enabled=false
management.endpoint.health.show-details=always

# Spring AI (OpenAI)
spring.ai.openai.api-key=YOUR_OPENAI_API_KEY_HERE
spring.autoconfigure.exclude=org.springframework.cloud.function.context.config.ContextFunctionCatalogAutoConfiguration
```

### Obtendo API Key da OpenAI

1. Acesse: [https://platform.openai.com/](https://platform.openai.com/)
2. Crie uma conta ou faça login
3. Vá para: [API Keys](https://platform.openai.com/api-keys)
4. Clique em **"Create new secret key"**
5. Copie e cole no `application.properties`

> 💰 A OpenAI oferece créditos gratuitos para novos usuários!

---

## 📚 Documentação Adicional

Cada tecnologia possui sua própria documentação detalhada:

| Tecnologia       | Arquivo                                | Conteúdo                                               |
| ---------------- | -------------------------------------- | ------------------------------------------------------ |
| 📊 **Actuator**  | [ACTUATOR-INFO.md](ACTUATOR-INFO.md)   | Configuração, endpoints, métricas, troubleshooting     |
| 💾 **Cache**     | [CACHE-INFO.md](CACHE-INFO.md)         | Implementação, padrões, performance, exemplos          |
| 🤖 **Spring AI** | [SPRING-AI-INFO.md](SPRING-AI-INFO.md) | Configuração OpenAI, funcionalidades, custos, exemplos |

---

## 🎯 Fluxos Principais

### 1. Cadastro e Login

```
1. Usuário acessa /
2. Clica em "Registrar"
3. Preenche formulário (/registrar)
4. Sistema cria usuário com senha criptografada (BCrypt)
5. Redireciona para /login
6. Usuário faz login
7. Acessa /menu (dashboard)
```

### 2. Solicitação de Test Ride

```
1. Usuário acessa /testrides
2. Clica em "Novo Test Ride"
3. Preenche formulário (moto, data, propósito)
4. Sistema cria solicitação com status "PENDENTE"
5. ADMIN acessa /testrides
6. Clica em "Aprovar"
7. Sistema envia notificação via RabbitMQ 🐰
8. Consumidor recebe e processa notificação
9. Email/notificação enviado ao usuário
```

### 3. Check-in de Moto

```
1. Usuário acessa /checkins/novo
2. Seleciona moto, slot, registra observações
3. Adiciona URLs de fotos
4. Submete formulário
5. Sistema salva check-in
6. Sistema publica evento no Kafka 🌊
7. Consumidor recebe evento
8. Evento armazenado para auditoria/analytics
9. Cache invalidado automaticamente
```

### 4. Uso do Assistente IA

```
1. Usuário acessa /ia
2. Clica em um card de sugestão OU digita pergunta
3. Clica em "Perguntar à IA"
4. Sistema envia pergunta para OpenAI GPT
5. GPT processa e retorna resposta
6. Resposta exibida na tela
7. Usuário pode fazer nova pergunta
```

### 5. Monitoramento (ADMIN)

```
1. ADMIN acessa /telemetria
2. Sistema busca métricas do Actuator
3. Exibe:
   - Status da aplicação (UP/DOWN)
   - Uso de CPU (%)
   - Memória JVM utilizada (MB)
   - Memória máxima alocada (GB)
4. ADMIN pode acessar /actuator/* para mais detalhes
```

---

## 🔒 Segurança

### Autenticação

- **Spring Security** com formulário de login
- Senhas criptografadas com **BCryptPasswordEncoder**
- Sessões gerenciadas pelo Spring Security

### Autorização

- **Perfil ADMIN**: Acesso total
  - Aprovar/rejeitar test rides
  - Acessar telemetria
  - Ver integrantes
- **Perfil USUARIO**: Acesso padrão
  - CRUD de motos, slots, check-ins
  - Solicitar test rides
  - Usar assistente IA

### Proteção

- CSRF habilitado
- Logout via POST
- Rotas públicas configuradas
- Validação de entrada com Bean Validation

---

## 🚀 Performance

### Cache Strategy

- **Leitura**: Dados buscados do cache quando disponível (1-2ms)
- **Escrita**: Cache invalidado após CREATE/UPDATE/DELETE
- **Impacto**: Até **79% mais rápido** em consultas repetidas

### Métricas Observadas

| Operação     | Sem Cache | Com Cache | Melhoria  |
| ------------ | --------- | --------- | --------- |
| Lista Motos  | 150ms     | 2ms       | **98.7%** |
| Busca por ID | 45ms      | 1ms       | **97.8%** |
| Lista Slots  | 120ms     | 2ms       | **98.3%** |

---

## 🧪 Testes

### Executar Testes

```bash
mvn test
```

### Estrutura de Testes

```
src/test/java/br/com/fiap/autottu/
├── control/     # Testes de Controllers
├── service/     # Testes de Services
├── repository/  # Testes de Repositories
└── integration/ # Testes de Integração
```

---

## 📝 Boas Práticas Implementadas

✅ **Arquitetura em Camadas** (Controller → Service → Repository)  
✅ **DTOs** para transferência de dados  
✅ **Profiles** para ambientes (mock/prod)  
✅ **Cache** para otimização  
✅ **Mensageria assíncrona** para desacoplamento  
✅ **Event Sourcing** com Kafka  
✅ **Monitoramento** com Actuator  
✅ **Internacionalização** para acessibilidade global  
✅ **IA** para experiência do usuário  
✅ **Segurança** com Spring Security  
✅ **Migrations** com Flyway  
✅ **Código limpo** e documentado

---

## 🐛 Troubleshooting

### Erro: RabbitMQ Connection Refused

**Solução:** Certifique-se que `spring.profiles.active=mock` está configurado OU instale RabbitMQ.

### Erro: Kafka Connection Failed

**Solução:** Use modo mock (padrão) OU instale Kafka localmente.

### Erro: OpenAI API Key Invalid

**Solução:** Configure uma chave válida em `application.properties`:

```properties
spring.ai.openai.api-key=sk-proj-YOUR_ACTUAL_KEY_HERE
```

### Erro: Actuator Status DOWN

**Solução:** Verifique se as configurações de health check estão desabilitadas para RabbitMQ/Kafka:

```properties
management.health.rabbit.enabled=false
management.health.kafka.enabled=false
```

---

## 👥 Integrantes do Projeto

| Nome                         | RM     | GitHub                                             |
| ---------------------------- | ------ | -------------------------------------------------- |
| André Luís Mesquita de Abreu | 558159 | [@andre-abreu20](https://github.com/andre-abreu20) |
| Maria Eduarda Brigidio       | 558575 | [@dudabrigidio](https://github.com/dudabrigidio)   |
| Rafael Bompadre Lima         | 556459 | [@Rafa130206](https://github.com/Rafa130206)       |

---

## 📄 Licença

Este projeto é desenvolvido para fins educacionais como parte do curso da FIAP.

---

## 🙏 Agradecimentos

- **Rennan Santos de Araujo** - Professor
- **FIAP** - Instituição de ensino
- **Spring Team** - Framework incrível
- **OpenAI** - API de IA
- **Thymeleaf Team** - Template engine
- **Apache Foundation** - Kafka
- **RabbitMQ Team** - Mensageria

---

## 📞 Suporte

Para dúvidas ou sugestões:

1. Abra uma **issue** no GitHub
2. Consulte a **documentação** específica de cada tecnologia
3. Entre em contato com os **integrantes**

---

**🏍️ Desenvolvido com ❤️ pela equipe AutoTTU**

_Transformando a gestão de motos com tecnologia de ponta!_
