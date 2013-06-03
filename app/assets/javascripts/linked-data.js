oclc_data = {}; 


(function(){

	//------
	// LOAD
	//------
	this.load =  function()
	{


//$("#auto-complete").load("/linked_data/list",function(responseTxt,statusTxt,xhr){
//		    if(statusTxt=="success")
//		      alert("External content loaded successfully!");
//		    if(statusTxt=="error")
//		      alert("Error: "+xhr.status+": "+xhr.statusText);
//		  });		

        
		  // $("#auto-complete").hide(); work
		  URL = "/linked_data/get_data/get_data"
		// $.get(URL,function(data,status){
		 //   alert("Data: " + data + "\nStatus: " + status);
		//  });
		  
 		 // $.post(URL, {q: "cats", fl: "suggestall"},function(data,status){
		   // alert("Data: " + data + "\nStatus: " + status);
		  //});		  
		  
	}

	//------------
	// INIT DATA
	//------------
	this.initData = function()
	{
		//document.getElementById("auto-complete").innerHTML = ""
	}
}).apply(oclc_data);


$(document).ready(function() {
	oclc_data.load();
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
});