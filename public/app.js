/* jshint esversion: 8 */

/**
 *  Copyright (c) 2020 Flavio Augusto (@facmachado)
 *
 *  This software may be modified and distributed under the terms
 *  of the MIT license. See the LICENSE file for details.
 */


// document.oncontextmenu = _ => false;
document.ondragstart = _ => false;

history.pushState(null, null, document.location.href);
window.onpopstate = _ => history.go(+1);


/* Web worker to interact with CGI */
var worker = new Worker('worker.js');


/* jQuery onshow e onhide */
($ => $.each(['show', 'hide'], (i, e) => {
  let el = $.fn[e];
  $.fn[e] = function() {
    this.trigger(e);
    return el.apply(this, arguments);
  };
}))(jQuery);

/* Disable $.ajax in favor of fetch and worker */
// $.ajax = $.get = $.post = false;


/* Display/Replace toast messages */
function toast(msg, type = 'default') {
  let el = $('.toast'),
    cb = _ => el.hide()
      .text(null)
      .removeClass('t-danger t-default t-error t-info t-success t-warning'),
    t = setTimeout(_ => cb(), 10000);
  cb();
  el.addClass(`t-${type}`)
    .text(msg)
    .show()
    .click(_ => cb())
    .on('show', _ => clearTimeout(t));
}


/* Menu bar */
function menubar() {
  let msrc = $('.footer #menubar'),
    menu = $('body .menubar');

  menu.html(msrc.html());

  menu.find('ul.level0 button').on({
    click: e => $(e.target).next().toggle(),
    'focusin mouseenter': e => {
      if ($('ul.level1').is(':visible') &&
        !$('ul.level1 button').is(e.target)) {
        $('ul.level1').hide();
        $(e.target).next().show();
      }
    },
    keyup: e => {
      switch (e.which) {
        case 0xa:
        case 0x1b:
          $('ul.level1').hide();
          $('ul.level0 button').first().focus();
          break;
      }
    }
  });

  menu.find('ul.level1 button').on({
    click: e => {
      $('ul.level1').hide();
      $(e.target).blur();
    },
    keyup: e => {
      switch (e.which) {
        case 0xa:
        case 0x1b:
        case 0x20:
          $('ul.level1').hide();
          $('ul.level0 button').first().focus();
          break;
      }
    }
  });
}


/* main() */
$(_ => {
  $(window).on({
    blur: _ => $('body').prop('disabled', true),
    focus: _ => $('body').prop('disabled', false),
    click: e => {
      if (!$('.menubar *').is(e.target))
        $('ul.level1').hide();
    }
  });

  worker.addEventListener('message', e => console.log(JSON.parse(e.data)), false);

  menubar();

  $('[cmd]').on({
    click: e => {
      e.preventDefault();
      e.stopPropagation();
      if ($(e.target).attr('cmd') !== '') {
        toast($(e.target).attr('cmd'), 'error');
      }
    }
  });
});
