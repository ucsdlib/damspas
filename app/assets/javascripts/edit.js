
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

  if( label == 'Subject') {
	  $('#simpleSubjects').show();
	  
	  var subjectsArray =new Array("BuiltWorkPlace","CulturalContext","Function","GenreForm","Geographic","Iconography","Occupation","ScientificName","StylePeriod","Technique","Temporal","Topic");
	  for (var i in subjectsArray) {
	  	if(subjectsArray[i] == q) {
		  $('#'+q).show();
		}else {
		  $('#'+subjectsArray[i]).hide();
		}
	  }
   }

  if( label == 'Name') {
	  $('#names').show();
	  
	  var namesArray =new Array("Name","PersonalName","CorporateName","ConferenceName","FamilyName");
	  for (var i in namesArray) {
	  	if(namesArray[i] == q) {
		  $('#'+q).show();
		}else {
		  $('#'+namesArray[i]).hide();
		}
	  }
   }   
}