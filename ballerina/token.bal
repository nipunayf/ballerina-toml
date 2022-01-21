type Token record {|
    TOMLToken token;
    string value = "";
|};

enum TOMLToken {
    EXPRESSION,
    WHITESPACE,
    UNQUOTED_KEY,
    KEY_VALUE_SEPERATOR,
    EOL
}