$(document).ready(function(){

	var roll = Math.floor(Math.random()*bg_data.length);
	var bg_img_url = "http://libraries.ucsd.edu/assets/dams/home-page/img/" + bg_data[roll].ark + ".jpg";
	var collection_url = $("meta[name=dams_root]").attr("content") + "dams_collections/" + bg_data[roll].ark;
	var collection_title = (bg_data[roll].title != "") ? "<p>" + bg_data[roll].title : "<p>Untitled";
	var collection_creator = (bg_data[roll].creator != "") ? "<p>" + bg_data[roll].creator : "";
	var collection_name = (bg_data[roll].collection != "") ? "<p>From the " + bg_data[roll].collection + " Collection" : "<p>View the collection" ;

	$("#home-01").css("background-image", "url(" + bg_img_url + ")");
	$("#bg-link").attr("href", collection_url);
	$('#bg-link').append(collection_title);
	$('#bg-link').append(collection_creator);
	$('#bg-link').append(collection_name);

});
