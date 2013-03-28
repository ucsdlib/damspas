//-----------------------------
// DYNAMICALLY LOAD COMPONENTS
//-----------------------------

var componentLoaded = [];
function showComponent(componentIndex)
{
	var componentID = "#component-" + componentIndex;
	var container = componentID + " > div";
	var buttonID = "#node-btn-" + componentIndex;
	var componentData = $(container).attr("data");

	if (componentData != undefined) // Dynamically load images, audio files, and video files
	{
		if (!componentLoaded[componentIndex])
		{
			var controlID = "control-" + componentIndex;
			componentData = $.parseJSON(componentData);
			var fileType = componentData.file_type;
			var serviceFilePath = componentData.service_file_path;
			var displayFilePath = componentData.display_file_path;

			switch(fileType)
			{
				case "image":
					$(container).html( '<a href="'+serviceFilePath+'" target="_blank"><img src="'+displayFilePath+'"></a>' );
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
		componentLoaded[componentIndex] = true;
	}

	// Highlight component tree button text of selected component
	$(".components-tree button").removeClass('active-component');
	$(buttonID).addClass('active-component');

	// Show a specific component's container and hide the others
	$('.component').hide();
	$(componentID).show();
}

//-------------------------
// DOCUMENT READY GOODNESS
//-------------------------

$(document).ready(function()
{
	// Ensure all parent component containers are collapsed
	$('.node-container').hide();

	// Toggle parent component containers
	$(".node-toggle").on("click",function()
	{
		if($(this).hasClass('icon-chevron-right')){
			$(this).removeClass('icon-chevron-right').addClass('icon-chevron-down');
			$(this).next().next().show();
		}
		else{
			$(this).removeClass('icon-chevron-down').addClass('icon-chevron-right');
			$(this).next().next().hide();
		}
	});

	// Show/hide all components by clicking on sidebar header
	$("#sidebar-header").on("click",function()
	{
		if($(this).hasClass('tree-collapsed')){
			$(this).removeClass('tree-collapsed').addClass('tree-expanded');
			$(".node-toggle").removeClass('icon-chevron-right').addClass('icon-chevron-down');
			$('.node-container').show();
		}
		else{
			$(this).removeClass('tree-expanded').addClass('tree-collapsed');
			$(".node-toggle").removeClass('icon-chevron-down').addClass('icon-chevron-right');
			$('.node-container').hide();
		}
	});

	// Toggle metadata fold
	$("#metadata-fold").on("show",function(){$(this).prev().text("Hide metadata");});
	$("#metadata-fold").on("hide",function(){$(this).prev().text("Show metadata");});

	// Display the first component with a file
	var firstWithFiles = $(".component[data]").attr("data");
	showComponent(firstWithFiles)
});
