#!/bin/bash

#
# Sobre
#
function win_about() {
  $yad --gtkrc="public/style.css" --title='Sobre'  \
    --on-top --center --fixed --skip-taskbar     \
    --close-on-unfocus --borders=20              \
    --text-align=center                          \
    --text='Uma vitória a cada passo\n'          \
    --buttons-layout=center --button=yad-ok
}

#
# Caixa de alteração de senha de usuário
#
function win_chpwd() {
  $yad --gtkrc="public/style.css" --title='Alterar senha'  \
    --on-top --center --fixed --skip-taskbar             \
    --close-on-unfocus --borders=10                      \
    --form --align=right                                 \
    --field='Senha atual:H'                              \
    --field='Nova senha:H'                               \
    --field='Confirmar:H'                                \
    --buttons-layout=center
}

#
# Formulário genérico
#
function win_form() {
  :
}

#
# Caixa de logon de usuário
#
function win_logon() {
  $yad --gtkrc="public/style.css" --title='Logon'  \
    --on-top --center --fixed --skip-taskbar     \
    --borders=10 --form --align=right            \
    --field='Usuário'                            \
    --field='Senha:H'                            \
    --buttons-layout=center
}

#
# Menu principal
#
function win_main() {
  while :; do
    if IFS= read -r line; then
      $(cut -d# -f2 <<<$line | base64 -dw0)
    fi
  done < <(
    $yad --width=640 --height=480 --maximized  \
      --no-buttons --no-escape --borders=0     \
      --html --browser --uri-handler=echo      \
      --uri="public/index.html"
    echo 'ZG9fZXhpdA==' # do_exit
  )
}

#
# Menu genérico
#
function win_menu() {
  $yad --gtkrc="public/style.css" --width=220 --height=220  \
    --title="$1" --skip-taskbar --on-top --center         \
    --fixed --borders=10 --buttons-layout=center          \
    --list --no-headers --column=OPTION "${2:*}"
}

#
# Caixa de mensagens genérica
#
function win_msgbox() {
  :
}

#
# Relatório genérico
#
function win_report() {
  :
}

#
# Caixa de leitura de código de barras ou QR
#
function win_scancode() {
  $yad --gtkrc="public/style.css" --width=500   \
    --title='Passe o cartão pela leitora'     \
    --on-top --center --fixed --skip-taskbar  \
    --borders=12 --entry --hide-text          \
    --no-buttons
}

#
# Tabela genérica
#
function win_table() {
  :
}
