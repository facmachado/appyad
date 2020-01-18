#!/bin/bash

#
# Sobre
#
function win_about() {
  yad --center --on-top --fixed --skip-taskbar --undecorated  \
    --close-on-unfocus --borders=20 --gtkrc=public/style.css  \
    --buttons-layout=center --no-buttons                      \
    --text-align=center --text='Uma vitória a cada passo'
}

#
# Caixa de alteração de senha de usuário
#
function win_chpwd() {
  yad --title='Alterar senha'                 \
    --on-top --center --fixed --skip-taskbar  \
    --borders=5 --buttons-layout=center       \
    --form --align=right                      \
    --field='Senha atual:H'                   \
    --field='Nova senha:H'                    \
    --field='Confirmar:H'                     \
    --separator=: | sed 's/:$//'
}

#
# Formulário genérico
#
function win_form() {
  echo
}

#
# Caixa de logon de usuário
#
function win_logon() {
  yad --title='Logon - Tecle ENTER'           \
    --on-top --center --fixed --skip-taskbar  \
    --borders=5 --buttons-layout=center --gtkrc=public/style.css       \
    --form --align=right                      \
    --field='Usuário'                         \
    --field='Senha:H'                         \
    --separator=, --quoted-output | tr "'" '"' | sed 's/,$//'
}

#
# Menu principal
#
function win_main() {
  yad --center --maximized --borders=0 --no-buttons  \
    --html --browser --uri-handler=echo              \
    --uri=public/index.html 2>/dev/null |            \
  while read -r line; do
    cmd=$(cut -d# -f2 <<<"$line" | base64 -dw0)
    $cmd "$@"
  done
}

#
# Menu genérico
#
function win_menu() {
  yad --title='Escolha a opção desejada'   \
    --on-top --center --fixed --skip-taskbar  \
    --width=220 --height=220 --borders=10 --no-buttons     \
    --list --no-headers --column=OPTION 'Cadastros' 'Movimentos' 'Consultas' 'Relatórios' 'Configurações' 'Alterar senha' 'Sobre' 'Finalizar'
}

#
# Caixa de mensagens genérica
#
function win_msgbox() {
  echo
}

#
# Relatório genérico
#
function win_report() {
  echo
}

#
# Caixa de leitura de código de barras ou QR
#
function win_scancode() {
  yad --title='Passe o cartão pela leitora'   \
    --on-top --center --fixed --skip-taskbar  \
    --width=500 --borders=10 --no-buttons     \
    --entry --hide-text
}

#
# Tabela genérica
#
function win_table() {
  echo
}
