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
var arrofgroupattribute = []
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
	if($('.table_attribute').size() == 1 && $('.table2').size() > 0)
	{
		arroftables.push($('.table2').last().val());
	}
	arroftables = arroftables.unique();

	$.get('/reports/attributes?table_name='+arroftables,function(data){
	    	$('.table_attribute').last().html(data);
	});
});


$(document).on('nested:fieldAdded:grouptables', function(click){
	arroftables.push($('#report_maintable_attributes_table').find("option:selected").text());
	if($('.table').size() == 1 && $('.table2').size() > 0)
	{
		arroftables.push($('.table2').last().val());
	}
	arroftables = arroftables.unique();
	for(var i=0;i<arroftables.length;i++)
	{
		$('.table').last().append($('<option>', {
	    value: arroftables[i],
	    text: arroftables[i]
	     }));
	}
	$('.table').change(function(){
		$.get('/reports/attributes?table_name='+$(this).val(),function(data){
		    	$('.group_table_attribute').last().html(data);
		});	
	});
	
});



$(document).on('nested:fieldAdded:havingtables', function(click){

	arroftables.push($('#report_maintable_attributes_table').find("option:selected").text());
	if($('.having_table_attribute').size() == 1 && $('.table2').size() > 0)
	{
		arroftables.push($('.table2').last().val());
	}
	arroftables = arroftables.unique();
	for(var i=0;i<$('.group_table_attribute').size();i++)
	{
			arrofgroupattribute.push($('.group_table_attribute').eq(i).val());		
	}

	$.get('/reports/attributes?table_name='+arroftables,function(data){
	    	$('.having_table_attribute').last().html(data);
	});

    $('.having_table_attribute').change(function(){
		arrkeys_values = ["sum","max","min","count","avg"]
$('.having_aggregate_function').eq($('.having_aggregate_function').size() - 1).find("option[value!='aggregate_function']").each(function(){ 
        $(this).remove();   
    });
    
        for (var i =0 ;i<arrkeys_values.length;i++){ 
			$('.having_aggregate_function').last().append($('<option>', {
			    value: arrkeys_values[i]+ '(' + $(this).val() + ')',
			    text: arrkeys_values[i]
		    }));
        }
        
		if($.inArray($(this).val(),arrofgroupattribute) >= 0)
		{
			$('.having_aggregate_function').last().append($('<option>', {
			    value: $(this).val(),
			    text: "None"
		    }));
	            
		}
		
	});

});



$(document).on('nested:fieldAdded:selecttables', function(click){

	if($('.table').size() == 0)
	{
	    $('.select_aggregate_function').remove();
	   	$('.agg_function').remove();
	}

	arroftables.push($('#report_maintable_attributes_table').find("option:selected").text());
	if($('.select_table_attribute').size() == 1 && $('.table2').size() > 0)
	{
		arroftables.push($('.table2').last().val());
	}
	arroftables = arroftables.unique();
	for(var i=0;i<$('.group_table_attribute').size();i++)
	{
			arrofgroupattribute.push($('.group_table_attribute').eq(i).val());		
	}
	
	$.get('/reports/attributes?table_name='+arroftables,function(data){
	    	$('.select_table_attribute').last().html(data);
	});

    $('.select_table_attribute').change(function(){
		arrkeys_values = ["sum","max","min","count","avg"]
    
    $('.select_aggregate_function').eq($('.select_aggregate_function').size() - 1).find("option[value!='select_aggregate_function']").each(function(){ 
        $(this).remove();   
    });
        for (var i =0 ;i<arrkeys_values.length;i++){ 
			$('.select_aggregate_function').last().append($('<option>', {
			    value: arrkeys_values[i]+ '(' + $(this).val() + ')',
			    text: arrkeys_values[i]
		    }));
        }
        
		if($.inArray($(this).val(),arrofgroupattribute) >= 0)
		{
			$('.select_aggregate_function').last().append($('<option>', {
			    value: $(this).val(),
			    text: "None"
		    }));
	            
		}
		
	});

});



$(document).on('nested:fieldAdded:ordertables', function(click){
	arroftables.push($('#report_maintable_attributes_table').find("option:selected").text());
	if($('.order_table_attribute').size() == 1 && $('.table2').size() > 0)
	{
		arroftables.push($('.table2').last().val());
	}
	arroftables = arroftables.unique();
	console.log(arroftables);
	$.get('/reports/attributes?table_name='+arroftables,function(data){
	    	$('.order_table_attribute').last().html(data);
	});
});
