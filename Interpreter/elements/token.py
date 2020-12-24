from elements import TokenType
class Token(object):
    def __init__(self, type, value, line_number):
        self.type = TokenType(type)
        self.value = value
        self.line_number = line_number

    def __str__(self):
        """String representation of the class instance.
        Examples:
            Token(INTEGER, 3)
            Token(PLUS, '+')
            Token(MUL, '*')
        """
        return 'Token({type}, {value} at line: {line})'.format(
            type=self.type,
            value=repr(self.value),
            line=self.line_number

        )

    def __repr__(self):
        return self.__str__()

