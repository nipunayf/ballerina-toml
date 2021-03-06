import toml.lexer;

# Process the grammar rules after '[' or ','.
#
# + state - Current parser state  
# + tempArray - Recursively constructing array
# + return - Completed array on success. An error if the grammar rules are not met.
function array(ParserState state, json[] tempArray = []) returns json[]|ParsingError {

    check checkToken(state, [
        lexer:BASIC_STRING,
        lexer:LITERAL_STRING,
        lexer:MULTILINE_BASIC_STRING_DELIMITER,
        lexer:MULTILINE_LITERAL_STRING_DELIMITER,
        lexer:DECIMAL,
        lexer:HEXADECIMAL,
        lexer:OCTAL,
        lexer:BINARY,
        lexer:INFINITY,
        lexer:NAN,
        lexer:BOOLEAN,
        lexer:OPEN_BRACKET,
        lexer:CLOSE_BRACKET,
        lexer:INLINE_TABLE_OPEN,
        lexer:EOL
    ]);

    match state.currentToken.token {
        lexer:EOL => { // Array spanning multiple lines
            check state.initLexer(generateExpectError(state, lexer:CLOSE_BRACKET, lexer:OPEN_BRACKET));
            return array(state, tempArray);
        }
        lexer:CLOSE_BRACKET => { // If the array ends with a ','
            return tempArray;
        }
        _ => { // Array value
            tempArray.push(check dataValue(state));
            return arrayValue(state, tempArray);
        }
    }
}

# Process the rules after an array value.
#
# + state - Current parser state  
# + tempArray - Recursively constructing array
# + return - Completed array on success. An error if the grammar rules are not met.
function arrayValue(ParserState state, json[] tempArray = []) returns json[]|ParsingError {
    lexer:TOMLToken prevToken;
    state.updateLexerContext(lexer:EXPRESSION_VALUE);

    if state.tokenConsumed {
        prevToken = lexer:DECIMAL;
        state.tokenConsumed = false;
    } else {
        prevToken = state.currentToken.token;
        check checkToken(state);
    }

    match state.currentToken.token {
        lexer:EOL => { // Array spanning multiple lines
            check state.initLexer(generateGrammarError(state, "Expected ']' or ',' after an array value"));
            return arrayValue(state, tempArray);
        }
        lexer:CLOSE_BRACKET => { // Reaches the end of the array
            return tempArray;
        }
        lexer:SEPARATOR => { // Next value of the array
            return array(state, tempArray);
        }
        _ => {
            return generateExpectError(state, [lexer:EOL, lexer:CLOSE_BRACKET, lexer:SEPARATOR], prevToken);
        }
    }
}
