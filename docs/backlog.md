# Backlog do Projeto — Barra Hotel App

## Épico 1 – Autenticação e Perfis

* Tela de Splash
* Tela de cadastro de usuário (cliente)
* Tela de login
* Diferenciação de perfil (ADM / Cliente) após login
* Integração com Firebase Authentication

## Épico 2 – Gestão de Quartos

* Mock de quartos com status (disponível/ocupado)
* Listagem de quartos disponíveis
* Visualização de detalhes do quarto
* Atualização de status do quarto após reserva
* Integração com Firebase Firestore

## Épico 3 – Reservas

* Realizar reserva de quarto (Cliente)
* Visualizar reserva ativa (Cliente)
* Listar todas as reservas (ADM)
* Encerrar locação (ADM)
* Atualizar status do quarto ao encerrar locação

## Épico 4 – Painel Administrativo

* Visualização de todos os hóspedes cadastrados
* Consulta de locações ativas
* Controle geral de ocupação dos quartos
* Editar informações de hóspedes
* Excluir cadastro de hóspede

## Épico 5 – Chatbot de Atendimento

* Definição do escopo de respostas do chatbot
* Integração com a API da Anthropic (Claude)
* Tela de chat no app
* Chatbot responde dúvidas sobre o hotel, quartos e reservas

## Épico 6 – Verificação de Identidade com IA

* Integração com Google ML Kit (Flutter)
* Tela de captura de imagem pelo app
* Validação de presença de rosto na imagem
* Validação de presença de documento na imagem
* Acionamento apenas no primeiro cadastro ou reserva

## Épico 7 – Infraestrutura e Banco de Dados

* Configuração do Firebase no projeto Flutter
* Migração do mock de usuários para o Firestore
* Migração do mock de quartos para o Firestore
* Regras de segurança do Firebase