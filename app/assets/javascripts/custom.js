/* <![CDATA[ */
$(function() {
  var input = document.createElement("input");
    if(('placeholder' in input)==false) { 
    $('[placeholder]').focus(function() {
      var i = $(this);
      if(i.val() == i.attr('placeholder')) {
        i.val('').removeClass('placeholder');
        if(i.hasClass('password')) {
          i.removeClass('password');
          this.type='password';
        }     
      }
    }).blur(function() {
      var i = $(this);  
      if(i.val() == '' || i.val() == i.attr('placeholder')) {
        if(this.type=='password') {
          i.addClass('password');
          this.type='text';
        }
        i.addClass('placeholder').val(i.attr('placeholder'));
      }
    }).blur().parents('form').submit(function() {
      $(this).find('[placeholder]').each(function() {
        var i = $(this);
        if(i.val() == i.attr('placeholder'))
          i.val('');
      })
    });
  }
});
/* ]]> */

$(document).ready(function(){
            $("a.fancybox-album").fancybox({
            padding    : 0,
            autoCenter :true,
            afterShow: function() { 
                    $(".header").hide();
                $('<div class="expander"></div>').appendTo(this.inner).click(function() {
                    $(document).toggleFullScreen();
                    $.fancybox.play( true );
                });

                $(".fancybox-title").wrapInner('<div />').show();
                
                $(".fancybox-wrap").hover(function() {
                    $(".fancybox-title").show();
                }, function() {
                    $(".fancybox-title").hide();
                });
            },
            afterClose: function() {
             $(document).toggleFullScreen();
                $(document).fullScreen(false);
                $(".header").show();
                $.fancybox.play( false );
            },
             helpers : {
                  title: {
                      type: 'over'
                  }
              },
            'transitionIn'  : 'elastic',
            'transitionOut' : 'elastic',
            'speedIn'   : 600, 
            'speedOut'    : 200, 
            'overlayShow' : false
          });

  
});
