//= require jquery_nested_form

Array.prototype.unique = function(){
    for(var i = 0; i < this.length; i++){
        if( this.indexOf(this[i], i+1) != -1 ){
            this.splice(i,1);
            i--;
        }
    }
    return this;
}

var arroftables = []

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



$(document).on('nested:fieldAdded:jointables', function(click){
	
	if($('.table1').size() > 1)
	{
		arroftables.push($('.table1').eq($('.table1').size() - 2 ).val());
	    arroftables.push($('.table2').eq($('.table2').size() - 2 ).val());
	}
	else if($('.table1').size() == 1)
	{
		arroftables.push($('#report_maintable_attributes_table').find("option:selected").text());
	}
	arroftables = arroftables.unique();
	for(var i=0;i<arroftables.length;i++)
	{
		$('.table1').last().append($('<option>', {
	    value: arroftables[i],
	    text: arroftables[i]
	     }));	
	}

	$('.table1').change(function(){
		$.get('/reports/association?table_name='+$(this).find("option:selected").text(),function(data){
	    	$('.table2').last().html(data);
	   	});
	});
	
});


$(document).on('nested:fieldAdded:wheretables', function(click){
	arroftables.push($('#report_maintable_attributes_table').find("option:selected").text());
	if($('.table_attribute').size() == 1)
	{
		arroftables.push($('.table2').last().val());
	}
		arroftables = arroftables.unique();
	$.get('/reports/attributes?table_name='+arroftables,function(data){
	    	$('.table_attribute').last().html(data);
	   	});
});




