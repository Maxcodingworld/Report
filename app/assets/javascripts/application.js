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

	$('.table1').change(function(){
		// console.log("hi");
		$.get('/reports/association?table_name='+$(this).find("option:selected").text(),function(data){
	    	// console.log(data);
	    	// $('.table2').html();
	    	$('.table2').last().html(data);
	    	});
	});

	$('#report_maintable_attributes_table').change(function(){
	    // var model_name = $(this).val();
	    var model = $(this).find("option:selected").text();
	    // var model = $('#report_maintable_attributes_table option:selected').text();
	    // alert(model);
	    // alert("hi");
	    // console.log("hi");
	    var size = $('.table1 option').size();
	    if(size == 1)
	    {
	     $(".table1").append($("<option></option>")
         .attr("value",model)
         .text(model));
	    }
	    else if(size == 2)
	    {
          document.getElementById("report_jointables_attributes_0_table1").options[1].text = model;
   	      document.getElementById("report_jointables_attributes_0_table1").options[1].value = model;
	    }
	     

	    // var size = $('.table1').size();
	    // alert(size);
	    // document.getElementById("report_jointables_attributes_0_table1").options[0].text = model;
	    // document.getElementById("report_jointables_attributes_0_table1").options[0].value = model_name;
	    // document.getElementById("report_jointables_attributes_0_id").value = model;
	    // $.get('/reports/association?table_name='+$(this).find("option:selected").text(),function(data){
	    // 	// console.log(data);
	    // 	// $('#report_jointables_attributes_0_id').html();
	    // 	$('#report_jointables_attributes_0_id').html(data);
	    // 	});
	    // document.getElementById("report_jointables_attributes_0_table1").text = model;
	     // $("#report_jointables_attributes_0_table1").append($("<option></option>")
         // .attr("value",model_name)
         // .text(model)); 
	    // $("#report_jointables_attributes_0_table1").append("<option value=model_name>hi</option>")
	});
});




$(document).on('nested:fieldAdded:jointables', function(click){
	
	var table1_val = $('.table1').val();

	// $('.table1 option:contains("table1 or maintable")').test('');
	// var table1_text = $('.table1 pseudoclass');
	// var table1_text = $('.table1').first().find("option:selected").text();
	var table2_val = $('.table2').val();
	console.log(table1_val);
	console.log(table2_val);
	// var table2_text = $('.table2').first().find("option:selected").text();
	$('.table1').last().append($('<option>', {
    value: table1_val,
    text: table1_val
}));
	$('.table1').last().append($('<option>', {
    value: table2_val,
    text: table2_val
}));
	$('.table1').change(function(){
		// console.log("hi");
		$.get('/reports/association?table_name='+$(this).find("option:selected").text(),function(data){
	    	// console.log(data);
	    	// $('.table2').html();
	    	$('.table2').last().html(data);
	    	});
	});
});