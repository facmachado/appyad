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


  // $('button:not([cmd])').on('keyup', e => {
  //   e.preventDefault();
  //   e.stopPropagation();
  // });

  // $('button:not([cmd])').on('mouseover', e => {
  //   e.preventDefault();
  //   e.stopPropagation();
  //   // $(e.target).focus().click();
  // });


  $('[cmd]').on('click', e => {
    e.preventDefault();
    e.stopPropagation();
    if ($(e.target).attr('cmd') !== '') {
      // $(document).blur();
      // location.replace
      console.log(`?cmd=${$(e.target).attr('cmd')}`);
    }
  });
});
