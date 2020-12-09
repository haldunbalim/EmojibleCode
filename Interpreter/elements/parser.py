from elements import TokenType
from elements import Token


class AST(object):
    pass


class BinOp(AST):
    def __init__(self, left, op, right):
        self.left = left
        self.token = self.op = op
        self.right = right


class Value(AST):
    def __init__(self, token):
        self.token = token
        self.value = token.value


class Num(Value):
    def __init__(self, token):
        Value.__init__(self, token)


class Bool(Value):
    def __init__(self, token):
        Value.__init__(self, token)


class Color(Value):
    def __init__(self, token):
        Value.__init__(self, token)


class GetNumericUserInput(AST):
    def __init__(self, token):
        self.token = token


class SetScreenColor(AST):
    def __init__(self, op, color):
        self.token = self.op = op
        self.color = color.value


class UnaryOp(AST):
    def __init__(self, op, expr):
        self.token = self.op = op
        self.expr = expr


class Compound(AST):
    """Represents a 'BEGIN ... END' block"""

    def __init__(self):
        self.children = []


class Assign(AST):
    def __init__(self, left, op, right):
        self.left = left
        self.token = self.op = op
        self.right = right


class GetRandomNumber(AST):
    def __init__(self, token, lower_bound, upper_bound):
        self.token = self.op = token
        self.lower_bound = lower_bound
        self.upper_bound = upper_bound


class If(AST):
    def __init__(self, op, bool_statement, true_statement, false_statement):
        self.token = self.op = op
        self.bool_statement = bool_statement
        self.true_statement = true_statement
        self.false_statement = false_statement if false_statement is not None else NoOp()


class For(AST):
    def __init__(self, op, times, body):
        self.token = self.op = op
        self.times = times
        self.body = body


class While(AST):
    def __init__(self, op, bool_statement, body):
        self.token = self.op = op
        self.bool_statement = bool_statement
        self.body = body


class Var(AST):
    """The Var node is constructed out of ID token."""

    def __init__(self, token):
        self.token = token
        self.value = token.value


class NoOp(AST):
    pass


class Program(AST):
    def __init__(self, block):
        self.block = block


class Block(AST):
    def __init__(self, compound_statement):
        self.declarations = []
        self.compound_statement = compound_statement


class VarDecl(AST):
    def __init__(self, var_node, type_node):
        self.var_node = var_node
        self.type_node = type_node


class Type(AST):
    def __init__(self, token):
        self.token = token
        self.value = token.value


class Parser(object):
    def __init__(self, lexer_out):
        self.lexer_out = lexer_out
        # set current token to the first token taken from the input
        self.curr_idx = 0
        self.current_token = self.lexer_out[self.curr_idx]

    def peek(self):
        peek_pos = self.curr_idx + 1
        if peek_pos > len(self.lexer_out) - 1:
            return None
        else:
            return self.lexer_out[peek_pos]

    def advance(self):
        self.curr_idx += 1
        self.current_token = self.lexer_out[self.curr_idx]

    def error(self):
        raise Exception('Invalid syntax')

    def eat(self, token_type):
        # compare the current token type with the passed token
        # type and if they match then "eat" the current token
        # and assign the next token to the self.current_token,
        # otherwise raise an exception.
        if self.current_token.type == token_type:
            self.advance()
        else:
            self.error()

    def program(self):
        """program : PROGRAM variable SEMI block DOT"""
        self.eat(TokenType.PROGRAM)
        block_node = self.block()
        program_node = Program(block_node)
        return program_node

    def block(self):
        """block : declarations compound_statement"""
        compound_statement_node = self.compound_statement()
        node = Block(compound_statement_node)
        return node

    def compound_statement(self):
        nodes = self.statement_list()
        root = Compound()
        for node in nodes:
            root.children.append(node)

        return root

    def statement_list(self):
        """
        statement_list : statement
                       | statement SEMI statement_list
        """
        node = self.statement()

        results = [node]

        while self.current_token.type == TokenType.LINEBREAK:
            self.eat(TokenType.LINEBREAK)
            results.append(self.statement())

        return results

    def statement(self):
        """
        statement : compound_statement
                  | assignment_statement
                  | empty
        """
        if self.current_token.type == TokenType.PROGRAM:
            node = self.compound_statement()
        elif self.current_token.type == TokenType.ID:
            node = self.assignment_statement()
        elif self.current_token.type == TokenType.IF:
            node = self.if_statement()
        elif self.current_token.type == TokenType.LBRACKET and self.peek().type == TokenType.FOR:
            node = self.for_statement()
        elif self.current_token.type == TokenType.WHILE:
            node = self.while_statement()
        elif self.current_token.type == TokenType.LBRACKET and self.peek().type == TokenType.SET_SCREEN_COLOR:
            node = self.set_screen_color()
        else:
            node = self.empty()
        return node

    def assignment_statement(self):
        """
        assignment_statement : variable ASSIGN expr
        """
        left = self.variable()
        token = self.current_token
        self.eat(TokenType.ASSIGN)
        right = self.expr()
        node = Assign(left, token, right)
        return node

    def set_screen_color(self):
        self.eat(TokenType.LBRACKET)
        self.eat(TokenType.SET_SCREEN_COLOR)
        node = SetScreenColor(TokenType.SET_SCREEN_COLOR, self.current_token)
        self.eat(TokenType.COLOR)
        self.eat(TokenType.RBRACKET)
        return node

    def get_random_number(self):
        self.eat(TokenType.LBRACKET)
        self.eat(TokenType.GET_RANDOM_NUMBER)
        first_arg = self.expr()
        if self.current_token.type == TokenType.COMMA:
            self.eat(TokenType.COMMA)
            second_arg = self.expr()
            node = GetRandomNumber(TokenType.GET_RANDOM_NUMBER, first_arg, second_arg)
        else:
            node = GetRandomNumber(TokenType.GET_RANDOM_NUMBER, Token("INTEGER_CONST", 0), first_arg)
        self.eat(TokenType.RBRACKET)
        return node

    def get_numeric_user_input(self):
        self.eat(TokenType.LBRACKET)
        self.eat(TokenType.GET_NUMERIC_USER_INPUT)
        self.eat(TokenType.RBRACKET)
        node = GetNumericUserInput(TokenType.GET_NUMERIC_USER_INPUT)
        return node

    def if_statement(self):
        self.eat(TokenType.IF)
        self.eat(TokenType.LBRACKET)
        bool_statement = self.expr()
        self.eat(TokenType.RBRACKET)
        self.eat(TokenType.LBRACKET)
        true_statement = self.block()
        self.eat(TokenType.RBRACKET)
        false_statement = None
        if self.current_token.type == TokenType.LBRACKET:
            self.eat(TokenType.LBRACKET)
            false_statement = self.block()
            self.eat(TokenType.RBRACKET)

        node = If(TokenType.IF, bool_statement, true_statement, false_statement)
        return node

    def for_statement(self):
        self.eat(TokenType.LBRACKET)
        self.eat(TokenType.FOR)
        times = self.expr()
        self.eat(TokenType.RBRACKET)
        self.eat(TokenType.LBRACKET)
        body = self.block()
        self.eat(TokenType.RBRACKET)
        node = For(TokenType.FOR, times, body)
        return node

    def while_statement(self):
        self.eat(TokenType.WHILE)
        self.eat(TokenType.LBRACKET)
        bool_statement = self.expr()
        self.eat(TokenType.RBRACKET)
        self.eat(TokenType.LBRACKET)
        body = self.block()
        self.eat(TokenType.RBRACKET)
        node = While(TokenType.WHILE, bool_statement, body)
        return node

    def variable(self):
        """
        variable : ID
        """
        node = Var(self.current_token)
        self.eat(TokenType.ID)
        return node

    def empty(self):
        """An empty production"""
        return NoOp()

    def expr(self):
        """
        expr : term ((PLUS | MINUS) term)*
        """
        node = self.term()

        while self.current_token.type in (TokenType.PLUS, TokenType.MINUS):
            token = self.current_token
            self.eat(token.type)
            node = BinOp(left=node, op=token, right=self.term())

        if self.current_token.type in (
        TokenType.GREATER_EQ, TokenType.LESSER_EQ, TokenType.GREATER, TokenType.LESSER, TokenType.EQUALS):
            token = self.current_token
            self.eat(token.type)
            node = BinOp(left=node, op=token, right=self.term())
        return node

    def term(self):
        """term : factor ((MUL | INTEGER_DIV | FLOAT_DIV) factor)*"""
        node = self.factor()

        while self.current_token.type in (TokenType.MUL, TokenType.FLOAT_DIV):
            token = self.current_token
            self.eat(token.type)
            node = BinOp(left=node, op=token, right=self.factor())

        return node

    def factor(self):
        """factor : PLUS factor
                  | MINUS factor
                  | INTEGER_CONST
                  | REAL_CONST
                  | LPAREN expr RPAREN
                  | variable
        """
        token = self.current_token
        if token.type == TokenType.PLUS:
            self.eat(TokenType.PLUS)
            node = UnaryOp(token, self.factor())
            return node
        elif token.type == TokenType.MINUS:
            self.eat(TokenType.MINUS)
            node = UnaryOp(token, self.factor())
            return node
        elif token.type == TokenType.INTEGER_CONST:
            self.eat(TokenType.INTEGER_CONST)
            return Num(token)
        elif token.type == TokenType.REAL_CONST:
            self.eat(TokenType.REAL_CONST)
            return Num(token)
        elif token.type == TokenType.BOOL_CONST:
            self.eat(TokenType.BOOL_CONST)
            return Bool(token)
        elif token.type == TokenType.COLOR:
            self.eat(TokenType.COLOR)
            return Color(token)
        elif token.type == TokenType.LPAREN:
            self.eat(TokenType.LPAREN)
            node = self.expr()
            self.eat(TokenType.RPAREN)
            return node
        elif self.current_token.type == TokenType.LBRACKET and self.peek().type == TokenType.GET_RANDOM_NUMBER:
            node = self.get_random_number()
            return node
        elif self.current_token.type == TokenType.LBRACKET and self.peek().type == TokenType.GET_NUMERIC_USER_INPUT:
            node = self.get_numeric_user_input()
            return node
        else:
            node = self.variable()
            return node

    def parse(self):
        """
        program : PROGRAM variable SEMI block DOT
        block : declarations compound_statement
        declarations : VAR (variable_declaration SEMI)+
                     | empty
        variable_declaration : ID (COMMA ID)* COLON type_spec
        type_spec : INTEGER
        compound_statement : BEGIN statement_list END
        statement_list : statement
                       | statement SEMI statement_list
        statement : compound_statement
                  | assignment_statement
                  | empty
        assignment_statement : variable ASSIGN expr
        empty :
        expr : term ((PLUS | MINUS) term)*
        term : factor ((MUL | INTEGER_DIV | FLOAT_DIV) factor)*
        factor : PLUS factor
               | MINUS factor
               | INTEGER_CONST
               | REAL_CONST
               | LPAREN expr RPAREN
               | variable
        variable: ID
        """
        node = self.program()
        if self.current_token.type != TokenType.EOF:
            self.error()

        return node
