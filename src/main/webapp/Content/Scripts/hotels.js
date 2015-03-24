/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
$(init);

function init() {
    $( "#tabs" ).tabs().addClass( "ui-tabs-vertical ui-helper-clearfix" );
    $( "#tabs li" ).removeClass( "ui-corner-top" ).addClass( "ui-corner-left" );
    $("#addHotelForm").hide();
    
    $("#addHotel").click(function(){
        $("#addHotelForm").show();
        $("#addHotel").hide();
    });
    
    $(".confirm").click(function(){
            return window.confirm("Are you sure you want to delete this Hotel?");
    });
    
    $("#formAdd").validate({
        rules: {
            hotelName: "required",
            streetAddress: "required",
            city: "required",
            state: "required",
            postalCode: "required"
        },
        messages: {
            hotelName: "Please enter a name for the hotel",
            streetAddress: "Please enter a street address",
            city: "Please enter a city",
            state: "Please enter a state",
            postalCode: "Please enter a postal code"
        }
    });
    
    $("#cancelAdd").on('click', function(){
        $("#addHotelForm").hide();
        $("#addHotel").show();
    });
};

