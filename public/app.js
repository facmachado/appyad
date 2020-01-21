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

/* Executar os comandos a partir dos elementos */
document.addEventListener('DOMContentLoaded', function() {
  this.querySelectorAll('[cmd]').forEach(function(el) {
    el.addEventListener('click', function(e) {
      document.querySelectorAll('fieldset').forEach(function(el) {
        el.disabled = true;
      });
      location.replace(`#${btoa(e.target.getAttribute('cmd'))}`);
    });
  });

  document.body.onfocus = function() {
    document.querySelectorAll('fieldset').forEach(function(el) {
      el.disabled = false;
    });
  };
});
