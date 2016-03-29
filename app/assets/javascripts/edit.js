function getAutocompleteList_callback(formtype,fieldname,elementID,elementLabel){
    
    
    var IDTag='#'+elementID;
    var typeaheadLabelTag='#'+elementLabel+'.typeahead';
    
    var labelsDAMS = new Bloodhound({
        datumTokenizer: function (d) {

            return Bloodhound.tokenizers.whitespace(d.label);
        },
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        prefetch: {
          url: '/dc/get_data/get_dams_data/get_dams_data?q='+fieldname,
          
          // the json file contains an array of strings, but the Bloodhound
          // suggestion engine expects JavaScript objects so this converts all of
          // those strings
          filter: function(items) {
                return $.map(items, function(item) { 
                       return { label: item.label, id: item.id }; 
                });
           }  
        }
    });

    var labelsLOC = new Bloodhound({
        datumTokenizer: function (d) {

            return Bloodhound.tokenizers.whitespace(d.label);
        },
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote: {
          url: '/dc/qa/search/loc/subjects?q=%QUERY',
          
          filter: function(items) {
                return $.map(items, function(item) { 
                       return { label: item.label, id: item.id }; 
                });
           }  
        }
    });

    // Initialise Bloodhound suggestion engines for each input
    labelsDAMS.initialize();
    labelsLOC.initialize();

    var subjectLabelTypeahead = $(typeaheadLabelTag);
    var subjectId = $(IDTag);

    // Initialise typeahead 
    subjectLabelTypeahead.typeahead({
        highlight: true,
        minLength: 2
    }, 
    {
        name: 'labelDAMS',
        displayKey: 'label',
        source: labelsDAMS.ttAdapter(),
        templates: {
          header: '<h4 class="subject-name">DAMS</h4>'
        }
    },
    {
        name: 'labelLOC',
        displayKey: 'label',
        source: labelsLOC.ttAdapter(),
        templates: {
          header: '<h4 class="subject-name">LOC</h4>'
        }
    });

    // Set-up callback event handlers so that the ID is auto-populated when label is selected
    var subjectLabelItemSelectedHandler = function (eventObject, suggestionObject, suggestionDataset) {
        
         if (suggestionDataset == "labelDAMS" ) {
           subjectId.val(suggestionObject.id);
         }
         else
         {
           subjectId.val("loc:"+ fieldname + "_label:"+suggestionObject.label  );
         }

         
    };

    subjectLabelTypeahead.on('typeahead:selected', subjectLabelItemSelectedHandler);

}

function getMultiAutoCompleteList(fieldName){ 

 var subjectLocal = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
 
    prefetch: {
      url: '/dc/get_data/get_dams_data/get_dams_data?q='+fieldName,
            
      filter: function(list) {
        return $.map(list, function(item) { return { value: item.label }; });
      }
    }
  });
 
var subjectLOC = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
        url:'/dc/qa/search/loc/subjects?q=%QUERY',
       
        filter: function(list) {
        return $.map(list, function(item) { return { value: item.label }; });
        }
     }  

  });

  subjectLocal.initialize();
  subjectLOC.initialize();
  
   
  $('#subjectField .typeahead').typeahead(
  {
  hint: true,
  highlight: true,
  minLength: 2
  }, 
  {
    name: 'subject-local',
    displayKey: 'value',
    source: subjectLocal.ttAdapter(),
    templates: {
    header: '<h4 class="subject-name">DAMS</h4>'
    }
   },
  {
    name: 'subject-LOC',
    displayKey: 'value',
    source: subjectLOC.ttAdapter(),
    templates: {
    header: '<h4 class="subject-name">LOC</h4>'
    }
   });

  var eleValue = $('.eleTypeahead');

  var itemSelectedHandler = function (eventObject, suggestionObject, suggestionDataset) {
        eleValue.val(suggestionObject.value);
     };

    $('#subjectField .typeahead').on('typeahead:selected', itemSelectedHandler);

}

function getSingleAutoCompleteList(){ 

var subjectLOC = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
        url:'/dc/qa/search/loc/subjects?q=%QUERY',
       
        filter: function(list) {
        return $.map(list, function(item) { return { value: item.label }; });
        }
     }  

  });

  subjectLOC.initialize();
  
  $('#subjectField .typeahead').typeahead(
  {
  hint: true,
  highlight: true,
  minLength: 2
  },
  {
    name: 'subject-LOC',
    displayKey: 'value',
    source: subjectLOC.ttAdapter(),
    templates: {
    header: '<h4 class="subject-name">LOC</h4>'
    }
   });

  var eleValue = $('.eleTypeahead');

  var itemSelectedHandler = function (eventObject, suggestionObject, suggestionDataset) {
        eleValue.val(suggestionObject.value);
     };

    $('#subjectField .typeahead').on('typeahead:selected', itemSelectedHandler);

}

var complexSubjectIdArray = new Array();

function getName(type,q,location)
{
  $.get(baseURL+"/get_name/get_name?formType="+type+"&q="+q,function(data,status){
    $(location).html(data);
  });  
}

function getTypeaheadFields(linkTag,formType,location,fieldId,typeName,selectedValue,selectedLabel)
{  
  
  var q = null;
  var fieldName = null;
  var typeGet = null;
  var reg = null;
  
  //For edit field
  if (typeof linkTag == "string") {
    q = linkTag;
    fieldName = typeName+"URI";
  } 
  // For new field
  else {
    q = linkTag.value;
    fieldName = firstToLowerCase(q);
  }

  if (typeName == 'simpleSubject') {
    typeGet = "subject";
    reg = "newSimpleSubjects";
  }
  else if (typeName == 'creator') {
    typeGet = "creator";
    reg = "newCreator";
  }
  
 // new http://localhost:3000/get_data/get_subject/get_subject?selectedValue=undefined&fieldId=0&fieldName=builtWorkPlace&formType=dams_object&q=BuiltWorkPlace
 // edit http://localhost:3000/get_data/get_subject/get_subject?selectedValue=xx00000174&fieldId=0&fieldName=simpleSubjectURI&formType=dams_object&q=Topic
  url = baseURL+"/get_"+typeGet+"/get_"+typeGet+"?selectedValue="+selectedValue+"&selectedLabel="+selectedLabel+"&fieldId="+fieldId+"&fieldName="+fieldName+"&formType="+formType+"&q="+q;
  
  if(q != null && q.length > 0) {
    $.get(url,function(data,status){
      var new_id = new Date().getTime();
      var regexp = null;
        data = data.replace("attributes_"+fieldId+"_id","attributes_"+new_id+"_id");
        data = data.replace("attributes]["+fieldId+"][id]","attributes]["+new_id+"][id]");

        data = data.replace("attributes_"+fieldId+"_label","attributes_"+new_id+"_label");
        data = data.replace("attributes]["+fieldId+"][label]","attributes]["+new_id+"][label]");
     
        regexp = new RegExp("newClassName", "g");
        data = data.replace(regexp,new_id); 
      if(location != null && location.length > 0)
        $(location).html(data);
      else
        $(linkTag).parent().before(data);
      
      if(typeName == 'simpleSubject' || typeName == 'creator')
      {
        if(selectedValue ==null)
        {
        var elementID= formType+"_"+fieldName+"_attributes_"+new_id+"_id";
        var elementLabel= formType+"_"+fieldName+"_attributes_"+new_id+"_label"
        getAutocompleteList_callback(formType,fieldName,elementID,elementLabel);
        }
        else{
          var elementID= new_id+"Id";
         var elementLabel= new_id+"Label";
        getAutocompleteList_callback(formType,q,elementID,elementLabel);
        }
      }
    }); 
  }
}


function getEditTypeaheadFields(linkTag,formType,location,fieldId,typeName)
{  
  var q = linkTag.value;
  var typeGet = null;
  var reg = null;
  var fieldName = null;
  var url = null;
  var selectedValue = "0";

  if (typeName == 'simpleSubject') {
    typeGet = "subject";
    reg = "newSimpleSubjects";
  }
  else if (typeName == 'creator') {
    typeGet = "creator";
    reg = "newCreator";
  }
  
  fieldName = typeName+"URI";

  //http://localhost:3000/get_data/get_subject/get_subject?fieldName=simpleSubjectURI&formType=dams_object&q=BuiltWorkPlace
  url = baseURL+"/get_"+typeGet+"/get_"+typeGet+"?selectedValue="+selectedValue+"&fieldName="+fieldName+"&formType="+formType+"&q="+q;
  
  
  if(q != null && q.length > 0) {
    $.get(url,function(data,status){
      var new_id = new Date().getTime();
      var regexp = new RegExp("newClassName", "g");
      data = data.replace(regexp,new_id);
      if(location != null && location.length > 0)
        $(location).html(data); 

      if(typeName == 'simpleSubject' || typeName == 'creator')
      {
        var elementID= new_id+"Id";
        var elementLabel= new_id+"Label";
        getAutocompleteList_callback(formType,q,elementID,elementLabel);
      }
    }); 
  }
}


function getDynamicFields(link,type,location,fieldId,typeName,selectedValue,relationship,selectedRole)
{  
  var q = null;
  var fieldName = null;
  var typeGet = null;
  var reg = null;
  
  if (typeof link == "string") {
    q = link;
    fieldName = typeName+"URI";
  } else {
    q = link.value;
    fieldName = firstToLowerCase(q);
  }
  if (typeName == 'simpleSubject') {
    typeGet = "subject";
    reg = "newSimpleSubjects";
  }
  else if (typeName == 'creator') {
    typeGet = "name";
    reg = "newCreator";
  }
  else if (typeName == 'relationshipName') {
    typeGet = "name";
    reg = "newRelationship";
  }
  else if (typeName == 'rightsHolder') {
    typeGet = "name";
    reg = "newRightsHolder";
  }
  if (relationship == "true") {
    url = baseURL+"/get_"+typeGet+"/get_"+typeGet+"?selectedRole="+selectedRole+"&relationship="+relationship+"&selectedValue="+selectedValue+"&fieldId="+fieldId+"&fieldName="+fieldName+"&formType="+type+"&q="+q;
  }
  else {
    url = baseURL+"/get_"+typeGet+"/get_"+typeGet+"?selectedValue="+selectedValue+"&fieldId="+fieldId+"&fieldName="+fieldName+"&formType="+type+"&q="+q;
  }
  

  
  if(q != null && q.length > 0) {
    $.get(url,function(data,status){
      var new_id = new Date().getTime();
      var regexp = null;
      if (relationship == "true")
      {      
        regexp = new RegExp("attributes_"+fieldId, "g");
        var tmp = "attributes]["+fieldId+"]";
        data = data.replace(regexp,"attributes_"+new_id);
        data = data.split(tmp).join("attributes]["+new_id+"]");
      }
      else
      {
        data = data.replace("attributes_"+fieldId,"attributes_"+new_id);
        data = data.replace("attributes]["+fieldId+"]","attributes]["+new_id+"]");
      }
      regexp = new RegExp("newClassName", "g");
      data = data.replace(regexp,new_id); 
      if(location != null && location.length > 0)
        $(location).html(data);
      else
        $(link).parent().before(data);
       
    }); 
  }

  
}

function getEditDynamicFields(link,type,location,typeName)
{  
  var q = link.value;
  var typeGet = null;
  var reg = null;
  var fieldName = null;
  var url = null;

  if (typeName == 'simpleSubject') {
    typeGet = "subject";
    reg = "newSimpleSubjects";
  }
  else if (typeName == 'creator') {
    typeGet = "name";
    reg = "newCreator";
  }
  else if (typeName == 'relationshipName') {
    typeGet = "name";
    reg = "newRelationship";
  }   
  else if (typeName == 'rightsHolder') {
    typeGet = "name";
    reg = "newRightsHolder";
  }

  fieldName = typeName+"URI";

  if (typeName == 'relationshipName'){
    url = baseURL+"/get_"+typeGet+"/get_"+typeGet+"?&relationship=true&fieldName="+fieldName+"&formType="+type+"&q="+q;   
  }
  else {
    url = baseURL+"/get_"+typeGet+"/get_"+typeGet+"?fieldName="+fieldName+"&formType="+type+"&q="+q;
  }
  
  if(q != null && q.length > 0) {
    $.get(url,function(data,status){
      var new_id = new Date().getTime();
      var regexp = new RegExp("newClassName", "g");
      data = data.replace(regexp,new_id);
      if(location != null && location.length > 0)
        $(location).html(data); 
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
    fieldId = "";
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
          
  removeEmptyFields();    
    return true; 
}

function remove_fields(link) {
  $(link).closest(".fields").remove();
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    //var regexp = new RegExp("new_" + association, "g");
    var regexp = new RegExp("newClassName", "g");
    content = content.replace("newClassName",new_id);
    content = content.replace("new_",new_id);
    if(association == "complexSubject") {
      content = content.replace("complexSubjectId",new_id);
      complexSubjectIdArray.push(new_id);
    }   
    $(link).parent().before(content.replace(regexp, new_id));
}

function add_dynamic_fields(link, content, className) {
    var new_id = new Date().getTime();
    //var regexp = new RegExp("simpleSubject", "g");
    var regexp = new RegExp("new" + className, "g");
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
							 ["Lithology","dams_lithologies"], ["Series","dams_series"], ["Cruise","dams_cruises"], ["Anatomy","dams_anatomies"],
						  	 ["Occupation","mads_occupations"], ["ScientificName","dams_scientific_names"], ["StylePeriod", "dams_style_periods"], 
						  	 ["Technique","dams_techniques"], ["Temporal","mads_temporals"], ["Topic","mads_topics"],
							 ["ConferenceName","mads_conference_names"],["Name","mads_names"],["PersonalName","mads_personal_names"],
							 ["CorporateName","mads_corporate_names"],["FamilyName","mads_family_names"],["role","mads_authority"],
							 ["RightsHolderConference", "mads_conference_names"],["RightsHolderCorporate", "mads_corporate_names"],
             				 ["RightsHolderFamily", "mads_family_names"],["RightsHolderName", "mads_names"], ["RightsHolderPersonal", "mads_personal_names"]];
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

function removeEmptyFields() {
  var inputElements= document.getElementsByClassName("input-block-level");
  var fieldId = "";
  var inputElementsArray = new Array();
  for (var i=0;i<inputElements.length;i++) {
    if(inputElements[i].value != null && inputElements[i].value.length < 1) {     
      fieldId = "#"+inputElements[i].id;
      inputElementsArray.push(fieldId);
    }
  }

  inputElements= document.getElementsByClassName("nonSort");
  for (var i=0;i<inputElements.length;i++) {
    if(inputElements[i].value != null && inputElements[i].value.length < 1) {     
      fieldId = "#"+inputElements[i].id;
      inputElementsArray.push(fieldId);
    }
  }
  
  inputElements= document.getElementsByClassName("input-drop-down");
  for (var i=0;i<inputElements.length;i++) {
    if(inputElements[i].value != null && inputElements[i].value.length < 1) {     
      fieldId = "#"+inputElements[i].id;
      inputElementsArray.push(fieldId);
    }
  } 
 
  inputElements= document.getElementsByTagName("select");
  for (var i=0;i<inputElements.length;i++) {
    if(inputElements[i].value != null && inputElements[i].value.indexOf("Create New") >= 0) {     
      fieldId = "#"+inputElements[i].id;
      inputElementsArray.push(fieldId);
    }
    if(inputElements[i].value != null && inputElements[i].value.length < 1) {     
      fieldId = "#"+inputElements[i].id;
       inputElementsArray.push(fieldId);
    }   
  }
      
  for (var i=0;i<inputElementsArray.length;i++) {
    $(inputElementsArray[i]).remove();
  }
}


