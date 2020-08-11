/* jshint esversion: 8 */

// document.oncontextmenu = _ => false;
document.ondragstart = _ => false;

history.pushState(null, null, document.location.href);
window.onpopstate = _ => history.go(+1);


/* jQuery onshow e onhide */
($ => $.each(['show', 'hide'], (i, e) => {
  let el = $.fn[e];
  $.fn[e] = function() {
    this.trigger(e);
    return el.apply(this, arguments);
  };
}))(jQuery);


function win_login() {
  $('#winLogin')
    .dialog({
      title: 'Entre com seus dados',
      width: 280,
      buttons: {
        Limpar: function() {
          $('input[type!="hidden"]').val('');
          $('.lerror').text('');
          $('#txUser').select();
        },
        Entrar: function() {
          $.post('php/auth.php?action=login', {
            h0: hex_sha1($('#txUser').val()),
            h1: hex_sha1($('#txPass').val())
          }, function(result, status) {
            if ((status == 'success' || status == 'notmodified') && result == '1') {
              $('.lerror').text('Aguarde...');
              document.location.reload(true);
            } else {
              $('.lerror').text('Falha na autenticação');
              setTimeout("$('.lerror').text('')", 2000);
            }
            $('input[type!="hidden"]').val('');
            $('#txUser').select();
          });
        }
      },
      open: function() {
        setTimeout("$('#txUser').select()", 500);
      },
      draggable: false,
      resizable: false,
      closeOnEscape: false
    })
    .keypress(function(e) {
      if (e.keyCode == $.ui.keyCode.ENTER)
        $(this).parent().find('button:eq(2)').trigger('click');
    });
}


function doChgPass() {
    $('#winChgPass')
        .dialog({
            modal: true,
            title: 'Alterar senha',
            buttons: {
                Alterar: function() {
                    $.post('php/auth.php?action=change',{
                        h1: hex_sha1($('#txPassOld').val()),
                        h2: hex_sha1($('#txPassOne').val()),
                        h3: hex_sha1($('#txPassTwo').val())
                    },function(result,status) {
                        if ((status=='success' || status=='notmodified') && result=='1')
                            $('.lerror').text('Senha alterada');
                        else
                            $('.lerror').text('Falha na alteração');
                        $('input[type!="hidden"]').val('');
                        $('#txPassOld').select();
                        setTimeout("$('.lerror').text('')",2000);
                    });
                },
                Limpar: function() {
                    $('input[type!="hidden"]').val('');
                    $('#txPassOld').select();
                    $('.lerror').text('');
                },
                Sair: function() { $(this).dialog('close'); }
            },
            close: function() {
                $('input[type!="hidden"]').val('');
                $('.lerror').text('');
            },
            open: function() { setTimeout("$('#txPassOld').select()",500); },
            draggable: false, resizable: false,
            closeOnEscape: true
        })
        .keypress(function(e) {
            if (e.keyCode==$.ui.keyCode.ENTER)
                $(this).parent().find('button:eq(1)').trigger('click');
        });
}


function doGridCadCli(){
    $('#winGridCadCli').dialog({
        title: 'Cadastro de Clientes', width: 600, height: 400,
        modal: true,
        closeOnEscape: false,
        draggable: false, resizable: false,
        open: function() {
            /* Agora, a grid com as configurações do jqGrid */
            $('#gridCadCli')
                .jqGrid({
                    //url: url, datatype: 'json',
                    sortname: 'id', sortorder: 'asc',
                    //colNames: names, colModel: model,
                    height: 244, pager: '#pagerCadCli', pagerpos: 'center',
                    rowNum: 10, rowList: [5,10,15,20]
                })
                .jqGrid('navGrid','#pagerCadCli',{
                    add: false, edit: false, del: false,
                    search: false, refresh: false
                })
                .jqGrid('setGridWidth',574,true);
        },
        close: function() {
            $('input[type!="hidden"],textarea[id!="txLicense"]').val('');
            $('.butGrid').unbind('click');
        },
        buttons: {
            Novo:function(){
                doFormCadCli();
            },
            Atualizar:function(){},
            Sair:function(){
                $(this).dialog('close');
            }
        }
    });
    /*
     * Localizando registros com base na palavra-chave digitada no input
     * #search. Ao terminar de digitar, aguarda-se um segundo para fazer
     * a consulta no Banco de Dados
        $('#search')
            .click(function(){$(srch).select()})
            .data('timeout',null)
            .keyup(function(e) {
                if (e.keyCode!==9) {
                    if (e.keyCode===27) $(srch).val('');
                    clearTimeout($(srch).data('timeout'));
                    $(srch).data('timeout',setTimeout(function(){
                        if ($(srch).val()!=='') query();
                    },1000));
                }
            });
        setTimeout('$("#search").focus()',100);
     */
}


function doFormCadCli() {
    var estados = ['AC','AL','AM','AP','BA','CE','DF','ES','GO','MA',
                   'MG','MS','MT','PA','PB','PE','PI','PR','RJ','RN',
                   'RO','RR','RS','SC','SE','SP','TO'];
    $('#winFormCadCli').dialog({
        title: 'Dados do Cliente',
        width: 590, height: 410, modal: true,
        draggable: false, resizable: false,
        closeOnEscape: false,
        close: function(){
            $('input[type!="hidden"],textarea[id!="txLicense"]').val('');
            $('.butForm').unbind('click');
        },
        buttons: {
            Salvar: function() {},
            Cancelar: function(){
                $(this).dialog('close');
            }
        }
    });
    $('#tabsCadCli').tabs({ active: 0, heightStyle: 'fill' });
    $('#cbTipoCli').change(function() {
        switch($('#cbTipoCli').val()) {
            case '1':
                $('.estciv').show();
                $('#butGetCnpjCli').hide();
                $('#lbCnpjCli').text('CPF');
                $('#lbRgEstCli').text('RG');
                $('#lbNomeCli').text('Nome');
                $('#lbApelCli').text('Apelido');
                $('#lbAtivCli').text('Profissão');
                $('#lbNascCli').text('Data Nascimento');
                break;
            default:
                $('#lbRgEstCli').text('Inscr. Estadual');
                $('#lbNomeCli').text('Razão Social');
                $('#lbApelCli').text('Nome Fantasia');
                $('#lbNascCli').text('Data Abertura');
                $('#lbAtivCli').text('Atividade');
                $('#lbCnpjCli').text('CNPJ');
                $('#butGetCnpjCli').show();
                $('.estciv').hide();
                break;
        }
    });
    $('#butGetCnpjCli').click(function() {
        if($('#txCnpjCli').val()) {

        }
        $('#txCnpjCli').select();
    });
    $('#butGetAddrCli').click(function(){
        var url = 'http://cep.correiocontrol.com.br/'+$('#txCepCli').val()+'.json';
        if($('#txCepCli').val()) {
            $.ajax({
                url: url,
                success: function(json) {
                    $('#txCepCli').val(json.cep);
                    $('#txLogrCli').val(json.logradouro);
                    $('#txBairCli').val(json.bairro);
                    $('#txCidCli').val(json.localidade);
                    $('#txUfCli').val(json.uf);
                }
            });
        }
        $('#txCepCli').select();
    });
    $('#butFindCepCli').click(function() {
        var url = 'http://www.buscacep.correios.com.br/servicos/dnec/menuActio'+
                  'n.do?Metodo=menuLogradouro';
        window.open(url,'_blank');
    });
    $('#txUfCli').autocomplete({
        source: estados,
        appendTo: 'body'
    });
    $('#butNewMailCli').click(function() {
        window.open('mailto:'+$('#txEmailCli').val(),'_blank');
    });
    $('#butGoWebCli').click(function() {
        var url = !/^(f|ht)tps?:\/\//i.test($('#txWebCli').val())
                ? 'http://'+$('#txWebCli').val()
                : $('#txWebCli').val();
        window.open(url,'_blank');
    });
}


function doGridCadProd() {
    $('#winGridCadProd').dialog({
        title: 'Cadastro de Produtos', width: 600, height: 400,
        modal: true,
        closeOnEscape: false,
        draggable: false, resizable: false,
        open: function() {
            /* Agora, a grid com as configurações do jqGrid */
            $('#gridCadProd')
                .jqGrid({
                    //url: url, datatype: 'json',
                    sortname: 'id', sortorder: 'asc',
                    //colNames: names, colModel: model,
                    height: 244, pager: '#pagerCadProd', pagerpos: 'center',
                    rowNum: 10, rowList: [5,10,15,20]
                })
                .jqGrid('navGrid','#pagerCadProd',{
                    add: false, edit: false, del: false,
                    search: false, refresh: false
                })
                .jqGrid('setGridWidth',574,true);
        },
        close: function() {
            $('input[type!="hidden"],textarea[id!="txLicense"]').val('');
            $('.butGrid').unbind('click');
        },
        buttons: {
            Novo: function() {doFormCadProd()},
            Atualizar:function() {},
            Sair:function() {$(this).dialog('close')}
        }
    });
    /*
     * Localizando registros com base na palavra-chave digitada no input
     * #search. Ao terminar de digitar, aguarda-se um segundo para fazer
     * a consulta no Banco de Dados
        $('#search')
            .click(function(){$(srch).select()})
            .data('timeout',null)
            .keyup(function(e) {
                if (e.keyCode!==9) {
                    if (e.keyCode===27) $(srch).val('');
                    clearTimeout($(srch).data('timeout'));
                    $(srch).data('timeout',setTimeout(function(){
                        if ($(srch).val()!=='') query();
                    },1000));
                }
            });
        setTimeout('$("#search").focus()',100);
     */
}


function doGridLog() {
    $('#winGridLog').dialog({
        title: 'Log do Sistema', width: 600, height: 400,
        modal: true,
        closeOnEscape: false,
        draggable: false, resizable: false,
        open: function() {
            $('#gridLog')
                .jqGrid({
                    //url: url, datatype: 'json',
                    sortname: 'id', sortorder: 'asc',
                    //colNames: names, colModel: model,
                    height: 244, pager: '#pagerLog', pagerpos: 'center',
                    rowNum: 10, rowList: [5,10,15,20]
                })
                .jqGrid('navGrid','#pagerLog',{
                    add: false, edit: false, del: false,
                    search: false, refresh: false
                })
                .jqGrid('setGridWidth',574,true);
        },
        close: function() {
            $('input[type!="hidden"],textarea[id!="txLicense"]').val('');
            $('.butGrid').unbind('click');
        },
        buttons: {Sair: function() {$(this).dialog('close')}}
    });
    /*
     * Localizando registros com base na palavra-chave digitada no input
     * #search. Ao terminar de digitar, aguarda-se um segundo para fazer
     * a consulta no Banco de Dados
        $('#search')
            .click(function(){$(srch).select()})
            .data('timeout',null)
            .keyup(function(e) {
                if (e.keyCode!==9) {
                    if (e.keyCode===27) $(srch).val('');
                    clearTimeout($(srch).data('timeout'));
                    $(srch).data('timeout',setTimeout(function(){
                        if ($(srch).val()!=='') query();
                    },1000));
                }
            });
        setTimeout('$("#search").focus()',100);
     */
}


function doHelpAbout() {
    $('#winHelpAbout').dialog({
        title: 'Sobre o OpenHouse',
        width: 562, height: 376, modal: true,
        draggable: false, resizable: false,
        closeOnEscape: true,
        buttons: {OK: function() {$(this).dialog('close')}}
    });
    $('#tabsAbout').tabs({ active: 0, heightStyle: 'fill' });
    $('#txLicense').load('../LICENSE');
    $('#callBitCoin').click(function() {
        $('#winHelpAboutBitcoin').dialog({
            title: 'Copie o endereço e cole em sua carteira',
            width: 350, modal: true,
            closeOnEscape: true,
            draggable: false, resizable: false,
            buttons: {OK: function() {$(this).dialog('close')}}
        });
        $('#butBitAddr').click(function() {
            window.open('bitcoin:1F3oCMXpi11aAWsaRVriR1qtau7W72QQB','_blank');
        });
        $('#txBitAddr')
            .val('1F3oCMXpi11aAWsaRVriR1qtau7W72QQB')
            .focus()
            .select();
    });
    $('#callPayPal').click(function() {$('#formPayPal').submit()});
}



/* ---- Display/Replace toast messages ---- */

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



$(_ => {
  $(window).on({
    blur: _ => $('body').prop('disabled', true),
    focus: _ => $('body').prop('disabled', false),
    click: e => {
      if (!$('.menubar *').is(e.target))
        $('ul.level1').hide();
    }
  });


  $('ul.level0 button').on({
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


  $('ul.level1 button').on({
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
