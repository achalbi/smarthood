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
    
/*$().ready(function() {

    var errors="";
    
    $('#upload').mfupload({
        
        type        : '',   //all types
        maxsize     : 2,
        post_upload : "./upload.php",
        folder      : "./",
        ini_text    : "Drag your file to here or click (max: 2MB each)",
        over_text   : "Drop Here",
        over_col    : 'white',
        over_bkcol  : 'green',
        
        init        : function(){       
            $("#uploaded").empty();
        },
        
        start       : function(result){     
            $("#uploaded").append("<div id='FILE"+result.fileno+"' class='files'>"+result.filename+"<div id='PRO"+result.fileno+"' class='progress'></div></div>"); 
        },

        loaded      : function(result){
            $("#PRO"+result.fileno).remove();
            $("#FILE"+result.fileno).html("Uploaded: "+result.filename+" ("+result.size+")");           
        },

        progress    : function(result){
            $("#PRO"+result.fileno).css("width", result.perc+"%");
        },

        error       : function(error){
            errors += error.filename+": "+error.err_des+"\n";
        },

        completed   : function(){
            if (errors != "") {
                alert(errors);
                errors = "";
            }
        }
    });     
})*/