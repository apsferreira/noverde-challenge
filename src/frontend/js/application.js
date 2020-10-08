$('select').not('.disabled').formSelect();
    
$('.money').maskMoney({
    prefix: "R$ ",
    decimal: ",",
    thousands: "."
});

$('.cpf').mask("000.000.000-00", {reverse: false});

$('.btn-new').click(function() {
    const data = {
        name:$('#name').val(), 
        cpf:$('#cpf').val(), 
        birthdate:$('#birthdate').val(), 
        amount:$('#amount').val(), 
        terms:$('#terms').val(), 
        income:$('#income').val()
    }

    $.post(
        'http://localhost:4566/loan',
        data,
        function(data, status){
            console.log(`${data} and status ${status}`)
        }
    )
});
