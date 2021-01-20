package com.dji.emojibleandroid.interpreter

import java.lang.Exception


class Parser(private val lexerOut: List<Token>, private val memory: Memory) {
    var currIdx: Int = 0
    var currentToken: Token = lexerOut[currIdx]

    companion object {
        private val UNARY_OPERATIONS = listOf<TokenType>(TokenType.PLUS, TokenType.MINUS)
        private val BINARY_COMPARATORS = listOf<TokenType>(
            TokenType.GREATER_EQ,
            TokenType.LESSER_EQ,
            TokenType.GREATER,
            TokenType.LESSER,
            TokenType.EQUALS
        )
        private val BINARY_OPERATIONS = listOf<TokenType>(TokenType.MUL, TokenType.FLOAT_DIV)
    }

    private fun peek(): Token? {
        val peekPos: Int = currIdx + 1
        return if (peekPos > lexerOut.size - 1) {
            null
        } else {
            lexerOut[peekPos]
        }
    }

    private fun advance() {
        currIdx += 1
        currentToken = lexerOut[currIdx]
    }

    private fun error() {
        throw Exception("Invalid Syntax")
    }

    private fun eat(tokenType: TokenType) {
        if (currentToken.type == tokenType) {
            advance()
        } else {
            error()
        }
    }

    fun program(): ProgramNode {
        eat(TokenType.PROGRAM)
        val blockNode = block()
        return ProgramNode(blockNode)
    }

    private fun block(): BlockNode {
        val compoundStatementNode = compoundStatement()
        return BlockNode(compoundStatementNode)
    }

    private fun compoundStatement(): CompoundNode {
        val nodes: MutableList<AST> = statementList()
        val root = CompoundNode()
        for (node in nodes) {
            root.children.add(node)
        }
        return root
    }

    private fun statementList(): MutableList<AST> {
        val node = statement()
        val results: MutableList<AST> = mutableListOf(node)
        while (currentToken.type == TokenType.LINEBREAK) {
            eat(TokenType.LINEBREAK)
            results.add(statement())
        }
        return results
    }

    private fun statement(): AST {
        return if (currentToken.type == TokenType.PROGRAM) {
            compoundStatement()
        } else if (currentToken.type == TokenType.ID) {
            assignmentStatement()
        } else if (currentToken.type == TokenType.IF) {
            ifStatement()
        } else if (currentToken.type == TokenType.LBRACKET && peek()?.type == TokenType.FOR) {
            forStatement()
        } else if (currentToken.type == TokenType.WHILE) {
            whileStatement()
        } else if (currentToken.type == TokenType.LBRACKET && peek()?.type == TokenType.SET_SCREEN_COLOR) {
            setScreenColor()
        } else {
            empty()
        }
    }

    private fun assignmentStatement(): AssignNode {
        val left = variable()
        val token = currentToken
        eat(TokenType.ASSIGN)
        val right = expr()
        return AssignNode(left, token, right, memory)
    }

    private fun setScreenColor(): SetScreenColorNode {
        eat(TokenType.LBRACKET)
        eat(TokenType.SET_SCREEN_COLOR)
        val colorNode = ColorNode(currentToken)
        eat(TokenType.COLOR)
        val node = SetScreenColorNode(TokenType.SET_SCREEN_COLOR, colorNode)
        eat(TokenType.RBRACKET)
        return node
    }

    private fun getRandomNumber(): GetRandomNumberNode {
        eat(TokenType.LBRACKET)
        eat(TokenType.GET_RANDOM_NUMBER)
        val firstArg = expr()
        val node = if (currentToken.type == TokenType.COMMA) {
            eat(TokenType.COMMA)
            val secondArg = expr()
            GetRandomNumberNode(TokenType.GET_RANDOM_NUMBER, firstArg, secondArg)
        } else {
            GetRandomNumberNode(TokenType.GET_RANDOM_NUMBER, NumNode(Token("INTEGER_CONST", 0, currentToken.lineNumber)), firstArg)
        }
        eat(TokenType.RBRACKET)
        return node
    }

    private fun getNumericUserInput(): GetNumericUserInputNode {
        eat(TokenType.LBRACKET)
        eat(TokenType.GET_NUMERIC_USER_INPUT)
        eat(TokenType.RBRACKET)
        return GetNumericUserInputNode(TokenType.GET_NUMERIC_USER_INPUT)
    }

    private fun ifStatement(): IfNode {
        eat(TokenType.IF)
        eat(TokenType.LBRACKET)
        val boolStatement = expr()
        eat(TokenType.RBRACKET)
        eat(TokenType.LBRACKET)
        val trueStatement = block()
        eat(TokenType.RBRACKET)
        var falseStatement: AST? = null
        if (currentToken.type == TokenType.LBRACKET) {
            eat(TokenType.LBRACKET)
            falseStatement = block()
            eat(TokenType.RBRACKET)
        }
        return IfNode(TokenType.IF, boolStatement, trueStatement, falseStatement)
    }

    private fun forStatement(): ForNode {
        eat(TokenType.LBRACKET)
        eat(TokenType.FOR)
        val times = expr()
        eat(TokenType.RBRACKET)
        eat(TokenType.LBRACKET)
        val body = block()
        eat(TokenType.RBRACKET)
        return ForNode(TokenType.FOR, times, body)
    }

    private fun whileStatement(): WhileNode {
        eat(TokenType.WHILE)
        eat(TokenType.LBRACKET)
        val boolStatement = expr()
        eat(TokenType.RBRACKET)
        eat(TokenType.LBRACKET)
        val body = block()
        eat(TokenType.RBRACKET)
        return WhileNode(TokenType.WHILE, boolStatement, body)
    }

    private fun variable(): VarNode {
        val node = VarNode(currentToken, memory)
        eat(TokenType.ID)
        return node
    }

    private fun empty(): NoOpNode {
        return NoOpNode()
    }

    private fun expr(): AST {
        var node = term()
        while (currentToken.type in UNARY_OPERATIONS) {
            val token = currentToken
            eat(token.type)
            node = BinOpNode(node, token, term())
        }
        if (currentToken.type in BINARY_COMPARATORS) {
            val token = currentToken
            eat(token.type)
            node = BinOpNode(node, token, term())
        }
        return node
    }

    private fun term(): AST {
        var node = factor()
        while (currentToken.type in BINARY_OPERATIONS) {
            val token = currentToken
            eat(token.type)
            node = BinOpNode(node, token, factor())
        }
        return node
    }

    private fun factor(): AST {
        val token = currentToken
        val node: AST
        if (token.type == TokenType.PLUS) {
            eat(TokenType.PLUS)
            node = UnaryOpNode(token, factor())
        } else if (token.type == TokenType.MINUS) {
            eat(TokenType.MINUS)
            node = UnaryOpNode(token, factor())
        } else if (token.type == TokenType.INTEGER_CONST) {
            eat(TokenType.INTEGER_CONST)
            node = NumNode(token)
        } else if (token.type == TokenType.REAL_CONST) {
            node = NumNode(token)
        } else if (token.type == TokenType.BOOL_CONST) {
            eat(TokenType.BOOL_CONST)
            node = BoolNode(token)
        } else if (token.type == TokenType.COLOR) {
            node = ColorNode(token)
        } else if (token.type == TokenType.LPAREN) {
            eat(TokenType.LPAREN)
            node = expr()
            eat(TokenType.RPAREN)
        } else if (currentToken.type == TokenType.LBRACKET && peek()?.type == TokenType.GET_RANDOM_NUMBER) {
            node = getRandomNumber()
        } else if (currentToken.type == TokenType.LBRACKET && peek()?.type == TokenType.GET_NUMERIC_USER_INPUT) {
            node = getNumericUserInput()
        } else {
            node = variable()
        }
        return node
    }

    fun parse(): ProgramNode {
        val node = program()
        if (currentToken.type != TokenType.EOF) {
            error()
        }
        return node
    }
}