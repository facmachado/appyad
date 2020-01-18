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

function sendcmd(el) {
  location.replace(`#${btoa(el.getAttribute('cmd'))}`);
}
