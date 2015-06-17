  $(document).ready(function($) {

    function eliminarCaracter(cadena, caracter) {
      var resultado1 = cadena.split(caracter).join(" ");
      var resultado2 = resultado1.split("   ").join(" ");
      var resultado3 = resultado2.split("  ").join(" ");
      return resultado3;
    }

	 $('#modal_bajas_efectivas, #modal_novedades, #modal_altas').on('shown.bs.modal', function (event) {      
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
	  $('#modal_bajas_efectivas, #modal_novedades, #modal_altas').on('hidden.bs.modal', function () {
	    $(".limpiable").remove();
	    $("#boton_ocultar_historial").hide();
	    $("#boton_mostrar_historial").show();
	  });

	  $("#cerrar_modal_altas").click(function(){
	    $(".limpiable").remove();
	  });


	  $('#modal_cargos').on('shown.bs.modal', function (event) {      
	    var alta_id = $(event.relatedTarget).attr('cargo-id');
	    $.ajax({
	        url: '/soft/snpe/util/buscar_estados_cargo/'+alta_id,
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

	  // $("#boton_ocultar_historial").hide();    

	  // $("#boton_ocultar_historial").click(function(){
	  //   $(".ocultable").hide();
	  //   $("#boton_ocultar_historial").hide();
	  //   $("#boton_mostrar_historial").show();
	  // });

	  // $("#boton_mostrar_historial").click(function(){
	  //   $(".ocultable").show();
	  //   $("#boton_mostrar_historial").hide();
	  //   $("#boton_ocultar_historial").show();
	  // });

	  //acá limpiamos el modal cada vez que se cierra
	  $('#modal_cargos').on('hidden.bs.modal', function () {
	    $(".limpiable").remove();
	    $("#boton_ocultar_historial").hide();
	    $("#boton_mostrar_historial").show();
	  });

	  $("#cerrar_modal_cargos").click(function(){
	    $(".limpiable").remove();
	  });

 });