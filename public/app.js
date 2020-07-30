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
    $(document.body).addClass('disabled');
  });

  $(window).on('click', _ => {
    if ($('.menu').is(':visible') && !$('.menu button').is(':focus')) {
      $('.menu:not(.top)').hide();
    }
  });

  $(window).on('focus', _ => {
    $(document.body).removeClass('disabled');
    $('.nav').prop('disabled', false);
  });

  $('button:not([cmd])').on('keyup', e => {
    e.preventDefault();
    e.stopPropagation();
    $(e.target).click();
  });

  $('button:not([cmd])').on('mouseover', e => {
    e.preventDefault();
    e.stopPropagation();
    $(e.target).focus().click();
  });

  $('.menu.top button').on('click', e => {
    $('.menu:not(.top)').hide();
    $(e.target).next().show();
  });

  $('.nav').on('blur', _ => {
    $('.menu:not(.top)').hide();
  });

  $('[cmd]').on('click', e => {
    e.preventDefault();
    if ($(e.target).attr('cmd') !== '') {
      $(document).blur();
      location.replace(`?cmd=${$(e.target).attr('cmd')}`, false);
    }
  });
});
