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

    $("#input_dni").bind("propertychange change click keyup input paste",function(){
      var elem = $(this);
      elem.data('oldVal', elem.val());
      if (elem.data('oldVal') != elem.val()) {alert("cambio");}
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

// function editar_alta(id_alta) {
//   //console.log(id_alta);
//   $.ajax({
//       url: '/soft/snpe/altas_bajas_horas/buscar_alta/'+id_alta,
//       type: 'POST',
//     })
//     .done(function(data) {
//       if (data != null) {
//         console.log(data.fecha_alta);        
//         $("#datepicker").val(data.fecha_alta.split("-")[2]+"-"+data.fecha_alta.split("-")[1]+"-"+data.fecha_alta.split("-")[0]);
//         $("#sit-revista").val(data.situacion_revista);
//         $("#horas").val(data.horas);
//         $("#ciclo-carrera").val(data.ciclo_carrera);
//         $("#curso").val(data.anio);
//         $("#division").val(data.division);
//         $("#turno").val(data.turno);
//         $("#codificacion").val(data.codificacion);
//         $("#oblig").val(data.oblig);
//         $("#observaciones").val(data.observaciones);

//         $.ajax({
//           url: '/soft/snpe/util/buscar_persona_por_id/'+data.persona_id,
//           type: 'POST',
//         })
//         .done(function(data_persona) {
//           if (data_persona != null) {
//             $("#input_dni").val(data_persona.nro_documento);
//             $("#input_nombres").val(data_persona.nombres);
//             $("#input_apellidos").val(data_persona.apellidos);
//             $("#input_cuil").val(data_persona.cuil);
//             $("#datepicker3").val(data_persona.fecha_nacimiento.split("-")[2]+"-"+data_persona.fecha_nacimiento.split("-")[1]+"-"+data_persona.fecha_nacimiento.split("-")[0]);
//             $("#select_tipo_documento").val(data_persona.tipo_documento_id);
//           }
//           else{
//             //alert("La persona no existe. Por favor cargue sus datos");
//             $("#input_nombres").val("");
//             $("#input_apellidos").val("");
//             $("#input_cuil").val("");
//             $("#datepicker3").val("");
//             $("#select_tipo_documento").val(1);
//           }
//         })
//       }
//       else{
//         //alert("La persona no existe. Por favor cargue sus datos");
//         //$("#input_nombres").val("");
//       }
//     })
// }