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

//----------------------
// <OBJECT VIEWER PAGE>
//----------------------
var componentloaded = [];
function showComponent(componentIndex)
{
	var componentID = "#component-" + componentIndex;
	var container = componentID + " > div";
	var buttonID = "#tree-button-" + componentIndex;
	var componentData = $(container).attr("data");

	// Dynamically load images, audio files, and video files
	if (componentData != undefined)
	{
		if (!componentloaded[componentIndex])
		{
			var controlID = "control-" + componentIndex;
			componentData = $.parseJSON(componentData);
			var fileType = componentData.file_type;
			var serviceFilePath = componentData.service_file_path;
			var displayFilePath = componentData.display_file_path;

			switch(fileType)
			{
				case "image":
					$(container).html( '<a href="'+serviceFilePath+'" target="_blank"><img src="'+serviceFilePath+'"></a>' );
					break;
				case "audio":
					$(container).html( '<audio id="'+controlID+'" src="'+serviceFilePath+'" preload="auto"></audio>' );
					audiojs.events.ready(function(){audiojs.create(document.getElementById(controlID));});
					break;
				case "video":
					$(container).html( '<video id="'+controlID+'" class="video-js vjs-default-skin" controls width="100%" height="264" poster="'+displayFilePath+'" preload="auto"><source src="'+serviceFilePath+'" type="video/mp4" /></video>' );
					var myPlayer = _V_(controlID);
					break;
			}
		}
		componentloaded[componentIndex] = true;
	}

	// Highlight component tree button text of selected component
	$(".components-tree button").removeClass('active-component');
	$(buttonID).addClass('active-component');

	// Show a specific component's container and hide the others
	$('.component').hide();
	$(componentID).show();
}
$(document).ready(function()
{
	// Toggle parent arrows on component tree
	$("[id^=meta-]").on("show",function(){$(this).prev().find("i").removeClass("icon-chevron-right").addClass("icon-chevron-down");});
	$("[id^=meta-]").on("hide",function(){$(this).prev().find("i").removeClass("icon-chevron-down").addClass("icon-chevron-right");});

	// Toggle metadata fold
	$("#metadata-fold").on("show",function(){$(this).prev().text("Hide metadata");});
	$("#metadata-fold").on("hide",function(){$(this).prev().text("Show metadata");});

	// Display the first component with a file
	var firstWithFiles = $(".component[data]").attr("data");
	showComponent(firstWithFiles)
});
//-----------------------
// </OBJECT VIEWER PAGE>
//-----------------------