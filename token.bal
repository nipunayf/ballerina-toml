type Token record {|
    TOMLToken token;
    string value = "";
|};

enum TOMLToken {
    DUMMY = "",
    KEY_VALUE_SEPERATOR = "=",
    DOT = ".",
    UNQUOTED_KEY = "Unquoted key",
    BASIC_STRING = "Basic string",
    LITERAL_STRING = "Literal string",
    DECIMAL = "Integer",
    BINARY = "Binary integer",
    OCTAL = "Octal integer",
    HEXADECIMAL = "Hexadecimal integer",
    BOOLEAN = "Boolean",
    EOL = "End of line",
    MULTI_BSTRING_DELIMITER = "\"\"\"",
    MULTI_BSTRING_ESCAPE = "\\",
    MULTI_BSTRING_CHARS = "Multi-line basic string",
    MULTI_LSTRING_DELIMITER = "'''",
    MULTI_LSTRING_CHARS = "Mutli-line literal string",
    INFINITY = "inf",
    EXPONENTIAL = "e",
    NAN = "nan",
    OPEN_BRACKET = "[",
    CLOSE_BRACKET = "]",
    SEPARATOR = ",",
    ARRAY_TABLE_OPEN = "[[",
    ARRAY_TABLE_CLOSE = "]]",
    INLINE_TABLE_OPEN = "{",
    INLINE_TABLE_CLOSE = "}",
    MINUS = "-",
    PLUS = "+",
    TIME_DELIMITER = "T",
    ZULU = "Z",
    COLON = ":"
}