program
    -> expr {% id %}
    | assignment
    
assignment
    -> "let" _ identifier _ "=" _ expr {% (data) => { `env.${data[1]} = ${data[3]}` } %}
    
expr 
    -> literal {% id %}
    | identifier {% id %}
    | additive {% id %}
    | multiplicative {% id %}
    | function {% id %}
    | application
    
additive  
    -> multiplicative _ [+-] _ additive 
    {%
    (data) => {
        switch(data[2]){
            case "+"
                return data[0] + data[4]
            case "-"
                return data[0] - data[4]
        }
    }
    %}
    | multiplicative {% id %}
    
multiplicative
    -> number _ [x/] _ multiplicative
    {%
    (data) => {
        switch(data[2]){
            case "x"
                return data[0] * data[4]
            case "/"
                return data[0] / data[4]
        }
    }
    %}
    | number {% id %}
    
function 
    -> "lambda" _ identifier _ "." _ expr {% (data) => `${data[1]} => ${data[3]}` %}
    
application
    -> function _ expr
    
identifier 
    -> [a-z]:+ {% id %}
    
literal
    -> boolean
    | number {% id %}
    | string {% id %}
    
string -> "\"" characters "\"" {% x => x[1] %}

characters
    -> character {% id %}
    | character characters
    
character
    -> [a-zA-Z0-9]:+ {% id %}

boolean 
    -> "true" {% () => true %}
    | "false" {% () => false %}
    
number 
    -> digits "." digits
    | digits {% id %}
    
digits 
    -> digit 
    | digit digits {% id %}
    
digit 
    ->  [0-9]

_ -> [ \t]