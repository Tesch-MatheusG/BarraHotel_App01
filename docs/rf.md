
# Requisitos Funcionais — Barra Hotel App

## 1. Cadastro e Autenticação

RF01 – O sistema deve permitir o cadastro de usuário contendo:
- Nome completo
- CPF
- E-mail
- Telefone
- Senha

RF02 – O sistema deve validar e-mail único por usuário.  
RF03 – O sistema deve diferenciar o perfil do usuário (Cliente / ADM) após o login.  
RF04 – O sistema deve permitir login utilizando e-mail e senha.  
RF05 – O sistema deve permitir recuperação de senha via e-mail (Firebase Authentication).  
RF06 – O usuário deve poder atualizar seus dados cadastrais.  

## 2. Consulta de Quartos

RF07 – O sistema deve permitir consultar quartos informando:  
- Data de check-in
- Data de check-out
- Número de hóspedes

RF08 – O sistema deve exibir os quartos disponíveis para o período selecionado.  
RF09 – O sistema deve apresentar as informações de cada quarto:  
- Fotos
- Descrição
- Capacidade
- Comodidades
- Valor da diária

RF10 – O sistema deve indicar indisponibilidade quando não houver quartos livres.

## 3. Reservas

RF11 – O sistema deve permitir ao cliente selecionar e reservar um quarto disponível.  
RF12 – O sistema deve calcular automaticamente o valor total da hospedagem.  
RF13 – O sistema deve associar a reserva ao usuário cadastrado.  
RF14 – O sistema deve impedir reservas em períodos já ocupados.  
RF15 – O sistema deve exibir uma tela de confirmação após a reserva ser realizada.  

## 4. Gerenciamento de Reservas

RF16 – O cliente deve visualizar suas reservas ativas e anteriores.  
RF17 – O cliente deve poder cancelar reservas gratuitamente em até 48h antes do check-in.  
RF18 – O sistema deve informar ao cliente sobre a tarifa de cancelamento fora do prazo.  

## 5. Painel Administrativo

RF19 – O ADM deve visualizar todos os hóspedes cadastrados.  
RF20 – O ADM deve visualizar todas as reservas ativas.  
RF21 – O ADM deve confirmar o check-in e check-out dos hóspedes.  
RF22 – O ADM deve registrar o pagamento presencial marcando a reserva como PAGO.  
RF23 – O ADM deve gerenciar os quartos cadastrados e seus status.  
RF24 – O ADM deve atualizar valores das diárias dos quartos.  

## 6. Chatbot de Atendimento

RF25 – O sistema deve disponibilizar um chatbot para atendimento ao cliente.  
RF26 – O chatbot deve responder dúvidas sobre o hotel, quartos e reservas.  
RF27 – O chatbot deve sugerir contato com atendente humano quando não souber responder.  
