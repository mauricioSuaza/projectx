$(document).ready(function() {
var count = 0;

$(window).resize(function(){

     if ($(window).width() <= 768) {

       $(".sidebar").animate({
           width: "0%"
       }, 500);
       $(".main-panel").animate({
           width: "100%"
       }, 500);
     }

     if ($(window).width() <= 1000 && $(window).width() > 769) {

       $(".sidebar").animate({
           width: "30%"
       }, 500);
       $(".main-panel").animate({
           width: "70%"
       }, 500);

       $("#close").addClass('hide');
     }

     if ($(window).width() > 1001) {

       $(".sidebar").animate({
           width: "20%"
       }, 500);
       $(".main-panel").animate({
           width: "80%"
       }, 500);

       $("#close").addClass('hide');
     }

});

  $(".own-btn-nav").click(function() {
    count++;
       if ($(window).width() <= 768) {
         console.log("estoy haciendo click");

         var isEven = function(someNumber) {
             return (someNumber % 2 === 0) ? true : false;
         };
         if (isEven(count) === false) {
             $(".sidebar").animate({
                 width: "100%"
             }, 500);
             $(".main-panel").animate({
                 width: "0%"
             }, 500);
             $("#close").removeClass('hide');
           }
           $("#close").click(function() {
             $(".sidebar").animate({
                 width: "0%"
             }, 500);
             $(".main-panel").animate({
                 width: "100%"
             }, 500);
           });

       }

       if ($(window).width() <= 1000 && $(window).width() > 769) {
         console.log("estoy haciendo click");

         var isEven = function(someNumber) {
             return (someNumber % 2 === 0) ? true : false;
         };
         if (isEven(count) === false) {
             $(".sidebar").animate({
                 width: "30%"
             }, 500);
             $(".main-panel").animate({
                 width: "70%"
             }, 500);

           } else if (isEven(count) === true) {
                 $(".sidebar").animate({
                     width: "0"
                 }, 500);
                 $(".main-panel").animate({
                     width: "100%"
                 }, 500);
             }
       }

       if ($(window).width() > 1000){
         console.log("estoy haciendo click");

         var isEven = function(someNumber) {
             return (someNumber % 2 === 0) ? true : false;
         };
         if (isEven(count) === false) {
             $(".sidebar").animate({
                 width: "20%"
             }, 500);
             $(".main-panel").animate({
                 width: "80%"
             }, 500);

           } else if (isEven(count) === true) {
                 $(".sidebar").animate({
                     width: "0"
                 }, 500);
                 $(".main-panel").animate({
                     width: "100%"
                 }, 500);
             }
       }

  });

    var panels = $('.user-infos');
    var panelsButton = $('.dropdown-user');
    panels.hide();

    //Click dropdown
    panelsButton.click(function() {
        //get data-for attribute
        var dataFor = $(this).attr('data-for');
        var idFor = $(dataFor);

        //current button
        var currentButton = $(this);
        idFor.slideToggle(400, function() {
            //Completed slidetoggle
            if(idFor.is(':visible'))
            {
                currentButton.html('<i class="icon-chevron-up text-muted"></i>');
            }
            else
            {
                currentButton.html('<i class="icon-chevron-down text-muted"></i>');
            }
        })
    });


    $('[data-toggle="tooltip"]').tooltip();


});
