$(document).ready(function($) {

  if ($("#datepicker").val() != null) {
    var fecha = $("#datepicker").val().split("-")[0];

    if (fecha.length == 4){      
       $("#datepicker").val($("#datepicker").val().split("-")[2]+"-"+$("#datepicker").val().split("-")[1]+"-"+$("#datepicker").val().split("-")[0]);
    } 
  }   

  if ($("#datepicker3").val() != null) {
    var fecha3 = $("#datepicker3").val().split("-")[0];
    
    if (fecha3.length == 4){
       $("#datepicker3").val($("#datepicker3").val().split("-")[2]+"-"+$("#datepicker3").val().split("-")[1]+"-"+$("#datepicker3").val().split("-")[0]);
    }
  }   

  $(".solo_numerico").on("keypress keyup blur",function (event) {    
     $(this).val($(this).val().replace(/[^\d].+/, ""));
     if ( event.which == 8) {
         
     }else{
      if (event.which < 48 || event.which > 57) {
                event.preventDefault();
      }
    }
          
  });

  $("#input_cuil").on("keypress keyup blur",function (event) {    
     if (( event.which == 8 ) || ( event.which == 45)) {
         
     }else{
      if (event.which < 48 || event.which > 57) {
                event.preventDefault();
           }
    }
          
  });

  $("#input_cuil").blur(function(){
     var cuil = $("#input_cuil");
     validarCUIT(cuil);
     
  });
  $('#modal_altas').on('shown.bs.modal', function (event) {      
    var alta_id = $(event.relatedTarget).attr('alta-id');
    $.ajax({
        url: '/soft/snpe/util/buscar_estados_altas_bajas_hora/'+alta_id,
        type: 'POST',
      })
      .done(function(data) {
        if (data != null) {
          for (var i = data.length - 1; i >= 0; i--) {
            if (i == data.length - 1){
              $("#historial").append(data[i]);
            }else{
              var datos = data[i];
              var respuesta = datos.replace('<tr class="limpiable">', '<tr class="ocultable limpiable">');
              $("#historial").append(respuesta);
              $(".ocultable").hide();
            }
          };
          
        }
        else{
        
        }
      })
  });

  $("#boton_ocultar_historial").hide();    

  $("#boton_ocultar_historial").click(function(){
    $(".ocultable").hide();
    $("#boton_ocultar_historial").hide();
    $("#boton_mostrar_historial").show();
  });

  $("#boton_mostrar_historial").click(function(){
    $(".ocultable").show();
    $("#boton_mostrar_historial").hide();
    $("#boton_ocultar_historial").show();
  });

  //acá limpiamos el modal cada vez que se cierra
  $('#modal_altas').on('hidden.bs.modal', function () {
    $(".limpiable").remove();
    $("#boton_ocultar_historial").hide();
    $("#boton_mostrar_historial").show();
  });

  $("#cerrar_modal_altas").click(function(){
    $(".limpiable").remove();
  });

});

function validarCUIT (expresion) {
  if ((/^\d{2}\d{8}\d{1}$/).test(expresion.val())){
  }else{
    alert('cuil incorrecto')
  }
}