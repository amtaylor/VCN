$(document).ready(function(){
	$(".alert").alert();
});


//This is some JS to not leave the page when the form is submitted (I think)

$(document).ready(function(){
	$('#company-form-button').click(function () {
		console.log('button pressed!');
	    var $btn = $(this)
	    $btn.button('loading');

	    $('#companyName1').hide(); //hides the search box when button is pressed

		$('body').addClass("loading"); //starts the 'loading' animation

  	});


});


$(document).ready(function(){
   var $form = $('form#company-form');
   $form.submit(function(){
      $.get($(this).attr('action'), $(this).serialize(), function(response){ //this is called when the form is submitted
            
            console.log('company submitted!'); //this just prints a confirmation to the console that the company was added

            $('#companyName1').show(); //unhides the search box after successful submission

            $( '#company-form' ).each(function(){
			    this.reset();
			}); //This resets the competitor field in the form

            $('#company-form-button').button('reset'); //this resets the search button;	

           	if (response.status === "Company Doesn't Exist") { //no need to parse this as JSON because its already a javascript object...
				
				$('body').removeClass("loading"); //takes away loading animation
				
				$(".comp-fail").show().delay(10000).fadeOut();
			}
			
			else {

				var a = $.Deferred();
				var b = $.Deferred();
				var c = $.Deferred();

	            $.get(BASE_URL + '/companylist', $(this).serialize(), function(response){
	            	
	            	$('.competitor-list').replaceWith(response);
	            	a.resolve();

	            	//console.log(response);

	            });  //updates companies

	            $.get(BASE_URL + '/investorlist', $(this).serialize(), function(response){
	            	
	            	$('.investors').replaceWith(response);
	            	b.resolve();

	            });  //updates investors

	            $.get(BASE_URL + '/companylistfulldata', $(this).serialize(), function(response){
	            	
	            	$('.competitor-list-fulldata').replaceWith(response);
	            	c.resolve();

	            });  //updates investors

		    	$.when(a, b, c).done(function(){ //this waits until everything has been updated to take away loading animation

		    		$('body').removeClass("loading"); //takes away loading animation


					$(".comp-success").show().delay(5000).fadeOut();

					$(".signup1").show();// invites user to sign up-- this should probably only pop up the first time

		    	});
		    };	

      });
      return false;
   });
}); //This function sends the request without leaving the page


$(document).ready(function(){
	$('#signup1-close').click(function () {
		console.log('signup closed');

		$(".signup1").remove(); // This removes the 'sign up now!' prompt the first time the person x's out of it
	    
  	});
});




$(document).ready(function(){

	$('#photoshare').click(function () {

		$('body').addClass("loading"); //starts the 'loading' animation

		console.log(BASE_URL);

		var getInvestors = function(comp){
		    var url= BASE_URL + '/companies';
			$.post(url, {company_name: comp});
		}

		$.when( getInvestors('OKCupid'),
	        getInvestors('Zoosk'),
	        getInvestors('HowAboutWe'),
	        getInvestors('Grouper')
	      	).done(function(){

	      		$.get(BASE_URL + '/companylist', $(this).serialize(), function(response){
					            	
					$('.competitor-list').replaceWith(response);

				}); //updates companies

				$.get(BASE_URL + '/investorlist', $(this).serialize(), function(response){
					
					$('.investors').replaceWith(response);

				}); //updates investors


				$('body').removeClass("loading"); //takes away loading animation


	    	});

	});

});


	 







/* not used:

$(document).ready(function(){ 
	$('.comp-close').click(function () {
		$.ajax({
		    url: 'http://localhost:3000/companies',
		    type: 'DELETE',
		    success: function(response) {
		       	
		       	$.get('http://localhost:3000/companylist', $(this).serialize(), function(response){
	            	
	            	$('.competitor-list').replaceWith(response);

	            	//console.log(response);

	            }); //updates companies

	            $.get('http://localhost:3000/investorlist', $(this).serialize(), function(response){
	            	
	            	$('.investors').replaceWith(response);

	            }); //updates investors
		    }
		});
	});
}); //Deletes companies when 'x' is pressed
*/


	 