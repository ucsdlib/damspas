
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
}


$(document).ready(function(){
  var counts = [];

  for(var i = 1; i <= 5; ++i) {
    counts[i] = 0;
  }

  $('i').click(function (e) {
    var tempScrollTop = $(window).scrollTop();

    if (e.target) {
      if(e.target.id.substring(0,4) == 'plus') {
        add(e.target.id.substring(4,5));
      }
      else {
        subtract(e.target.id.substring(5,6));
      }
    }

    $(window).scrollTop(tempScrollTop);
    return false;
  });

  
});