
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

## 2. Verificação de Identidade

RF07 – O sistema deve solicitar verificação de identidade no primeiro cadastro.  
RF08 – O sistema deve capturar uma imagem pelo app para verificação.  
RF09 – O sistema deve validar a presença de um rosto na imagem capturada.  
RF10 – O sistema deve validar a presença de um documento na imagem capturada.  

## 3. Consulta de Quartos

RF11 – O sistema deve permitir consultar quartos informando:  
- Data de check-in
- Data de check-out
- Número de hóspedes

RF12 – O sistema deve exibir os quartos disponíveis para o período selecionado.  
RF13 – O sistema deve apresentar as informações de cada quarto:  
- Fotos
- Descrição
- Capacidade
- Comodidades
- Valor da diária

RF14 – O sistema deve indicar indisponibilidade quando não houver quartos livres.

## 4. Reservas

RF15 – O sistema deve permitir ao cliente selecionar e reservar um quarto disponível.  
RF16 – O sistema deve calcular automaticamente o valor total da hospedagem.  
RF17 – O sistema deve associar a reserva ao usuário cadastrado.  
RF18 – O sistema deve impedir reservas em períodos já ocupados.  
RF19 – O sistema deve exibir uma tela de confirmação após a reserva ser realizada.  

## 5. Gerenciamento de Reservas

RF20 – O cliente deve visualizar suas reservas ativas e anteriores.  
RF21 – O cliente deve poder cancelar reservas gratuitamente em até 48h antes do check-in.  
RF22 – O sistema deve informar ao cliente sobre a tarifa de cancelamento fora do prazo.  

## 6. Painel Administrativo

RF23 – O ADM deve visualizar todos os hóspedes cadastrados.  
RF24 – O ADM deve visualizar todas as reservas ativas.  
RF25 – O ADM deve confirmar o check-in e check-out dos hóspedes.  
RF26 – O ADM deve registrar o pagamento presencial marcando a reserva como PAGO.  
RF27 – O ADM deve gerenciar os quartos cadastrados e seus status.  
RF28 – O ADM deve atualizar valores das diárias dos quartos.  

## 7. Chatbot de Atendimento

RF29 – O sistema deve disponibilizar um chatbot para atendimento ao cliente.  
RF30 – O chatbot deve responder dúvidas sobre o hotel, quartos e reservas.  
RF31 – O chatbot deve sugerir contato com atendente humano quando não souber responder.  
