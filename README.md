# Barra Hotel App

Projeto desenvolvido no módulo de Desenvolvimento de Sistemas Móveis.

---

## Visão do Produto

O Barra Hotel App é uma solução digital para substituir o atual sistema de cadastro de hóspedes e controle de locação de quartos, que hoje é realizado por meio de fichas físicas escritas manualmente.

O objetivo é reduzir o tempo de atendimento, melhorar a organização das informações e facilitar o controle interno das hospedagens.

O sistema será dividido em dois aplicativos:

- **Barra Hotel App** – voltado para clientes (hóspedes)
- **Barra Hotel ADM** – voltado para funcionários e administração

---

## Problema

Atualmente, o cadastro de hóspedes e a locação de quartos são realizados por meio de fichas físicas.

Isso gera:

- Perda de tempo no atendimento
- Dificuldade de organização das informações
- Risco de extravio de dados
- Dificuldade de controle das locações ativas
- Falta de um mecanismo digital de verificação de identidade

---

## Público-Alvo

- Clientes do Barra Hotel (hóspedes)
- Funcionários responsáveis pelo cadastro e controle de quartos
- Administração do hotel

---

## Objetivo do Produto

Desenvolver um aplicativo mobile que permita:

- Cadastro digital de hóspedes
- Consulta e gerenciamento de dados
- Controle de locação de quartos
- Acesso administrativo para funcionários
- Verificação digital de identidade do hóspede (em planejamento)

---

## Funcionalidade em Planejamento – Inteligência Artificial

Está prevista a implementação de um módulo de Inteligência Artificial para auxiliar na verificação de identidade do hóspede.

A proposta é utilizar reconhecimento de imagem para:

- Identificar a presença de um rosto na foto capturada
- Detectar a presença de um documento oficial com foto
- Auxiliar na confirmação de que o cliente presente é o mesmo que realizou a reserva

A funcionalidade será estudada e validada quanto à viabilidade técnica durante o desenvolvimento do projeto.

---

## Estrutura do Repositório

- `docs/` – Documentação do projeto
- `design/` – Protótipos e materiais visuais
- `src/` – Código-fonte da aplicação
- `tests/` – Testes do sistema
- `.github/` – Templates de Issues e Pull Requests

---

## Backlog (Rascunho Inicial)

### Épico 1 – Cadastro de Hóspedes
- Criar tela de cadastro
- Armazenar dados do hóspede
- Editar informações cadastradas
- Excluir cadastro

### Épico 2 – Gestão de Quartos
- Listar quartos disponíveis
- Registrar locação de quarto
- Atualizar status do quarto (disponível/ocupado)
- Encerrar locação

### Épico 3 – Aplicativo Administrativo (ADM)
- Login para funcionários
- Visualização de todos os hóspedes cadastrados
- Consulta de locações ativas
- Controle geral de ocupação

### Épico 4 – Aplicativo Cliente
- Cadastro simplificado
- Visualização de reserva
- Confirmação de locação

### Épico 5 – Verificação de Identidade com IA (Planejamento)
- Estudo de viabilidade técnica
- Definição da abordagem de reconhecimento de imagem
- Implementação de captura de imagem pelo aplicativo
- Validação da presença de rosto e documento
- Integração com fluxo de confirmação de check-in

---

## Status do Projeto

Estrutura inicial criada.
Fase atual: definição de requisitos e organização do backlog.
Funcionalidade de IA em fase de planejamento.
