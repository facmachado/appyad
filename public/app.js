/* jshint esversion: 8 */

/* Desabilitar botão direito e arrastar */
document.oncontextmenu = _ => false;
document.ondragstart = _ => false;

/* Desabilitar botão voltar do navegador */
history.pushState(null, null, document.location.href);
window.onpopstate = _ => history.go(+1);

$(_ => {

  $(window).on('blur', _ => {
    $('.menu:not(.top)').hide();
    $('.nav').prop('disabled', true);
  });

  $(window).on('focus', _ => {
    $('.nav').prop('disabled', false);
  });

  $('button:not([cmd])').on('keyup', e => {
    e.preventDefault();
    e.stopPropagation();
    $(e.target).click();
  });

  $('.menu:not(.top)').on('blur', e => {
    $(e.target).hide();
  });

  $('.nav').on('blur', _ => {
    $('.menu:not(.top)').hide();
  });

  $('.menu.top button').on('click', e => {
    $('.menu:not(.top)').hide();
    $(e.target).next().show();
  });

  $('[cmd]').on('click', e => {
    if ($(e.target).attr('cmd') !== '') {
      $(document).blur();
      location.replace(`#${btoa($(e.target).attr('cmd'))}`);
    }
  });

});

/*
Funções de foco e desfoco
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

Executar os comandos a partir dos elementos
document.addEventListener('DOMContentLoaded', _ => {
  document.querySelectorAll('.menu button').forEach(e0 => {
    e0.addEventListener('click', e => {
      let el = e.target.parentNode.querySelector('.menu');
      el.style.display = 'inline-flexbox';
      console.log(el);
    });
  });

  document.querySelectorAll('[cmd]').forEach(e0 => {
    e0.addEventListener('click', e => {
      do_blur();
      location.replace(`#${btoa(e.target.getAttribute('cmd'))}`);
    });
  });

  Foco
  document.body.onfocus = _ => do_focus();

  Desfoco
  document.body.onblur = _ => do_blur();
});
*/
