import ballerina/io;

# Parses a single line of a TOML string into a Ballerina map object.
#
# + tomlString - Single line of a TOML string
# + return - TOML map object is sucess. Else, returns an error
public function read(string tomlString) returns map<anydata>|error {
    string[] lines = [tomlString];
    Parser parser = new Parser(lines);
    return parser.parse();
}

# Parses a TOML file into a Ballerina map object.
#
# + filePath - Path to the toml file
# + return - TOML map object is sucess. Else, returns an error
public function readFile(string filePath) returns map<anydata>|error {
    string[] lines = check io:fileReadLines(filePath);
    Parser parser = new Parser(lines);
    return parser.parse();
}

# Writes the toml structure to a TOML document.
#
# + fileName - Path to the file  
# + tomlStructure - Structure to be written to the file.  
# + indentationPolicy - Number of whitespaces for an indentation. Default = 2  
# + allowDottedKeys - If set, dotted keys are used instead of standard tables. Default = true
# + return - An error on failure
public function write(string fileName, map<anydata> tomlStructure, int indentationPolicy = 2, boolean allowDottedKeys = true) returns error? {
    Writer writer = new Writer(indentationPolicy, allowDottedKeys);
    check writer.openFile(fileName);
    string[] output = check writer.write(tomlStructure);
    check io:fileWriteLines(fileName, output);
}