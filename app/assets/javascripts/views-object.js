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
		var tileLayer = MQ.tileLayer(), map;
		map = L.map('map-canvas', {layers: tileLayer, scrollWheelZoom: false, maxZoom: 18}).setView(point, 4);
        var icon = new L.divIcon({className: 'icon-map-marker', iconSize: 13});
		L.marker(point,{icon: icon}).addTo(map);		
        L.control.layers({'Tile': tileLayer,'Map': MQ.mapLayer(),'Hybrid': MQ.hybridLayer(),'Satellite': MQ.satelliteLayer()}).addTo(map);
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
		var tileLayer = MQ.tileLayer(), map;
		map = L.map('map-canvas', {layers: tileLayer, scrollWheelZoom: false, maxZoom: 18}).fitBounds(points).zoomOut(10);
		L.polyline(points).addTo(map);
        L.control.layers({'Tile': tileLayer,'Map': MQ.mapLayer(),'Hybrid': MQ.hybridLayer(),'Satellite': MQ.satelliteLayer()}).addTo(map);
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
		var tileLayer = MQ.tileLayer(), map;
        map = L.map('map-canvas', {layers: tileLayer, scrollWheelZoom: false, maxZoom: 18}).fitBounds(points).zoomOut(4);
        L.polygon(points).addTo(map);
        L.control.layers({'Tile': tileLayer,'Map': MQ.mapLayer(),'Hybrid': MQ.hybridLayer(),'Satellite': MQ.satelliteLayer()}).addTo(map);
	}

}).apply(dp.cartographics);


//---------------------
// COMPLEX OBJECT VIEW
//---------------------

(function(){

	var componentLoaded = [];

    //-----------
    // DYNAMICALLY LOAD COMPONENTS
    //-----------
	this.showComponent = function(componentIndex)
	{

		var componentID = "#component-" + componentIndex;
		var container = componentID + " > [data]";
		var buttonID = "#node-btn-" + componentIndex;
		var componentData = $(container).attr("data");
        var pagerLabel = "Component " + componentIndex + " of " + $("#sidebar-header").attr("data-count");

		if (componentData != undefined) // Dynamically load images, audio files, and video files
		{
			if (!componentLoaded[componentIndex])
			{
				componentData = $.parseJSON(componentData);
				var fileType = componentData.file_type;
				var serviceFilePath = componentData.service_file_path;
				var displayFilePath = componentData.display_file_path;
				var secure_token = componentData.secure_token;

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
                                            {file: "https://"+serviceFilePath+"/playlist.m3u8?"+secure_token}                                            
                                        ]
                                }],
                            width: "100%",
                            height: 40,
                            rtmp: {bufferlength: 3},
                            analytics: {enabled: false}
                        });
                        jwplayer("dams-audio-"+componentIndex).on('ready', function() {
                            resize("dams-audio-"+componentIndex);
                            window.onresize = function() {
                                resize("dams-audio-"+componentIndex);
                            };    
                        });
						break;
					case "video":

                        jwplayer("dams-video-"+componentIndex).setup({
                            playlist:
                                [{
                                    sources:
                                        [
                                            {file: "https://"+serviceFilePath+"/playlist.m3u8?"+secure_token},
                                            {file: "https://"+serviceFilePath+"/manifest.mpd?"+secure_token}                                                                                
                                        ]
                                }],
                            width: "100%",
                            aspectratio: "16:9",
                            rtmp: {bufferlength: 3},
                            analytics: {enabled: false}
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

        // Update component pager label
        $("#component-pager-label").html(pagerLabel);
	}

    //-----------
    // TOGGLE COMPONENT TREE
    //-----------
    this.toggleTree = function()
    {
        if($("#sidebar-header").hasClass('tree-collapsed'))
        {
            $("#sidebar-header").removeClass('tree-collapsed').addClass('tree-expanded');
            $(".node-toggle").removeClass('icon-chevron-right').addClass('icon-chevron-down');
            $('.node-container').show();
        }
        else
        {
            $("#sidebar-header").removeClass('tree-expanded').addClass('tree-collapsed');
            $(".node-toggle").removeClass('icon-chevron-down').addClass('icon-chevron-right');
            $('.node-container').hide();
        }
    }

    //-----------
    // SHOW COMPONENT TREE
    //-----------
    this.showTree = function()
    {
        if($("#sidebar-header").hasClass('tree-collapsed'))
        {
            $("#sidebar-header").removeClass('tree-collapsed').addClass('tree-expanded');
        }
        else
        {
            $("#sidebar-header").removeClass('tree-expanded');
            $("#sidebar-header").addClass('tree-expanded');
        }
        $(".node-toggle").removeClass('icon-chevron-right').addClass('icon-chevron-down');
        $('.node-container').show();
    }

}).apply(dp.COV);

//----------------
// DOCUMENT READY
//----------------

$(document).ready(function()
{
	// Show component tree
    dp.COV.showTree();

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
        dp.COV.toggleTree();
	});

    // Component pager functionality
    $("#component-pager-forward").on("click",function()
    {
        var max_index = parseInt($("#sidebar-header").attr("data-count"));
        var current_index = parseInt($(".active-component").attr("data-index"));
        if (current_index < max_index)
        {
            dp.COV.showTree();
            dp.COV.showComponent(current_index+1);
        }
    });
    $("#component-pager-back").on("click",function()
    {
        var min_index = 1;
        var current_index = parseInt($(".active-component").attr("data-index"));
        if (current_index > min_index)
        {
            dp.COV.showTree();
            dp.COV.showComponent(current_index-1);
        }
    });

	// Toggle metadata fold
	$("#metadata-fold").on("show",function(){$(this).prev().text("Hide details");});
	$("#metadata-fold").on("hide",function(){$(this).prev().text("Show details");});

	//$('#simpleSubjects').hide();
	$('#names').hide();
	$('#relationshipNames').hide();
	$('.related_resources_link').hide();
	
	//Show more related resources links
	$("#more_related_resources").on("click",function()
	{
		$('.related_resources_link').show();
		$('#more_related_resources').hide();
	});
		
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

    // Hide content if "restricted notice" present
    if($(".restricted-notice").length)
    {
        $(".simple-object, .first-component, .dams-sidebar").hide();
    }

    // Hide content if "restricted view notice" present
    if($(".restricted-notice-complex").length)
    {
        $(".simple-object").hide();
    }
    
    // Show hidden "restricted notice" objects
    $("#view-masked-object").click(function() {        
        $('.restricted-notice').hide();
        $(".simple-object, .first-component, .dams-sidebar").show();
    });

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

