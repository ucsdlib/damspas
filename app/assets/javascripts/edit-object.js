$(document).ready(function() {
	
	  $('#dams_object_subjectType_').change(function() {
	  	  var selected_value = $("#dams_object_subjectType_").val();
	      
	      var fl = "";
	      var q = "*";
	      if(selected_value == "Geographic"){
	      	fl = "suggest51";
	      } else {
	      	fl = "suggestall";
	      }
	      alert("changeeee" + selected_value + "-fl:"+fl); 
	      $.get("/linked_data/get_data?fl="+fl+"&q="+q,function(data,status){
		    alert("Data: " + data + "\nStatus: " + status);
		  });
	    });

	  $('#dams_object_relationshipNameType_').change(function() {
	  	  var q = $("#dams_object_relationshipNameType_").val();
	      $.get("/linked_data/get_name/get_name?q="+q,function(data,status){
	      	alert("data"+data);
		    $('#relationshipName').html(data);
		  });	      
	    });
	    	    
});