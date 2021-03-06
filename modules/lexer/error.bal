# Represents an error caused by the lexical analyzer.
public type LexicalError distinct error<ReadErrorDetails>;

# Represents the error details when reading a TOML document.
#
# + line - Line at which the error occurred  
# + column - Column at which the error occurred  
# + actual - The actual violated yaml string  
# + expected - Expected yaml strings for the violated string  
# + context - Context in which the error occurred
public type ReadErrorDetails record {|
    int line;
    int column;
    json actual;
    json? expected = ();
    string? context = ();
|};

# Generate an error message based on the template,
# "Invalid character '${char}' for a '${token}'"
#
# + state - Current lexer state  
# + context - Context of the lexeme being scanned
# + return - Generated error message
function generateInvalidCharacterError(LexerState state, string context) returns LexicalError {
    string? currentChar = state.peek();
    string message = string `Invalid character '${currentChar ?: "<end-of-line>"}' for a '${context}'`;
    return error(
        message,
        line = state.row(),
        column = state.column(),
        actual = currentChar,
        context = context
    );
}

function generateLexicalError(LexerState state, string message) returns LexicalError =>
    error(
        message + ".",
        line = state.row(),
        column = state.column(),
        actual = state.peek()
    );
