//= require jquery_nested_form
$(document).ready(function() {
	$('#mem_report_day_limit').change(function(){
	    var limit_id = $(this).val();

	    if(limit_id == 'custom')
	    {
	        $('#fromtodate').show();
	    }
	    else
	    {
	        $('#fromtodate').hide();
	    }

	});
});