#!/bin/bash

#
# Sobre
#
function win_about() {
  yad --gtkrc="$GTKRC" --title='Sobre'        \
    --on-top --center --fixed --skip-taskbar  \
    --close-on-unfocus --borders=20           \
    --text-align=center                       \
    --text='Uma vitória a cada passo\n'       \
    --buttons-layout=center --button=yad-ok
}

#
# Caixa de alteração de senha de usuário
#
function win_chpwd() {
  yad --gtkrc="$GTKRC" --title='Alterar senha'  \
    --on-top --center --fixed --skip-taskbar    \
    --close-on-unfocus --borders=10             \
    --form --align=right                        \
    --field='Senha atual:H'                     \
    --field='Nova senha:H'                      \
    --field='Confirmar:H'                       \
    --buttons-layout=center
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
  yad --gtkrc="$GTKRC" --title='Logon'        \
    --on-top --center --fixed --skip-taskbar  \
    --borders=10 --form --align=right         \
    --field='Usuário'                         \
    --field='Senha:H'                         \
    --buttons-layout=center
}

#
# Menu principal
#
function win_main() {
  while :; do
    if read -r line 2>/dev/null; then
      cmd=$(cut -d# -f2 <<<"$line" | base64 -dw0)
      $cmd
    fi
  done < <(yad --gtkrc="$GTKRC" --maximized  \
    --width=360 --height=493 --borders=0     \
    --html --browser --uri-handler=echo      \
    --uri="$INDEX" --no-buttons --no-escape)
}

#
# Menu genérico
#
function win_menu() {
  yad --gtkrc="$GTKRC" --width=220 --height=220 --title="$1"  \
    --on-top --center --fixed --skip-taskbar --borders=10     \
    --list --no-headers --column=OPTION "${2:*}"              \
    --buttons-layout=center
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
  yad --gtkrc="$GTKRC" --width=500            \
    --title='Passe o cartão pela leitora'     \
    --on-top --center --fixed --skip-taskbar  \
    --borders=12 --entry --hide-text          \
    --no-buttons
}

#
# Tabela genérica
#
function win_table() {
  echo
}
