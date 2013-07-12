$(document).ready(function() {

  $('#dams_object_relationshipNameType_').change(function() {
  	  var q = $("#dams_object_relationshipNameType_").val(); 

      $.get(baseURL+"/get_name/get_name?formType=dams_object&q="+q,function(data,status){
	    $('#relationshipName').html(data);
	  });	      
    });

  $('#dams_provenance_collection_relationshipNameType_').change(function() {
  	  var q = $("#dams_provenance_collection_relationshipNameType_").val(); 

      $.get(baseURL+"/get_name/get_name?formType=dams_provenance_collection&q="+q,function(data,status){
	    $('#relationshipName').html(data);
	  });	      
    });
	    	    
});
