 $(document).ready(function($) {

    $("#datos_persona").hide();


    

    

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

    $("#input_dni").keyup(function(){
       var dni = parseInt($("#input_dni").val(),10);
       $("#datos_persona").show();
        $.ajax({
          url: '/soft/snpe/util/buscar_persona/'+dni,
          type: 'POST',
        })
        .done(function(data) {
          if (data != null) {
            $("#input_nombres").val(data.nombres);
            $("#input_apellidos").val(data.apellidos);
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
            $("#select_tipo_documento").val(1);
          }
        })
    });

  });


function validarCUIT (expresion) {
  if ((/^\d{2}\d{8}\d{1}$/).test(expresion.val())){
  }else{
    alert('cuil incorrecto')
  }
}