var complexSubjectIdArray = new Array();

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
    toggleRelationshipNames(q,"","names");
   }   
}

function getSimpleSubjects(link,type,location,fieldId,selectedValue)
{  
  var q = null;
  var fieldName = null;
   
  if (typeof link == "string") {
  	q = link;
  	fieldName = "simpleSubjectURI";
  } else {
  	q = link.value;
  	fieldName = firstToLowerCase(q);
  }

  if(q != null && q.length > 0) {
	  $.get(baseURL+"/get_subject/get_subject?selectedValue="+selectedValue+"&fieldId="+fieldId+"&fieldName="+fieldName+"&formType="+type+"&q="+q,function(data,status){
	    var new_id = new Date().getTime();
	    data = data.replace("attributes_"+fieldId,"attributes_"+new_id);
	    data = data.replace("attributes]["+fieldId+"]","attributes]["+new_id+"]");
	    data = data.replace("newTopic",new_id);  
	    if(location != null && location.length > 0)
	    	$(location).html(data);
	    else
	    	$(link).parent().before(data);
	  }); 
  }
}

function displayRelationshipName(value)
{
  toggleRelationshipNames(value,"relationship","relationshipNames");
}

function toggleRelationshipNames(value, label, section)
{
  $('#'+section).show();
  
  var namesArray =new Array("Name","PersonalName","CorporateName","ConferenceName","FamilyName");
  for (var i in namesArray) {
    if(namesArray[i] == value) {
    $('#'+label+value).show();
  }else {
    $('#'+label+namesArray[i]).hide();
  }
  }
}

//parsing parameters as "#dams_object_", #dams_provenance_collection_", "#dams_assembled_collection_","#dams_provenance_collection_part",etc,
function processForm_generic(objType) {
    var attributesArray =new Array("assembledCollection","provenanceCollection","provenanceCollectionPart","complexSubject","statute","license","copyright","language","unit","rightsHolderPersonal");
    var fieldId = "";
    for (var j in attributesArray) {
      fieldId = objType+attributesArray[j]+"_attributes_0_id";
      if($(fieldId).val() != null && $(fieldId).val().length < 1) {
        $(fieldId).remove();
    }     
    }   
  
    var subjectsArray =new Array("BuiltWorkPlace","CulturalContext","Function","GenreForm","Geographic","Iconography","Occupation","ScientificName","StylePeriod","Technique","Temporal","Topic","Name","PersonalName","CorporateName","ConferenceName","FamilyName");
    fieldId = "";
    for (var i in subjectsArray) {
      fieldId = objType+subjectsArray[i].charAt(0).toLowerCase()+subjectsArray[i].slice(1)+"_attributes_0_name";
      if($(fieldId).val() != null && $(fieldId).val().length < 1) {
        $("#"+subjectsArray[i]).remove();
    }     
    }

    var relNamesArray =new Array("Name","PersonalName","CorporateName","ConferenceName","FamilyName");
    fieldId = "";
    for (var i in relNamesArray) {
      fieldId = objType+"relationship_attributes_0_"+relNamesArray[i].charAt(0).toLowerCase()+relNamesArray[i].slice(1)+"_attributes_0_id";
      if($(fieldId).val() != null && $(fieldId).val().length < 1) {
        $("#relationship"+relNamesArray[i]).remove();
      }     
    }
                                   
    if($(objType+"date_attributes_0_value").val() != null && $(objType+"date_attributes_0_value").val().length < 1)
    {
      $("#dateSection").remove();
    }
    
    if($(objType+"note_attributes_0_value").val() != null && $(objType+"note_attributes_0_value").val().length < 1)
    {
      $("#noteSection").remove();
    }

    if($(objType+"scopeContentNote_attributes_0_value").val() != null && $(objType+"scopeContentNote_attributes_0_value").val().length < 1)
    {
      $("#scopeNoteSection").remove();
    }
    
    if($(objType+"custodialResponsibilityNote_attributes_0_value").val() != null && $(objType+"custodialResponsibilityNote_attributes_0_value").val().length < 1)
    {
      $("#custodialNoteSection").remove();
    }
    
    if($(objType+"preferredCitationNote_attributes_0_value").val() != null && $(objType+"preferredCitationNote_attributes_0_value").val().length < 1)
    {
      $("#preferredNoteSection").remove();
    }    

    if($(objType+"relatedResource_attributes_0_description").val() != null && $(objType+"relatedResource_attributes_0_type").val() != null && 
    	$(objType+"relatedResource_attributes_0_description").val().length < 1 && $(objType+"relatedResource_attributes_0_type").val().length < 1 )
    {
      $("#relatedResourceSection").remove();
    }
    
    if($(objType+"cartographics_attributes_0_point").val() != null && $(objType+"cartographics_attributes_0_line").val() != null && 
    	$(objType+"cartographics_attributes_0_point").val().length < 1 && $(objType+"cartographics_attributes_0_line").val().length < 1)
    {
      $("#cartographicsSection").remove();
    }    

    if($(objType+"relationship_attributes_0_role_attributes_0_id").val() != null && $(objType+"relationship_attributes_0_role_attributes_0_id").val().length < 1)
    {
      $(objType+"relationship_attributes_0_role_attributes_0_id").remove();
    }
    
    if($(objType+"language_attributes_0_name").val() != null && $(objType+"language_attributes_0_name").val().length < 1)
    {
      $("#newLanguage").remove();
    }
    
	for (var i=0;i<complexSubjectIdArray.length;i++) {
	    if($(objType+"complexSubject_attributes_"+complexSubjectIdArray[i]+"_id").val() != null && $(objType+"complexSubject_attributes_"+complexSubjectIdArray[i]+"_id").val().length < 1)
	    {
	    	$("#"+complexSubjectIdArray[i]).remove();
	    }	    
	}                     
    return true; 
}

function remove_fields(link) {
  $(link).closest(".fields").remove();
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    content = content.replace("newClassName",new_id);  
    if(association == "complexSubject") {
    	content = content.replace("complexSubjectId",new_id);
    	complexSubjectIdArray.push(new_id);
    }

    $(link).parent().before(content.replace(regexp, new_id));
}

function add_subject_fields(link, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("simpleSubject", "g");
    $(link).parent().before(content.replace(regexp, new_id));
}

function target_popup(target) {
  var win = window.open(target, 'popup', 'fullscreen=yes, resizable=no,toolbar=0,directories=0,menubar=0,status=0,scrollbars=yes');
  win.resizeTo(550,650);
}

function setParentId_generic(parent_id, isId) {
  var target = "";
  if(isId == true) {  
  	target=window.opener.document.getElementById(parent_id);
  } else {
    target=window.opener.document.getElementsByClassName(parent_id)[0];
  }
  var optionName = new Option(document.getElementById('name').value, 'http://library.ucsd.edu/ark:/20775/'+document.getElementById('id').value);    
  var targetlength = target.length;    
  target.options[targetlength] = optionName; 
  target.options[targetlength].setAttribute("selected","selected");
  self.close();
}

function checkOption(id,isId,type) {
  if( isId == true && $("#"+id).val().indexOf("Create New") >= 0) {
	if(type.indexOf("mads") < 0 && type.indexOf("dams") < 0) {  	
	  type = getObjectsPath(type);
	}  
    target_popup(baseURL.replace("get_data","")+type+"/new?parent_id="+id);
  } else if( isId == false && $("."+id).val().indexOf("Create New") >= 0) {
	if(type.indexOf("mads") < 0 && type.indexOf("dams") < 0) {  	
	  type = getObjectsPath(type);
	}    
    target_popup(baseURL.replace("get_data","")+type+"/new?parent_class="+id);
  }  
}

function loadCreateNewObjectOption_generic(objType) {
  var target=window.document.getElementById(objType+'language_attributes_0_id');    
  var optionName = new Option('Create New Language','createNewLanguage');    
  var targetlength = target.length;    
  target.options[targetlength] = optionName;
}

function getObjectsPath(type) {
	var	objectPathArray = 	[["BuiltWorkPlace","dams_built_work_places"],["CulturalContext","dams_cultural_contexts"], ["Function","dams_functions"], 
							 ["GenreForm","mads_genre_forms"], ["Geographic","mads_geographics"], ["Iconography","dams_iconographies"], 
						  	 ["Occupation","mads_occupations"], ["ScientificName","dams_scientific_names"], ["StylePeriod", "dams_style_periods"], 
						  	 ["Technique","dams_techniques"], ["Temporal","mads_temporals"], ["Topic","mads_topics"],
							 ["ConferenceName","mads_conference_name"],["Name","mads_names"],["PersonalName","mads_personal_names"],
							 ["CorporateName","mads_corporate_names"],["FamilyName","mads_family_names"]];
	for(i = 0; i < objectPathArray.length; i++) {
		if(type == objectPathArray[i][0]) {
			return objectPathArray[i][1];
		}
	}
	return null;
}

function firstToLowerCase( str ) {
    return str.substr(0, 1).toLowerCase() + str.substr(1);
}
