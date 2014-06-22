// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).ready(function(){
	var source = new EventSource('/stream');
	var scr = document.getElementById("screen");
	var url = "/docs/sendtest";

	source.addEventListener('new_message', function(e) {
		var message = JSON.parse(e.data);
		scr.value = message.content;
	});

	scr.addEventListener('input', function(e) {
		var request = new XMLHttpRequest();
		var params = "content="+scr.value;
	 	request.open("POST", url, true);
	 	request.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		request.send(params);
	 	console.log(request);
	});
});
