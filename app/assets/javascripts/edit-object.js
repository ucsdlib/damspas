$(document).ready(function() {
  var hostName=location.protocol+"//"+location.host;
  $('#dams_object_relationshipNameType_').change(function() {
  	  var q = $("#dams_object_relationshipNameType_").val(); 

  	  if(hostName.indexOf("pontos") > 0) {
  	  	hostName += "/dams";
  	  }

      $.get(hostName+"/linked_data/get_name/get_name?q="+q,function(data,status){
	    $('#relationshipName').html(data);
	  });	      
    });
	    	    
});