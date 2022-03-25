import ballerina/test;

// String tokens
@test:Config {}
function testBasicString() returns error? {
    setLexerString("someKey = \"someValue\"");
    check assertToken(BASIC_STRING, 3, "someValue");
}

@test:Config {}
function testLiteralString() returns error? {
    setLexerString("somekey = 'somevalue'");
    check assertToken(LITERAL_STRING, 3, "somevalue");
}

@test:Config {
    dataProvider: simpleDataValueDataGen
}
function testSimpleDataValueToken(string testingLine, TOMLToken expectedToken, string expectedLexeme) returns error? {
    setLexerString(testingLine, EXPRESSION_VALUE);
    check assertToken(expectedToken, lexeme = expectedLexeme);
}

function simpleDataValueDataGen() returns map<[string, TOMLToken, string]> {
    return {
        "positive decimal": ["+1", DECIMAL, "+1"],
        "negative decimal": ["-1", DECIMAL, "-1"],
        "unsigned decimal": ["1", DECIMAL, "1"],
        "zero decimal": ["0", DECIMAL, "0"],
        "underscore decimal": ["111_222_333", DECIMAL, "111222333"],
        "underscore hexadecimal": ["0xdead_beef", HEXADECIMAL, "deadbeef"],
        "underscore binary": ["0b001_010", BINARY, "001010"],
        "underscore octal": ["0o007_610", OCTAL, "007610"],
        "boolean true": ["true", BOOLEAN, "true"],
        "boolean false": ["false", BOOLEAN, "false"],
        "positive infinity": ["+inf", INFINITY, "+inf"],
        "negative infinity": ["-inf", INFINITY, "-inf"],
        "unsigned infinity": ["inf", INFINITY, "+inf"],
        "positive nan": ["+nan", NAN, ""],
        "negative nan": ["-nan", NAN, ""],
        "unsigned nan": ["nan", NAN, ""],
        "simple exponential": ["e", EXPONENTIAL, ""],
        "capital exponential": ["E", EXPONENTIAL, ""]
    };
}

    @test:Config {}
function testExponentialTokenWithDECIMAL() returns error? {
    setLexerString("123e2", EXPRESSION_VALUE);
    check assertToken(EXPONENTIAL, 2);
}

@test:Config {}
function testDecimalToken() returns error? {
    setLexerString("123.123", EXPRESSION_VALUE);
    check assertToken(DOT, 2);
}

@test:Config {}
function testUnclosedString() {
    assertLexicalError("'hello");
}

@test:Config {
    dataProvider: excapedCharacterDataGen
}
function testEscapedCharacterToken(string lexeme, string value) returns error? {
    setLexerString("\"\\"+ lexeme + "\"");
    check assertToken(BASIC_STRING, lexeme = value);
}

function excapedCharacterDataGen() returns map<[string, string]> {
    return {
        "backspace": ["b", "\u{08}"],
        "tab": ["t", "\t"],
        "linefeed": ["n", "\n"],
        "form-feed": ["f", "\u{0c}"],
        "carriage-return": ["r", "\r"],
        "double-quote": ["\"", "\""],
        "backslash": ["\\", "\\"],
        "u-4": ["u0041", "A"],
        "U-8": ["U00000041", "A"]
    };
}

@test:Config {
    dataProvider: invalidEscapedCharDataGen
}
function testInvalidExcapedCharacter(string lexeme) {
    assertLexicalError("\\" + lexeme);
}

function invalidEscapedCharDataGen() returns map<[string]> {
    return {
        "u-3": ["u333"],
        "u-5": ["u55555"],
        "U-7": ["u7777777"],
        "U-9": ["u999999999"],
        "no-char": [""],
        "invalid-char": ["z"]
    };
}