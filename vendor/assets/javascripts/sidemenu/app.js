$('#menu_button').toggle( 
    function() {
        $('#home').animate({ left: 100 }, 'slow', function() {
            $('#menu_button').html('Close');
        });
    }, 
    function() {
        $('#home').animate({ left: 0 }, 'slow', function() {
            $('#menu_button').html('Menu');
        });
    }
);

 // Menu behaviour
 $(document).ready(function(){

 });
    
