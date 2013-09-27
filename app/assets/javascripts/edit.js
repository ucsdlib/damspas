
function getName(type,q,location)
{
  $.get(baseURL+"/get_name/get_name?formType="+type+"&q="+q,function(data,status){
    $(location).html(data);
  });	 
}

function getSubjects(type,q,location,fieldName,label)
{
  $.get(baseURL+"/get_subject/get_subject?label="+label+"&fieldName="+fieldName+"&formType="+type+"&q="+q,function(data,status){
    $(location).html(data);
  });	

  $('#simpleSubjects').show();
  //$('#simpleSubject'+q).show();
  //$('#simpleSubjectTemporal').hide();
  //$("#simpleSubjectTopic").on("show",function(){$(this).prev().text("Hide Topic");});
  //$("#simpleSubjectTopic").on("hide",function(){$(this).prev().text("Show Topic");});
  
  var subjectsArray =new Array("BuiltWorkPlace","CulturalContext","Function","GenreForm","Geographic","Iconography","Occupation","ScientificName","StylePeriod","Technique","Temporal","Topic");
  for (var i in subjectsArray) {
  	if(subjectsArray[i] == q) {
	  $('#'+q).show();
	}else {
	  $('#'+subjectsArray[i]).hide();
	}
  }
}