import ballerina/io;
import ballerina/file;

import toml.lexer;
import toml.parser;
import toml.writer;

# Represents the generic error type for the TOML package.
public type Error ParsingError|WritingError|FileError;

// Level 1
# Represents an error caused when failed to access the file.
public type FileError distinct (io:Error|file:Error);

# Represents an error caused during the parsing.
public type ParsingError parser:ParsingError;

# Represents an error caused when writing a TOML file.
public type WritingError writer:WritingError;

// Level 2
# Represents an error caused by the lexical analyzer.
public type LexicalError lexer:LexicalError;

# Represents an error caused for an invalid grammar production.
public type GrammarError parser:GrammarError;

# Represents an error caused by the Ballerina lang when converting a data type.
public type ConversionError parser:ConversionError;
