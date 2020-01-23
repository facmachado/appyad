/* jshint esversion: 8 */

/* Desabilitar botão direito e arrastar */
document.oncontextmenu = _ => false;
document.ondragstart = _ => false;

/* Desabilitar botão voltar do navegador */
history.pushState(null, null, document.location.href);
window.onpopstate = _ => history.go(+1);

/* Funções de foco e desfoco */
function do_focus() {
  document.body.classList.remove('disabled');
  document
    .querySelectorAll('fieldset')
    .forEach(e0 => e0.disabled = false);
}
function do_blur() {
  document.body.classList.add('disabled');
  document
    .querySelectorAll('fieldset')
    .forEach(e1 => e1.disabled = true);
}

/* Executar os comandos a partir dos elementos */
document.addEventListener('DOMContentLoaded', _ => {
  document.querySelectorAll('[cmd]').forEach(e0 => {
    e0.addEventListener('click', e => {
      do_blur();
      location.replace(`#${btoa(e.target.getAttribute('cmd'))}`);
    });
  });

  /* Foco */
  document.body.onfocus = _ => do_focus();

  /* Desfoco */
  document.body.onblur = _ => do_blur();
});
