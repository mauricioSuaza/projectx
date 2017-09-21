/* ---------------------------------------------

Javascript

--------------------------------------------- */
$(document ).ready(

  (function($) {
      "use strict";


      //Menu
      $("#menu").slicknav({
          label:'<div class="hamburger-menu"></div>',
          prependTo:'.right-links'
      });
      /////////////////////////////////////////////////////////////End


      //Adds a .scrolled class after user scrolls
      $(window).on("scroll touchmove", function() {
        $("body").toggleClass('scrolled', $(document).scrollTop() > 0);
      });
      /////////////////////////////////////////////////////////////End

      //comment carousel
      $(".comment-carousel").slick({
          dots: false,
          arrows: false,
          infinite: true,
          speed: 400,
          fade: true,
          autoplay: true,
          cssEase: 'linear'
      });

      //hero-slider carousel
      $(".hero-slider").slick({

          dots: false,
          arrows: true,
          infinite: true,
          speed: 800,
          fade: true,
          autoplay: true,
          cssEase: 'linear',
          responsive: [{
              breakpoint: 992,
              settings: {
                  arrows: false
              }
          }]
      });

      //Toggle
      var allToggles = $(".toggle > dd").hide();
      $(".toggle > dt > a").click(function() {
          if ($(this).hasClass("active")) {
              $(this).parent().next().slideUp("easeOutExpo");
              $(this).removeClass("active");
          } else {
              var current = $(this).parent().next("dd");
              $(this).addClass("active");
              $(this).parent().next().slideDown("easeOutExpo");
          }
          return false;
      });
      /////////////////////////////////////////////////////////////End


      //Accordion
      var allPanels = $(".accordion > dd").hide();
      allPanels.first().slideDown("linear");
      $(".accordion > dt > a").first().addClass("active");
      $(".accordion > dt > a").click(function() {
          var current = $(this).parent().next("dd");
          $(".accordion > dt > a").removeClass("active");
          $(this).addClass("active");
          allPanels.not(current).slideUp("easeInExpo");
          $(this).parent().next().slideDown("linear");
          return false;
      });
      /////////////////////////////////////////////////////////////End



  })(jQuery));
