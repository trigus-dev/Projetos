
$("document").ready(function() {

  $("#mensagem").css("display", "none");
  setarMensagem("");

  $("a").click(function(e) {
    var vid = $(this).attr("id");
    if (!(vid == "btn1" || vid == "btn2" || vid == "btn3" || vid == "btn4" || vid == "col1" || vid == "col2" || vid == "col3" || vid == "col4")) return;
    e.preventDefault();
    var vurl = this.href;
    $.ajax({
      type: "GET",
      url: vurl,
      //data:  {
      //  ''opcao'': ''download'',
	    //  ''arquivo'': '' + href + '',
      //},
      success: function(data) {
        if (vid == "btn1") {
       
        } else 
        if (vid == "btn2") {
          setarStatus(data);
        } else 
        if (vid == "btn3") {
          setarDados(data);
        } else 
        if (vid == "btn4") {
          setarDados(data);
        } else
        if (vid == "col1") {
          setarMensagem(data);
        } else 
        if (vid == "col2" || vid == "col3" || vid == "col4") {
          setarDados(data);
        }
      },
      error: function(data) {
        setarMensagem("<strong>Erro!</strong> " + data);
      }
    });
  });

  function setarStatus(status) {
    setarMensagem("");
    if (status == "OK") {
      $("#btn2").attr("data-tooltip", "Desativar o Servidor");
      $("#btn2 span").text("Desativar");
    } else {
      $("#btn2").attr("data-tooltip", "Ativar o Servidor");
      $("#btn2 span").text("Ativar");
    }
  }
    
  function setarMensagem(msg) {
    var list = document.querySelector(".avisos").classList;
    var show = list.contains('show');

    if (msg == "") {
      $(".bt-info").css("background", "url('../imagens/confirm.png') no-repeat center");
      $("#status").css("display", "none");
      if(!show) { list.add('show'); }    
    } else {
      if(show){
        //$("#col1").attr("data-tooltip", "Desabilitar Informações do Servidor");
        $(".bt-info").css("background", "url('../imagens/cancel.png') no-repeat center");
        $("#status").css("display", "block");
        $(".avisos").html(msg)
        list.remove('show');
      } else {
        //$("#col1").attr("data-tooltip", "Habilitar Informações do Servidor");
        $(".bt-info").css("background", "url('../imagens/confirm.png') no-repeat center");
        $("#status").css("display", "none");
        list.add('show');
      }    
    }
  }

  function setarDados(dados) {
    setarMensagem("");
    $("#corpo").html(dados);
  }

});
