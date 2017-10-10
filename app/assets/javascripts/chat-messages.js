jQuery(document).ready(function($) {
	$('.new_message').submit(function(e) {
	  e.preventDefault();
	  this.submit();
	  $('.body-input').val(''); // blank the input after submit form.
	});
});