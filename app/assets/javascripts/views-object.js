//-------------
// NAMESPACING
//-------------

var dp = dp || {}; // DAMSPAS
dp.COV = {}; // COMPLEX OBJECT VIEW
dp.cartographics = {}; // CARTOGRAPHICS DISPLAY

//---------------
// CARTOGRAPHICS
//---------------

(function(){

	var data = $("#map-canvas[data]").attr("data");
	data = (data != undefined) ? $.parseJSON(data) : data;

	//------
	// LOAD
	//------
	this.load =  function()
	{
		var API_KEY = "AIzaSyD1-xPB9pfLU40NToczl9kK_l-YpHBJhuA";
		var URL = "https://maps.googleapis.com/maps/api/js?key="+API_KEY+"&sensor=false";
		var g = document.createElement("script");
		g.type = "text/javascript";

		switch (data.type)
		{
			case "point":
				g.src = (URL+"&callback=dp.cartographics.initPoint");
				break;
			case "line":
				g.src = (URL+"&callback=dp.cartographics.initLine");
				break;
		}

		document.body.appendChild(g);
	}

	//------------
	// INIT POINT
	//------------
	this.initPoint = function()
	{
		var point = data.coords;
		var latlong = [];
		var lineCoords = [];

		point = point.split(",");
		latlong = new google.maps.LatLng(point[0],point[1]);

		var options = {
			center: latlong,
			zoom: 3,
			mapTypeId: google.maps.MapTypeId.TERRAIN
		};

		var map = new google.maps.Map(document.getElementById("map-canvas"),options);

		var marker = new google.maps.Marker({
			position: latlong,
			map: map,
			animation: google.maps.Animation.DROP
		})
	}

	//-----------
	// INIT LINE
	//-----------
	this.initLine = function()
	{
		var points = data.coords.split(" ");
		var point = [];
		var latlong = [];
		var lineCoords = [];

		for (var i = 0; i < points.length; i++)
		{
			point = points[i].split(",");
			latlong[i] = new google.maps.LatLng(point[0],point[1]);
			lineCoords[i] = latlong[i];
		}

		var options = {
			center: latlong[0],
			zoom: 3,
			mapTypeId: google.maps.MapTypeId.TERRAIN
		};

		var map = new google.maps.Map(document.getElementById("map-canvas"),options);

		var symbolOne = {path:google.maps.SymbolPath.FORWARD_OPEN_ARROW,scale:2,strokeColor:"#f00"};
		var symbolTwo = {path:google.maps.SymbolPath.BACKWARD_OPEN_ARROW,scale:2,strokeColor:"#f00"};

		var line = new google.maps.Polyline({
			path: lineCoords,
			icons: [{icon:symbolOne,offset:"0%"},{icon:symbolTwo,offset:"100%"}],
			strokeColor: "#300",
			strokeOpacity: 1.0,
			strokeWeight: 2
		});

		line.setMap(map);
	}

}).apply(dp.cartographics);


//-----------------------------
// DYNAMICALLY LOAD COMPONENTS
//-----------------------------

(function(){

	var componentLoaded = [];

	this.showComponent = function(componentIndex)
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

                        jwplayer("dams-video-"+componentIndex).setup({
                            playlist:
                                [{
                                    sources:
                                        [
                                            {file: "rtmp://"+serviceFilePath},
                                            {file: "http://"+serviceFilePath+"/playlist.m3u8"}
                                        ]
                                }],
                            width: "100%",
                            aspectratio: "16:9",
                            rtmp: {bufferlength: 3},
                            analytics: {enabled: false},
                            primary: "flash",
                            fallback: false
                        });

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

}).apply(dp.COV);

//----------------
// DOCUMENT READY
//----------------

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

	// Display the first component with a file (denoted by: data='componentIndex') if present
	if ($(".component[data]").attr("data") != undefined)
	{
		dp.COV.showComponent($(".component[data]").attr("data"))
	}

	// Load cartographics if present
	if($("#map-canvas").length)
	{
		dp.cartographics.load();
	}

	// handle derivatives generation callbacks
	$('#generate_derivatives')
		.bind('ajax:success', function(e) {
          // update flash message
          msg = document.getElementById('messages')
          msg.innerHTML = '<div class="flash_messages"><div class="alert alert-info">Derivatives Generated <a class="close" data-dismiss="alert" href="#">&times;</a></div>';

          // hide button
          btn = document.getElementById('generate_derivatives')
          btn.style.display = 'none';
		})
		.bind('ajax:error', function(e) {
          msg = document.getElementById('messages')
          msg.innerHTML = '<div class="flash_messages"><div class="alert alert-alert">Error Generating Derivatives! <a class="close" data-dismiss="alert" href="#">&times;</a></div>';
		})
});

