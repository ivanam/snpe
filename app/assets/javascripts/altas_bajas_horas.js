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

  if ($("#datepicker4").val() != null) {
    var fecha4 = $("#datepicker4").val().split("-")[0];
    
    if (fecha4.length == 4){
       $("#datepicker4").val($("#datepicker4").val().split("-")[2]+"-"+$("#datepicker4").val().split("-")[1]+"-"+$("#datepicker4").val().split("-")[0]);
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
     var dni = $("#input_dni");
     /*validarCUIT(cuil,dni);     */
  });

   $("#input_dni").bind("propertychange change click keyup input paste",function(){
      var elem = $(this);
      elem.data('oldVal', elem.val());
      if (elem.data('oldVal') != elem.val()) {alert("cambio");}
       var dni = parseInt($("#input_dni").val(),10);
       if (!Number.isNaN(dni)) //Verifico que se haya ingresaod un dni 
       { 
         $("#datos_persona").show();
          $.ajax({
            url: '/soft/snpe/util/buscar_persona/'+dni,
            type: 'POST',
          })
          .done(function(data) {
            if (data != null) {
              /*$("#input_nombres").val(data.nombres); */ //Comentar para no repetir apellido y nombre al buscar y guardar
              $("#input_apellidos").val(data.apeynom);
              $("#input_cuil").val(data.cuil);
              $("#datepicker3").val(data.fecha_nacimiento.split("-")[2]+"-"+data.fecha_nacimiento.split("-")[1]+"-"+data.fecha_nacimiento.split("-")[0]);
              $("#select_tipo_documento").val(data.tipo_documento_id);
            }
            else{
              //alert("La persona no existe. Por favor cargue sus datos");
              $("#input_nombres").val("");
              $("#input_apellidos").val("");
              $("#input_cuil").val("");
              $("#datepicker3").val("");
              $("#select_tipo_documento").val(5); //ID 5, para tipo de documento DNI
            }
          })
       } 
    });

});

function validarCUIT (expresion, dni) {
  //    ^\d{2}31343209\d{1}$
  patt = new RegExp("^\\d{2}"+dni.val()+"\\d{1}$");
  if (patt.test(expresion.val())){
  }else{
    alert('CUIL incorrecto')
  }
}