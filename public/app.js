/* jshint esversion: 8 */

document.oncontextmenu = _ => false;
document.ondragstart = _ => false;

history.pushState(null, null, document.location.href);
window.onpopstate = _ => history.go(+1);

$(_ => {
  $(window).on({
    blur:  _ => $('body').prop('disabled', true),
    click: _ => {},
    focus: _ => $('body').prop('disabled', false)
  });


  $('ul.level0 button').on({
    click: e => {
      $('ul.level0 button').next().hide();
      $(e.target).next().show();
    }
  });


  $('[cmd]').on('click', e => {
    e.preventDefault();
    e.stopPropagation();
    if ($(e.target).attr('cmd') !== '') {
      // $(window).blur();
      location.replace(`#${btoa($(e.target).attr('cmd'))}`);
    }
    alert(location.search.split('#')[1]);
  });
});
