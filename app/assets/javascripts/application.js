// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//
// Required by Blacklight
//= require blacklight/blacklight
//= require bootstrap
//= require_tree .
//= require audio.min




$(document).ready(function() {
	$('.carousel').carousel();
});



Blacklight.do_search_context_behavior = function() {};



// OBJECT VIEWER PAGE - DT
$(document).ready(function(){
	
	//$("[id^=meta-]").on("show",function(){$(this).prev().find("i").removeClass("icon-chevron-right").addClass("icon-chevron-down");});
	//$("[id^=meta-]").on("hide",function(){$(this).prev().find("i").removeClass("icon-chevron-down").addClass("icon-chevron-right");});

	$("#alt-fold").on("show",function(){$(this).prev().text("Show less");});
	$("#alt-fold").on("hide",function(){$(this).prev().text("Show more");});
	
});