from enum import Enum

class TokenType(Enum):
    PROGRAM = 'PROGRAM'
    EOF = 'EOF'
    INTEGER_CONST = 'INTEGER_CONST'
    REAL_CONST = 'REAL_CONST'
    BOOL_CONST = "BOOL_CONST"
    COLOR = "COLOR"
    ID = 'ID'
    IF = "🤔"
    WHILE = "🪐"
    FOR = "🔁"
    SET_SCREEN_COLOR = '📱'
    GET_RANDOM_NUMBER = '👻'
    GET_NUMERIC_USER_INPUT = '🔢'
    PLUS = '➕'
    MINUS = '➖'
    MUL = '✖️'
    FLOAT_DIV = '➗'
    LPAREN = '('
    RPAREN = ')'
    LBRACKET = '['
    RBRACKET = ']'
    EQUALS = "="
    LESSER = "<"
    GREATER = ">"
    LESSER_EQ = "<="
    GREATER_EQ = ">="
    ASSIGN = '👉'
    LINEBREAK = '\n'
    DOT = '.'
    COLON = ':'
    COMMA = ','
    COMMENT = '📝'

    @staticmethod
    def get_members():
        return list(TokenType)

    @staticmethod
    def get_values():
        return [tokenType.value for tokenType in TokenType]

    def __repr__(self):
        return self.value
