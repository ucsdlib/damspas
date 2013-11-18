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

    var data;
	var tile_url = 'http://otile1.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png';
	var tile_att = 'Tiles courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a>';


	//------
	// LOAD
	//------
	this.load =  function()
	{
		data = $("#map-canvas").attr("data");
		data = (data != undefined) ? $.parseJSON(data) : data;
		if ( data != undefined )
		{
			switch (data.type)
			{
				case "point":
					dp.cartographics.initPoint();
					break;
				case "line":
					dp.cartographics.initLine();
					break;
				case "polygon":
					dp.cartographics.initPolygon();
					break;
			}
		} else { console.log('#map-canvas[data] is undefined'); }
	}

	//------------
	// INIT POINT
	//------------
	this.initPoint = function()
	{
		var point = data.coords.split(",");
		var map = L.map('map-canvas').setView(point, 12);
		L.tileLayer(tile_url, {attribution: tile_att, maxZoom: 18}).addTo(map);
        var icon = new L.divIcon({className: 'icon-map-marker', iconSize: 13});
		L.marker(point,{icon: icon}).addTo(map);
	}

	//-----------
	// INIT LINE
	//-----------
	this.initLine = function()
	{
		var points = data.coords.split(" ");
		for ( i = 0; i < points.length; i++ )
		{
			split = points[i].split(",");
			points[i] = [ parseFloat(split[0]), parseFloat(split[1]) ];
		}
		var map = L.map('map-canvas').fitBounds(points);
		L.tileLayer(tile_url, {attribution: tile_att, maxZoom: 18}).addTo(map);
		L.polyline(points).addTo(map);
	}

	//-----------
	// INIT POLYGON
	//-----------
	this.initPolygon = function()
	{
		var points = data.coords.split(" ");
		for ( i = 0; i < points.length; i++ )
		{
			split = points[i].split(",");
			points[i] = [ parseFloat(split[0]), parseFloat(split[1]) ];
		}
		var map = L.map('map-canvas').fitBounds(points);
		L.tileLayer(tile_url, {attribution: tile_att, maxZoom: 18}).addTo(map);
		L.polygon(points).addTo(map);
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
				componentData = $.parseJSON(componentData);
				var fileType = componentData.file_type;
				var serviceFilePath = componentData.service_file_path;
				var displayFilePath = componentData.display_file_path;

				switch(fileType)
				{
					case "image":
						$(container).html( '<a href="'+serviceFilePath+'" alt=""><img src="'+displayFilePath+'"></a>' );
						break;
					case "audio":

                        jwplayer("dams-audio-"+componentIndex).setup({
                            playlist:
                                [{
                                    sources:
                                        [
                                            {file: "rtmp://"+serviceFilePath},
                                            {file: "http://"+serviceFilePath+"/playlist.m3u8"}
                                        ]
                                }],
                            width: "100%",
                            height: 25,
                            controlBar:'bottom',
                            rtmp: {bufferlength: 3},
                            analytics: {enabled: false},
                            primary: "flash",
                            fallback: false
                        });

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

	//$('#simpleSubjects').hide();
	$('#names').hide();
	$('#relationshipNames').hide();
	
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

