$(document).ready(function() {
	//catch change placeholder text to match chosen search field option
	$('#dams-search').change(function(){
		$(".search_q").attr("placeholder", "For "+$('#dams-search option:selected').text()+"...");
	});
});