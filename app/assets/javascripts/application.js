// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.

//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery-ui-timepicker-addon.js
//= require autocomplete-rails
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require select2
//= require twitter/bootstrap
//= require jquery-ui
//= require jquery-ui-timepicker-addon.js
//= require autocomplete-rails
//= require bootstrap-editable
//= require bootstrap-editable-rails


$(function () {
    $('[data-toggle="tooltip"]').tooltip()
})

function abrir_reporte(direccion, pantallacompleta, herramientas, direcciones, estado, barramenu, barrascroll, cambiatamano, ancho, alto, izquierda, arriba, sustituir){
	var opciones = "fullscreen=" + pantallacompleta +
                   ",toolbar=" + herramientas +
                   ",location=" + direcciones +
                   ",status=" + estado +
                   ",menubar=" + barramenu +
                   ",scrollbars=" + barrascroll +
                   ",resizable=" + cambiatamano +
                   ",width=" + ancho +
                   ",height=" + alto +
                   ",left=" + izquierda +
                   ",top=" + arriba;
    var ventana = window.open(direccion,"venta",opciones,sustituir);
} 

/*grecaptcha.ready(function() {
grecaptcha.execute('6LeibIwUAAAAAATVYUQfX6nmaOFzWscpTqanp-h8', {action: 'action_name'})
.then(function(token) {
// Verify the token on the server.
});
});*/
                  
  
