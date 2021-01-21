//
//  Parser.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 4.12.2020.
//

import Foundation
class Parser{
    var lexer_out:[Token]
    var curr_idx: Int = 0
    var current_token:Token
    var memory: Memory
    
    init(lexer_out:[Token], memory:Memory) {
        self.lexer_out = lexer_out
        current_token = lexer_out[curr_idx]
        self.memory = memory
    }
    
    private func peek() -> Token?{
        let peek_pos = self.curr_idx + 1
        if peek_pos > lexer_out.count - 1{
            return nil
        }else{
            return lexer_out[peek_pos]
        }
    }
    
    private func advance(){
        self.curr_idx += 1
        self.current_token = self.lexer_out[self.curr_idx]
    }
    
    private func error(){
        //raise Exception('Invalid syntax')
        print("Error")
    }
    
    private func eat(_ token_type:TokenType){
        if self.current_token.type == token_type{
            self.advance()
        }else{
            self.error()
        }
    }
    
    private func statement() -> AST{
        let node: AST
        if self.current_token.type == TokenType.PROGRAM{
            node = self.compound_statement()
        }else if self.current_token.type == TokenType.ID && self.peek() != nil && self.peek()!.type == TokenType.ASSIGN{
            node = self.assignment_statement()
        }else if self.current_token.type == TokenType.ID{
            //node = self.read_value_statement()
            node = self.assignment_statement()
        }else if self.current_token.type == TokenType.LBRACKET && self.peek() != nil && self.peek()!.type == TokenType.DISPLAY{
            node = self.display_statement()
        }else if self.current_token.type == TokenType.IF{
            node = self.if_statement()
        }else if self.current_token.type == TokenType.LBRACKET && self.peek() != nil && self.peek()!.type == TokenType.FOR{
            node = self.for_statement()
        }else if self.current_token.type == TokenType.WHILE{
            node = self.while_statement()
        }else if self.current_token.type == TokenType.LBRACKET && self.peek() != nil && self.peek()!.type == TokenType.SET_SCREEN_COLOR{
            node = self.set_screen_color()
        }else{
            node = self.empty()}
        return node
    }
    
    private func statement_list() -> [AST]{
        let node = self.statement()
        var results = [node]
        while self.current_token.type == TokenType.LINEBREAK{
            self.eat(TokenType.LINEBREAK)
            results.append(self.statement())
        }
        return results
    }
    
    private func compound_statement() -> CompoundNode{
        let nodes = self.statement_list()
        let root = CompoundNode()
        for node in nodes{
            root.children.append(node)
        }
        return root
    }
    private func block() -> BlockNode{
        let compound_statement_node = self.compound_statement()
        let node = BlockNode(compound_statement: compound_statement_node)
        return node
    }
    
    private func program() -> ProgramNode{
        self.eat(TokenType.PROGRAM)
        let block_node = self.block()
        let program_node = ProgramNode(block: block_node)
        return program_node
    }
    
    private func  empty() -> NoOpNode{
        return NoOpNode()
    }
    
    private func term() -> AST{
        var node:AST = self.factor()
        
        while [TokenType.MUL, TokenType.FLOAT_DIV].contains(self.current_token.type){
            let token = self.current_token
            self.eat(token.type)
            node = BinOpNode(left:node, op:token, right:self.factor())
        }
        
        return node
    }
    
    private func factor() -> AST{
        let token = self.current_token
        if token.type == TokenType.PLUS{
            self.eat(TokenType.PLUS)
            return UnaryOpNode(op: token, expr: self.factor())
        }
        else if token.type == TokenType.MINUS{
            self.eat(TokenType.MINUS)
            return UnaryOpNode(op: token, expr: self.factor())
        }
        else if token.type == TokenType.INTEGER_CONST{
            self.eat(TokenType.INTEGER_CONST)
            return NumNode(token: token)
        }
        else if token.type == TokenType.REAL_CONST{
            self.eat(TokenType.REAL_CONST)
            return NumNode(token: token)
        }
        else if token.type == TokenType.BOOL_CONST{
            self.eat(TokenType.BOOL_CONST)
            return BoolNode(token: token)
        }
        else if token.type == TokenType.COLOR{
            self.eat(TokenType.COLOR)
            return ColorNode(token: token)
        }
        else if token.type == TokenType.LPAREN{
            self.eat(TokenType.LPAREN)
            let node = self.expr()
            self.eat(TokenType.RPAREN)
            return node
        }
        else if self.current_token.type == TokenType.LBRACKET && self.peek() != nil && self.peek()!.type == TokenType.GET_RANDOM_NUMBER{
            return self.get_random_number()
        }
        else if self.current_token.type == TokenType.LBRACKET && self.peek() != nil && self.peek()!.type == TokenType.GET_NUMERIC_USER_INPUT{
            return self.get_numeric_user_input()
        }
        else{
            return self.variable()
        }
    }
    private func expr() -> AST{
        var node = self.term()
        
        while [TokenType.PLUS, TokenType.MINUS].contains(self.current_token.type) {
            let token = self.current_token
            self.eat(token.type)
            node = BinOpNode(left:node, op:token, right:self.term())
        }
        
        if [TokenType.GREATER_EQ, TokenType.LESSER_EQ,TokenType.GREATER,TokenType.LESSER, TokenType.EQUALS].contains(self.current_token.type){
            let token = self.current_token
            self.eat(token.type)
            node = BinOpNode(left:node, op:token, right:self.term())
        }
        return node
    }
    
    func parse() -> ProgramNode{
        let node = self.program()
        if self.current_token.type != TokenType.EOF{
            self.error()
        }
        return node
    }
    
}

extension Parser{
    
    private func display_statement() -> DisplayNode{
        self.eat(TokenType.LBRACKET)
        let token = self.current_token
        self.eat(TokenType.DISPLAY)
        let expr = self.expr()
        self.eat(TokenType.RBRACKET)
        let node = DisplayNode(op: token, expr: expr)
        return node
    }
    
    private func assignment_statement() -> AssignNode{
        let left = self.variable()
        let token = self.current_token
        self.eat(TokenType.ASSIGN)
        let right = self.expr()
        let node = AssignNode(left: left, op: token, right: right, memory: self.memory)
        return node
    }
    
    
    private func set_screen_color() -> SetScreenColorNode{
        self.eat(TokenType.LBRACKET)
        self.eat(TokenType.SET_SCREEN_COLOR)
        let colorNode = ColorNode(token: self.current_token)
        self.eat(TokenType.COLOR)
        let node = SetScreenColorNode(op: TokenType.SET_SCREEN_COLOR, color: colorNode)
        self.eat(TokenType.RBRACKET)
        return node
    }
    
    private func get_random_number() -> GetRandomNumberNode{
        self.eat(TokenType.LBRACKET)
        self.eat(TokenType.GET_RANDOM_NUMBER)
        let first_arg = self.expr()
        var node: GetRandomNumberNode
        if self.current_token.type == TokenType.COMMA{
            self.eat(TokenType.COMMA)
            let second_arg = self.expr()
            node = GetRandomNumberNode(op: self.current_token, lower_bound: first_arg, upper_bound: second_arg)
        }else{
            node = GetRandomNumberNode(op: self.current_token, lower_bound: NumNode(token:Token(type: "INTEGER_CONST",value: 0, lineNumber: self.current_token.lineNumber)), upper_bound: first_arg)
        }
        self.eat(TokenType.RBRACKET)
        return node
    }

    private func get_numeric_user_input() -> GetNumericUserInputNode{
        self.eat(TokenType.LBRACKET)
        self.eat(TokenType.GET_NUMERIC_USER_INPUT)
        self.eat(TokenType.RBRACKET)
        let node = GetNumericUserInputNode(op: TokenType.GET_NUMERIC_USER_INPUT)
        return node
    }
    
    private func if_statement()->IfNode{
        self.eat(TokenType.IF)
        self.eat(TokenType.LBRACKET)
        let bool_statement = self.expr()
        self.eat(TokenType.RBRACKET)
        self.eat(TokenType.LBRACKET)
        let true_statement = self.block()
        self.eat(TokenType.RBRACKET)
        var false_statement:BlockNode? = nil
        if self.current_token.type == TokenType.LBRACKET{
            self.eat(TokenType.LBRACKET)
            false_statement = (self.block() as! BlockNode)
            self.eat(TokenType.RBRACKET)
        }
        return IfNode(op: TokenType.IF,bool_statement: bool_statement,true_statement: true_statement,false_statement: false_statement)
    }
    private func for_statement() -> ForNode{
        self.eat(TokenType.LBRACKET)
        self.eat(TokenType.FOR)
        let times = self.expr()
        self.eat(TokenType.RBRACKET)
        self.eat(TokenType.LBRACKET)
        let body = self.block()
        self.eat(TokenType.RBRACKET)
        let node = ForNode(op: TokenType.FOR, times: times, body: body)
        return node
    }
    private func while_statement() -> WhileNode{
        self.eat(TokenType.WHILE)
        self.eat(TokenType.LBRACKET)
        let bool_statement = self.expr()
        self.eat(TokenType.RBRACKET)
        self.eat(TokenType.LBRACKET)
        let body = self.block()
        self.eat(TokenType.RBRACKET)
        let node = WhileNode(op: TokenType.WHILE,bool_statement: bool_statement,body: body)
        return node
    }
    
    private func variable()-> VarNode{
        let node = VarNode(token: self.current_token, memory: self.memory)
        self.eat(TokenType.ID)
        return node
    }
}
