
function getName(type,q,location)
{
  $.get(baseURL+"/get_name/get_name?formType="+type+"&q="+q,function(data,status){
    $(location).html(data);
  });	 
}

function getSimpleSubject(type,q,location)
{
  $.get(baseURL+"/get_subject/get_subject?formType="+type+"&q="+q,function(data,status){
    $(location).html(data);
  });	 
}
