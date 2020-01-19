/* jshint esversion: 6 */

/* Desabilitar botão direito e arrastar */
document.oncontextmenu = function () {
  return false;
};
document.ondragstart = function () {
  return false;
};

/* Desabilitar botão voltar do navegador */
history.pushState(null, null, document.location.href);
window.onpopstate = function () {
  history.go(+1);
};

/* Executar os comandos em Shell Script dos links */
document.addEventListener('DOMContentLoaded', function() {
  this.querySelectorAll('a[href^="#"]').forEach(function(el) {
    el.addEventListener('click', function(e) {
      location.replace(`#${btoa(e.target.getAttribute('cmd'))}`, false);
    });
  });
});
