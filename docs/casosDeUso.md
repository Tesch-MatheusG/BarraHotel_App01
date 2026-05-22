# Casos de Uso — Barra Hotel App

## UC01 — Cadastrar Usuário

**Ator:** Cliente  
**Pré-condição:** O usuário não possui cadastro no sistema.

**Fluxo Principal:**
1. O cliente acessa a tela de cadastro
2. O sistema exibe o formulário de cadastro
3. O cliente preenche: nome completo, CPF, e-mail, telefone e senha
4. O sistema valida os dados informados
5. O sistema cria a conta do cliente via Firebase Authentication
6. O sistema redireciona o cliente para a tela inicial

**Fluxo Alternativo:**
- **FA01:** E-mail já cadastrado → o sistema informa que o e-mail já está em uso
- **FA02:** Dados incompletos → o sistema destaca os campos obrigatórios não preenchidos

---

## UC02 — Realizar Login

**Ator:** Cliente ou ADM  
**Pré-condição:** O usuário possui cadastro ativo no sistema.

**Fluxo Principal:**
1. O usuário acessa a tela de login
2. O usuário informa e-mail e senha
3. O sistema valida as credenciais via Firebase Authentication
4. O sistema identifica o perfil do usuário (Cliente ou ADM)
5. O sistema redireciona para a tela correspondente ao perfil

**Fluxo Alternativo:**
- **FA01:** Credenciais inválidas → o sistema exibe mensagem de erro
- **FA02:** 5 tentativas consecutivas inválidas → o sistema bloqueia a conta por 15 minutos
- **FA03:** Usuário esqueceu a senha → o sistema envia e-mail de recuperação via Firebase

---

## UC03 — Consultar Quartos Disponíveis

**Ator:** Cliente  
**Pré-condição:** O cliente está autenticado no sistema.

**Fluxo Principal:**
1. O cliente acessa a tela de consulta de quartos
2. O cliente informa data de check-in, check-out e número de hóspedes
3. O sistema busca os quartos disponíveis para o período informado
4. O sistema exibe a lista de quartos com fotos, descrição, capacidade, comodidades e valor da diária
5. O cliente seleciona um quarto para ver mais detalhes

**Fluxo Alternativo:**
- **FA01:** Nenhum quarto disponível → o sistema informa indisponibilidade para o período
- **FA02:** Número de hóspedes maior que a capacidade do quarto → o sistema não exibe o quarto na listagem

---

## UC04 — Realizar Reserva

**Ator:** Cliente  
**Pré-condição:** O cliente está autenticado e selecionou um quarto disponível.

**Fluxo Principal:**
1. O cliente seleciona o quarto desejado
2. O sistema exibe o resumo da reserva com valor total calculado
3. O cliente confirma a reserva
4. O sistema registra a reserva associada ao cliente no Firestore
5. O sistema atualiza o status do quarto para ocupado no período
6. O sistema exibe a tela de confirmação da reserva
7. O sistema informa que o pagamento será realizado presencialmente no check-in

**Fluxo Alternativo:**
- **FA01:** Quarto ocupado no período → o sistema informa indisponibilidade e sugere outros quartos
- **FA02:** Falha de conexão → o sistema informa o erro e solicita nova tentativa

---

## UC05 — Cancelar Reserva

**Ator:** Cliente  
**Pré-condição:** O cliente possui reserva ativa.

**Fluxo Principal:**
1. O cliente acessa a tela de suas reservas
2. O cliente seleciona a reserva que deseja cancelar
3. O sistema verifica a antecedência em relação à data de check-in
4. O sistema informa que o cancelamento é gratuito (mais de 48h de antecedência)
5. O cliente confirma o cancelamento
6. O sistema cancela a reserva e atualiza o status do quarto para disponível

**Fluxo Alternativo:**
- **FA01:** Cancelamento com menos de 48h de antecedência → o sistema informa a tarifa de cancelamento antes de confirmar
- **FA02:** Cliente desiste do cancelamento → o sistema retorna para a tela de reservas sem alterações

---

## UC06 — Confirmar Check-in

**Ator:** ADM  
**Pré-condição:** O ADM está autenticado e existe reserva ativa para o hóspede.

**Fluxo Principal:**
1. O ADM acessa o painel administrativo
2. O ADM busca o hóspede pelo CPF ou nome
3. O sistema exibe a reserva ativa vinculada ao hóspede
4. O ADM confirma o check-in
5. O sistema atualiza o status da reserva para EM ANDAMENTO

**Fluxo Alternativo:**
- **FA01:** Hóspede sem reserva ativa na data → o sistema informa que não há reserva vinculada ao CPF informado

---

## UC07 — Registrar Pagamento e Check-out

**Ator:** ADM  
**Pré-condição:** O ADM está autenticado e o hóspede possui reserva em andamento.

**Fluxo Principal:**
1. O ADM acessa o painel administrativo
2. O ADM localiza a reserva do hóspede
3. O ADM registra o pagamento presencial no sistema
4. O sistema atualiza o status da reserva para PAGO
5. O ADM confirma o check-out
6. O sistema atualiza o status do quarto para disponível

**Fluxo Alternativo:**
- **FA01:** Pagamento não registrado até as 12h do dia de check-out → o sistema sinaliza a reserva como PENDENTE FINANCEIRA

---

## UC08 — Gerenciar Quartos

**Ator:** ADM  
**Pré-condição:** O ADM está autenticado no sistema.

**Fluxo Principal:**
1. O ADM acessa a tela de gerenciamento de quartos
2. O sistema exibe a lista de quartos com seus status
3. O ADM pode realizar as seguintes ações:
   - Atualizar valor da diária
   - Alterar status do quarto (disponível/manutenção)
   - Editar informações do quarto

**Fluxo Alternativo:**
- **FA01:** Quarto com reserva ativa → o sistema impede alteração de status para disponível

---

## UC09 — Utilizar Chatbot

**Ator:** Cliente  
**Pré-condição:** O cliente está autenticado no sistema.

**Fluxo Principal:**
1. O cliente acessa a tela do chatbot
2. O cliente digita sua dúvida
3. O sistema envia a mensagem para a API (a definir)
4. O chatbot retorna a resposta em até 5 segundos
5. O cliente lê a resposta e pode continuar a conversa

**Fluxo Alternativo:**
- **FA01:** Dúvida fora do escopo do hotel → o chatbot sugere contato com um atendente humano
- **FA02:** Falha de conexão → o sistema informa que o chatbot está indisponível no momento