# Requisitos Não Funcionais — Barra Hotel App

## 1. Desempenho

RNF01 — O sistema deve responder à tentativa de login em até 3 segundos
em condições normais de rede.

RNF02 — O sistema deve concluir o processo de criação de reserva
em até 4 segundos em condições normais de rede.

RNF03 — O chatbot deve retornar uma resposta em até 5 segundos
após o envio da mensagem pelo usuário.

## 2. Segurança

RNF04 — As senhas dos usuários devem ser gerenciadas pelo
Firebase Authentication, garantindo armazenamento seguro
sem exposição em texto puro.

RNF05 — O sistema deve diferenciar as permissões de acesso
entre perfil Cliente e perfil ADM.

## 3. Disponibilidade e Confiabilidade

RNF06 — O sistema deve utilizar o Firebase Firestore como
banco de dados, garantindo sincronização em tempo real
entre os dispositivos.

RNF07 — O sistema deve realizar backup automático dos dados
através do Firebase, com retenção gerenciada pela plataforma.

RNF08 — O sistema deve informar ao usuário em caso de falha
de conexão com a internet, impedindo ações que dependam de rede.

## 4. Usabilidade

RNF09 — O sistema deve ter interface intuitiva e responsiva,
adaptada para dispositivos móveis Android e IOS.

RNF10 — O sistema deve fornecer feedback visual ao usuário
em todas as ações que envolvam carregamento ou processamento
(ex: indicadores de loading).

RNF11 — O sistema deve ser desenvolvido em português brasileiro.

## 5. Compatibilidade

RNF12 — O sistema deve ser compatível com dispositivos
Android a partir da versão 8.0 (API 26) e iOS a partir
da versão 14.0.

RNF13 — O sistema deve ser desenvolvido em Flutter, garantindo
base de código única para futuras expansões de plataforma.

## 6. Manutenibilidade

RNF14 — O código deve seguir a arquitetura MVVM adotada
pelo projeto, separando responsabilidades entre Models,
ViewModels e Views.

RNF15 — O repositório deve seguir o fluxo de branches
definido (feature → develop → main), com histórico de
commits documentado.
