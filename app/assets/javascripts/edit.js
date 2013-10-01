
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

  if( label == 'Name' && fieldName == 'nameURI') {
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

function processForm() {
    var attributesArray =new Array("assembledCollection","provenanceCollection","provenanceCollectionPart","complexSubject","statute","license","copyright","language","unit","rightsHolderPersonal");
    var fieldId = "";
    for (var j in attributesArray) {
      fieldId = "#dams_object_"+attributesArray[j]+"_attributes_0_id";
  	  if($(fieldId).val().length < 1) {
	      $(fieldId).remove();
	  } 	  
    }  	
 	
    var subjectsArray =new Array("BuiltWorkPlace","CulturalContext","Function","GenreForm","Geographic","Iconography","Occupation","ScientificName","StylePeriod","Technique","Temporal","Topic","Name","PersonalName","CorporateName","ConferenceName","FamilyName");
    fieldId = "";
    for (var i in subjectsArray) {
      fieldId = "#dams_object_"+subjectsArray[i].charAt(0).toLowerCase()+subjectsArray[i].slice(1)+"_attributes_0_name";
  	  if($(fieldId).val().length < 1) {
	      $("#"+subjectsArray[i]).remove();
	  } 	  
    }
                               
    if($("#dams_object_date_attributes_0_value").val().length < 1)
    {
      $("#dateSection").remove();
    }
    
    if($("#dams_object_note_attributes_0_value").val().length < 1)
    {
      $("#noteSection").remove();
    }

    if($("#dams_object_scopeContentNote_attributes_0_value").val().length < 1)
    {
      $("#scopeNoteSection").remove();
    }
    
    if($("#dams_object_custodialResponsibilityNote_attributes_0_value").val().length < 1)
    {
      $("#custodialNoteSection").remove();
    }
    
    if($("#dams_object_preferredCitationNote_attributes_0_value").val().length < 1)
    {
      $("#preferredNoteSection").remove();
    }    

    if($("#dams_object_relatedResource_attributes_0_description").val().length < 1 && $("#dams_object_relatedResource_attributes_0_type").val().length < 1 )
    {
      $("#relatedResourceSection").remove();
    }
    
    if($("#dams_object_cartographics_attributes_0_point").val().length < 1 && $("#dams_object_cartographics_attributes_0_line").val().length < 1)
    {
      $("#cartographicsSection").remove();
    }   
    return true; 
}