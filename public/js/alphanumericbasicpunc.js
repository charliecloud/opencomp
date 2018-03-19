$.validator.addMethod( "alphanumericbasicpunc", function( value, element ) {
    return this.optional( element ) || /^[a-z\d\-_\s'"]+$/i.test( value );
}, "Letters, numbers, and basic punctuation only please" );