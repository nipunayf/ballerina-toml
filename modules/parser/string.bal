import toml.lexer;

# Process multi-line basic string.
#
# + return - An error if the grammar rule is not made  
function multiBasicString(ParserState state) returns lexer:LexicalError|ParsingError|string {
    state.updateLexerContext(lexer:MULTILINE_BASIC_STRING);
    string lexemeBuffer = "";

    // Predict the next tokens
    check checkToken(state,[
        lexer:MULTILINE_BASIC_STRING_LINE,
        lexer:MULTILINE_BASIC_STRING_ESCAPE,
        lexer:MULTILINE_BASIC_STRING_DELIMITER,
        lexer:EOL
    ]);

    // Predicting the next tokens until the end of the string.
    while (state.currentToken.token != lexer:MULTILINE_BASIC_STRING_DELIMITER) {
        match state.currentToken.token {
            lexer:MULTILINE_BASIC_STRING_LINE => { // Regular basic string
                lexemeBuffer += state.currentToken.value
;
            }
            lexer:MULTILINE_BASIC_STRING_ESCAPE => { // Escape token
                state.updateLexerContext(lexer:MULTILINE_ESCAPE);
            }
            lexer:EOL => { // Processing new lines
                check state.initLexer("Expected to end the multi-line basic string");

                // Ignore new lines after the escape symbol
                if !(state.lexerState.context == lexer:MULTILINE_ESCAPE) {
                    lexemeBuffer += "\\n";
                }
            }
        }
        check checkToken(state,[
            lexer:MULTILINE_BASIC_STRING_LINE,
            lexer:MULTILINE_BASIC_STRING_ESCAPE,
            lexer:MULTILINE_BASIC_STRING_DELIMITER,
            lexer:EOL
        ]);
    }

    state.updateLexerContext(lexer:EXPRESSION_KEY);
    return lexemeBuffer;
}

# Process multi-line literal string.
#
# + return - An error if the grammar production is not made.  
function multiLiteralString(ParserState state) returns lexer:LexicalError|ParsingError|string {
    state.updateLexerContext(lexer:MULTILINE_LITERAL_STRING);
    string lexemeBuffer = "";

    // Predict the next tokens
    check checkToken(state,[
        lexer:MULTILINE_LITERAL_STRING_LINE,
        lexer:MULTILINE_LITERAL_STRING_DELIMITER,
        lexer:EOL
    ]);

    // Predicting the next tokens until the end of the string.
    while (state.currentToken.token != lexer:MULTILINE_LITERAL_STRING_DELIMITER) {
        match state.currentToken.token {
            lexer:MULTILINE_LITERAL_STRING_LINE => { // Regular literal string
                lexemeBuffer += state.currentToken.value;
            }
            lexer:EOL => { // Processing new lines
                check state.initLexer(check formatErrorMessage(1, lexer:MULTILINE_LITERAL_STRING_DELIMITER, lexer:MULTILINE_BASIC_STRING_DELIMITER));
                lexemeBuffer += "\\n";
            }
        }
        check checkToken(state,[
            lexer:MULTILINE_LITERAL_STRING_LINE,
            lexer:MULTILINE_LITERAL_STRING_DELIMITER,
            lexer:EOL
        ]);
    }

    state.updateLexerContext(lexer:EXPRESSION_KEY);
    return lexemeBuffer;
}