$(document).ready(function() {
	  $('#dams_object_relationshipNameType_').change(function() {
	  	  var q = $("#dams_object_relationshipNameType_").val();
	      $.get("/linked_data/get_name/get_name?q="+q,function(data,status){
	      	alert("data"+data);
		    $('#relationshipName').html(data);
		  });	      
	    });
	    	    
});