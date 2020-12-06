from elements import Token
from elements import TokenType
from emoji import UNICODE_EMOJI

color_dict = {
    "🟦": "Blue",
    "🟥": "Red",
    "🟩": "Green",
}

bool_dict = {
    "👍": True,
    "👎": False,
}

class Lexer(object):
    def __init__(self, text):
        # client string input, e.g. "4 + 2 * 3 - 6 / 2"
        self.text = text
        # self.pos is an index into self.text
        self.pos = 0
        self.token_type_values = TokenType.get_values()
        self.current_char = self.text[self.pos]
        self.current_line_number = 1

    def error(self):
        raise Exception('{} is an invalid character at line: {}'.format(self.current_char,self.current_line_number))

    def advance(self):
        """Advance the `pos` pointer and set the `current_char` variable."""
        self.pos += 1
        if self.pos > len(self.text) - 1:
            self.current_char = None  # Indicates end of input
        else:
            self.current_char = self.text[self.pos]

    def peek(self):
        peek_pos = self.pos + 1
        if peek_pos > len(self.text) - 1:
            return None
        else:
            return self.text[peek_pos]

    def skip_whitespace(self):
        while self.current_char is not None and self.current_char.isspace():
            self.advance()

    def skip_comment(self):
        while self.current_char != '\n':
            self.advance()

    def number(self):
        """Return a (multidigit) integer or float consumed from the input."""
        result = ''
        while self.current_char is not None and self.current_char.isdigit():
            result += self.current_char
            self.advance()

        if self.current_char == '.':
            result += self.current_char
            self.advance()

            while (
                    self.current_char is not None and
                    self.current_char.isdigit()
            ):
                result += self.current_char
                self.advance()

            token = Token('REAL_CONST', float(result), self.current_line_number)
        else:
            token = Token('INTEGER_CONST', int(result), self.current_line_number)

        return token

    def _id(self):
        """Handle identifiers """
        result = ''
        while self.current_char is not None and (self.current_char.isalnum() or self.current_char in UNICODE_EMOJI):
            result += self.current_char
            self.advance()
        return Token("ID", result, self.current_line_number)

    def get_next_token(self):
        """Lexical analyzer (also known as scanner or tokenizer)
        This method is responsible for breaking a sentence
        apart into tokens. One token at a time.
        """
        while self.current_char is not None:

            if self.current_char == " ":
                self.skip_whitespace()
                continue

            if self.current_char.isdigit():
                return self.number()

            if self.current_char in color_dict:
                token = Token("COLOR", color_dict[self.current_char], self.current_line_number)
                self.advance()
                return token

            if self.current_char in bool_dict:
                token = Token("BOOL_CONST", bool_dict[self.current_char], self.current_line_number)
                self.advance()
                return token

            token = self._read_double_char_symbol()
            if token is not None:
                return token

            token = self._read_single_char_symbol()
            if token is not None:
                if token.type == TokenType.COMMENT:
                    self.skip_comment()
                    continue
                return token

            if self.current_char.isalpha() or self.current_char in UNICODE_EMOJI:
                return self._id()

            self.error()

    def _read_double_char_symbol(self):
        next_char = self.peek()
        if next_char is None:
            return None
        symbol = self.current_char+next_char
        token = None
        if symbol in self.token_type_values:
            token = Token(symbol, symbol, self.current_line_number)
            self.advance()
            self.advance()
        return token

    def _read_single_char_symbol(self):
        token = None
        if self.current_char in self.token_type_values:
            token = Token(self.current_char, self.current_char, self.current_line_number)
            if token.type == TokenType.LINEBREAK:
                self.current_line_number += 1
            self.advance()
        return token


    def lex(self):
        self.lexed_text = []
        self.lexed_text.append(Token('PROGRAM', 'PROGRAM',0))
        while self.current_char is not None:
            token = self.get_next_token()
            if token is not None:
                self.lexed_text.append(token)
        self.lexed_text.append(Token("EOF", "EOF", self.current_line_number+1))


    def __repr__(self):
        return self.lexed_text.__repr__()

