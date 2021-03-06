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
	var send_url = "/docs/sendtest";
	var url = decodeURIComponent(location.href).split('/');
	var history_area = document.getElementById("history");
	var navig_area = document.getElementById("navig");
	var record = "";

	source.addEventListener('new_message', function(e) {
		var message = JSON.parse(e.data);
		if (message.doc_id === url[url.length-1]) {
			scr.value = message.content;
			history_area.innerText = message.history_id+" : "+message.history_email+", "+message.history_timestamp;
			navig_area.innerText = "저장되었습니다.";
			record = scr.value;
		}
	});

	scr.addEventListener('keydown', function(e) {
		navig_area.innerText = "작성 중..";
	});

	setInterval(function(e) {
		if (scr.value != record) {
			var request = new XMLHttpRequest();
			var params = "content="+scr.value;
			params = params+"&doc_id="+url[url.length-1];
		 	request.open("POST", send_url, true);
		 	request.setRequestHeader("Content-type","application/x-www-form-urlencoded");
			request.send(params);
		}
		record = scr.value;
	}, 3000);
});