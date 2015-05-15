  $(document).ready(function($) {

    function eliminarCaracter(cadena, caracter) {
      var resultado1 = cadena.split(caracter).join(" ");
      var resultado2 = resultado1.split("   ").join(" ");
      var resultado3 = resultado2.split("  ").join(" ");
      return resultado3;
    }

  });