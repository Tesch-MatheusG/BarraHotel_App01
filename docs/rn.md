# Regras de Negócio — Barra Hotel App

## 1. Autenticação

RN01 — O sistema deve bloquear a conta do usuário por 15 minutos
após 5 tentativas consecutivas de login com senha inválida.

## 2. Reservas

RN02 — O sistema não permitirá reservas em períodos já ocupados
para o mesmo quarto.

RN03 — O sistema não permitirá registrar número de hóspedes
superior à capacidade máxima do quarto selecionado.

RN04 — Uma reserva será considerada confirmada no momento
em que o cliente a realizar pelo app, independente do pagamento,
que será efetuado presencialmente no check-in ou check-out.

RN05 — O sistema trabalhará exclusivamente com tarifa net,
não sendo aplicadas tarifas comissionadas para agências
ou intermediários.

## 3. Cancelamento

RN06 — O cancelamento da reserva será gratuito se realizado
com antecedência mínima de 48 horas da data de check-in.

RN07 — Cancelamentos realizados com menos de 48 horas de
antecedência estarão sujeitos a uma tarifa de cancelamento
definida pelo hotel.

## 4. Check-in e Check-out

RN08 — O check-in só será permitido se existir reserva ativa
vinculada ao CPF do hóspede na data atual.

RN09 — Se o pagamento presencial não for registrado pelo ADM
até o horário limite de check-out (12h), o sistema deverá
sinalizar a reserva como pendente financeira.

## 5. Pagamento

RN10 — O pagamento será realizado presencialmente no momento
do check-in.

RN11 — O ADM deve registrar o pagamento no sistema,
alterando o status da reserva para PAGO após a confirmação
do pagamento presencial.