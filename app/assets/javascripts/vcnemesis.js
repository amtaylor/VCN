$(document).ready(function(){
	$(".alert").alert();
});

$(document).ready(function(){  //pre-load images to get rid of loading 'flash'
	$.fn.preload = function() {
	    this.each(function(){
	        $('<img/>')[0].src = this;
	    });
	}

	//This is to preload certain images
	$([ BASE_URL + 'images/SocNet2(float)bw(red-eyes).png' ]).preload();

	/* BASE_URL + 'images/rw(flip,bw).jpg', BASE_URL + 'images/rw(flip).jpg' , */ 
	

});


// js for homepage company-form

$(document).ready(function(){ 

	$('#homepage-company-form-button').click(function () {

		var $btn = $(this)
	    $btn.button('...');

	    $('#homepage-add-companies').css("display","none");

	    var targetOffset = $("#main-section").offset().top - 50;

	    $('html, body').animate({
	        scrollTop: targetOffset
	    }, 3000);

	    $('#main-section').addClass("loading"); //starts the 'loading' animation

	    // $( "#company-form #companyName1" ).focus(); //this throws off how far down the window auto scrolls

	});

	var $form = $('form#homepage-company-form');

    $form.submit(function(){
      	$.get($(this).attr('action'), $(this).serialize(), function(response){ //this is called when the form is submitted
    
            $( '#homepage-company-form' ).each(function(){
			    this.reset();
			}); //This resets the competitor field in the form

            $('#homepage-company-form-button').button('reset'); //this resets the search button;	

           	if (response.status === "Company Doesn't Exist") { //no need to parse this as JSON because its already a javascript object...
				
				$(".comp-fail").show().delay(8000).fadeOut();

				$('#main-section').removeClass("loading"); //takes away loading animation

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

		    		$('#main-section').removeClass("loading"); //takes away loading animation

					$(".comp-success").show().delay(5000).fadeOut();

					$( "#company-form #companyName1" ).focus();

					$(".signup1").show();// invites user to sign up-- this should probably only pop up the first time

		    	});
		    };	

      	});
      return false;
   	});

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
				
				$(".comp-fail").show().delay(8000).fadeOut();
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

	$('#musicstreaming').click( function() {
		compa = 'Beats By Dr Dre';
		compb = 'Pandora';
		compc = 'Rdio';
		compd = 'Spotify';
		addsamplecomps();
	});

	$('#bitcoin').click( function() {
		compa = 'Bitpay';
		compb = 'nfc direct';
		compc = 'Coinbase';
		compd = 'Payward';
		addsamplecomps();
	});


	var addsamplecomps = function () {

		$('body').addClass("loading"); //starts the 'loading' animation

		var getInvestors = function(comp,desres){
		    var url= BASE_URL + '/companies?name=' + comp;
			$.get(url);
			desres.resolve();
			console.log(desres);
		}

		var aa = $.Deferred();
		var bb = $.Deferred();
		var cc = $.Deferred();
		var dd = $.Deferred();

		getInvestors(compa,aa);
		getInvestors(compb,bb);
	    getInvestors(compc,cc);
	    getInvestors(compd,dd);

		var a = $.Deferred();
		var b = $.Deferred();
		var c = $.Deferred();
		
	    $.when(aa, bb, cc, dd).done(function(){ //this waits until everything has been updated to take away loading animation

    		$.get(BASE_URL + '/companylist', $(this).serialize(), function(response){
	            	
		    	$('.competitor-list').replaceWith(response);
		    	a.resolve();

		    	console.log("comp-list");

		    });  //updates companies

		    $.get(BASE_URL + '/investorlist', $(this).serialize(), function(response){
		    	
		    	$('.investors').replaceWith(response);
		    	b.resolve();

		    });  //updates investors

		    $.get(BASE_URL + '/companylistfulldata', $(this).serialize(), function(response){
		    	
		    	$('.competitor-list-fulldata').replaceWith(response);
		    	c.resolve();

		    });  //updates investors

    	});


        $.when(a, b, c).done(function(){ //this waits until everything has been updated to take away loading animation

    		$('body').removeClass("loading"); //takes away loading animation

    	});

	}

});


$(document).ready(function(){

	$(window).scroll(function () {  //parallax effects stuff
	   if ($(window).scrollTop() > 0 ) {
	   	//$('.info2').css( "background-image", "url('../images/rw(flip,bw).jpg')" );
		$('.info3').css( "background-image", "url('../images/SocNet2(float)bw(red-eyes).png')" );
	   	$('.jt-description').hide();
	   	$('.rw-description').hide();
	   }
	   else {
		//$('.info2').css( "background-image", "url('../images/rw(flip).jpg')" );
		$('.info3').css( "background-image", "url('../images/SocNet2(float)bw.png')" );
		$('.jt-description').show();
		$('.rw-description').show();
	   }
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


	 