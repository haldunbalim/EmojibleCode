//
//  Parser.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 4.12.2020.
//

import Foundation

enum ParserErrors: Error {
    case UnexpectedToken (token:Token, expected:String)
    case EndOfLineExpected 
}

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
    
    
    private func eat(_ token_type:TokenType) throws{
        if self.current_token.type == token_type{
            self.advance()
        }else{
            throw ParserErrors.UnexpectedToken(token: self.current_token, expected: token_type.description)
        }
    }
    
    private func statement()throws -> AST{
        do{
            let node: AST
            if self.current_token.type == TokenType.PROGRAM{
                node = try self.compound_statement()
            }else if self.current_token.type == TokenType.ID && self.peek() != nil && self.peek()!.type == TokenType.ASSIGN{
                node = try self.assignment_statement()
            }else if self.current_token.type == TokenType.LBRACKET && self.peek() != nil && self.peek()!.type == TokenType.DISPLAY{
                node = try self.display_statement()
            }else if self.current_token.type == TokenType.IF{
                node = try self.if_statement()
            }else if self.current_token.type == TokenType.LBRACKET && self.peek() != nil && self.peek()!.type == TokenType.FOR{
                node = try self.for_statement()
            }else if self.current_token.type == TokenType.WHILE{
                node = try self.while_statement()
            }else if self.current_token.type == TokenType.LBRACKET && self.peek() != nil && self.peek()!.type == TokenType.TTS{
                node = try self.tts_statement()
            }else if self.current_token.type == TokenType.LBRACKET && self.peek() != nil && self.peek()!.type == TokenType.SET_SCREEN_COLOR{
                node = try self.set_screen_color()
            }else{
                node = self.empty()}
            return node
        }catch{
            throw error
        }
    }
    
    private func statement_list() throws -> [AST]{
        do{
            let node = try self.statement()
            var results = [node]
            while self.current_token.type == TokenType.LINEBREAK{
                try self.eat(TokenType.LINEBREAK)
                results.append(try self.statement())
            }
            return results
        }catch{
            throw error
        }
    }
    
    private func compound_statement() throws -> CompoundNode{
        do{
            let nodes = try self.statement_list()
            let root = CompoundNode()
            for node in nodes{
                root.children.append(node)
            }
            return root
        }catch{
            throw error
        }
    }
    private func block() throws -> BlockNode{
        do{
            let compound_statement_node = try self.compound_statement()
            let node = BlockNode(compound_statement: compound_statement_node)
            return node
        }catch{
            throw error
        }
    }
    
    private func program() throws -> ProgramNode{
        do{
            try self.eat(TokenType.PROGRAM)
            let block_node = try self.block()
            let program_node = ProgramNode(block: block_node)
            return program_node
        }catch{
            throw error
        }
    }
    
    private func  empty() -> NoOpNode{
        return NoOpNode()
    }
    
    private func term() throws -> AST{
        do{
            var node:AST = try self.factor()
            
            while [TokenType.MUL, TokenType.FLOAT_DIV].contains(self.current_token.type){
                let token = self.current_token
                try self.eat(token.type)
                node = BinOpNode(left:node, op:token, right:try self.factor())
            }
            
            return node
        }catch{
            throw error
        }
    }
    
    private func factor() throws -> AST{
        do{
            let token = self.current_token
            if token.type == TokenType.PLUS{
                try self.eat(TokenType.PLUS)
                return UnaryOpNode(op: token, expr: try self.factor())
            }
            else if token.type == TokenType.MINUS{
                try self.eat(TokenType.MINUS)
                return UnaryOpNode(op: token, expr: try self.factor())
            }
            else if token.type == TokenType.INTEGER_CONST{
                try self.eat(TokenType.INTEGER_CONST)
                return NumNode(token: token)
            }
            else if token.type == TokenType.TOUCHED{
                return try self.touched_statement()
            }
            else if token.type == TokenType.FLIPPED{
                return try self.flipped_statement()
            }
            else if token.type == TokenType.REAL_CONST{
                try self.eat(TokenType.REAL_CONST)
                return NumNode(token: token)
            }
            else if token.type == TokenType.BOOL_CONST{
                try self.eat(TokenType.BOOL_CONST)
                return BoolNode(token: token)
            }
            else if token.type == TokenType.COLOR{
                try self.eat(TokenType.COLOR)
                return ColorNode(token: token)
            }
            else if token.type == TokenType.LPAREN{
                try self.eat(TokenType.LPAREN)
                let node = try self.expr()
                try self.eat(TokenType.RPAREN)
                return node
            }
            else if self.current_token.type == TokenType.LBRACKET && self.peek() != nil && self.peek()!.type == TokenType.GET_RANDOM_NUMBER{
                return try self.get_random_number()
            }
            else if self.current_token.type == TokenType.LBRACKET && self.peek() != nil && self.peek()!.type == TokenType.GET_NUMERIC_USER_INPUT{
                return try self.get_numeric_user_input()
            }
            else{
                return try self.variable()
            }
        }catch{
            throw error
        }
    }
    private func expr() throws -> AST{
        do{
            var node = try self.term()
            
            while [TokenType.PLUS, TokenType.MINUS, TokenType.AND,TokenType.OR].contains(self.current_token.type) {
                let token = self.current_token
                try self.eat(token.type)
                node = BinOpNode(left:node, op:token, right:try self.term())
            }
            
            if [TokenType.GREATER_EQ, TokenType.LESSER_EQ,TokenType.GREATER,TokenType.LESSER, TokenType.EQUALS].contains(self.current_token.type){
                let token = self.current_token
                try self.eat(token.type)
                node = BinOpNode(left:node, op:token, right:try self.term())
            }
            
            
            return node
        }catch{
            throw error
        }
    }
    
    func parse() throws -> ProgramNode{
        let node = try self.program()
        if self.current_token.type != TokenType.EOF{
            throw ParserErrors.EndOfLineExpected
        }
        return node
    }
    
}

extension Parser{
    
    private func touched_statement() throws -> TouchedNode{
        do{
            try self.eat(TokenType.TOUCHED)
            let token = self.current_token
            let node = TouchedNode(token: token)
            return node
        }catch{
            throw error
        }
    }
    
    private func flipped_statement() throws -> FlippedNode{
        do{
            try self.eat(TokenType.FLIPPED)
            let token = self.current_token
            let node = FlippedNode(token: token)
            return node
        }catch{
            throw error
        }
    }
    
    private func tts_statement() throws -> TTSNode{
        do{
            try self.eat(TokenType.LBRACKET)
            let token = self.current_token
            try self.eat(TokenType.TTS)
            let expr = try self.expr()
            try self.eat(TokenType.RBRACKET)
            let node = TTSNode(op: token, expr: expr)
            return node
        }catch{
            throw error
        }
        
    }
    
    private func display_statement() throws -> DisplayNode{
        do{
            try self.eat(TokenType.LBRACKET)
            let token = self.current_token
            try self.eat(TokenType.DISPLAY)
            let expr = try self.expr()
            try self.eat(TokenType.RBRACKET)
            let node = DisplayNode(op: token, expr: expr)
            return node
        }catch{
            throw error
        }
    }
    
    private func assignment_statement() throws -> AssignNode{
        do{
            let left = try self.variable()
            let token = self.current_token
            try self.eat(TokenType.ASSIGN)
            let right = try self.expr()
            let node = AssignNode(left: left, op: token, right: right, memory: self.memory)
            return node
        }catch{
            throw error
        }
    }
    
    
    private func set_screen_color() throws -> SetScreenColorNode{
        do{
            try self.eat(TokenType.LBRACKET)
            try self.eat(TokenType.SET_SCREEN_COLOR)
            let colorNode = ColorNode(token: self.current_token)
            try self.eat(TokenType.COLOR)
            let node = SetScreenColorNode(op: TokenType.SET_SCREEN_COLOR, color: colorNode)
            try self.eat(TokenType.RBRACKET)
            return node
        }catch{
            throw error
        }
    }
    
    private func get_random_number() throws -> GetRandomNumberNode{
        do{
            try self.eat(TokenType.LBRACKET)
            try self.eat(TokenType.GET_RANDOM_NUMBER)
            let first_arg = try self.expr()
            var node: GetRandomNumberNode
            if self.current_token.type == TokenType.COMMA{
                try self.eat(TokenType.COMMA)
                let second_arg = try self.expr()
                node = GetRandomNumberNode(op: self.current_token, lower_bound: first_arg, upper_bound: second_arg)
            }else{
                node = GetRandomNumberNode(op: self.current_token, lower_bound: NumNode(token:Token(type: "INTEGER_CONST",value: 0, lineNumber: self.current_token.lineNumber)), upper_bound: first_arg)
            }
            try self.eat(TokenType.RBRACKET)
            return node
        }catch{
            throw error
        }
    }
    
    private func get_numeric_user_input() throws -> GetNumericUserInputNode{
        do{
            try self.eat(TokenType.LBRACKET)
            try self.eat(TokenType.GET_NUMERIC_USER_INPUT)
            try self.eat(TokenType.RBRACKET)
            let node = GetNumericUserInputNode(op: TokenType.GET_NUMERIC_USER_INPUT)
            return node
        }catch{
            throw error
        }
    }
    
    private func if_statement() throws ->IfNode{
        do{
            try self.eat(TokenType.IF)
            try self.eat(TokenType.LBRACKET)
            let bool_statement = try self.expr()
            try self.eat(TokenType.RBRACKET)
            try self.eat(TokenType.LBRACKET)
            let true_statement = try self.block()
            try self.eat(TokenType.RBRACKET)
            var false_statement:BlockNode? = nil
            if self.current_token.type == TokenType.LBRACKET{
                try self.eat(TokenType.LBRACKET)
                false_statement = try self.block()
                try self.eat(TokenType.RBRACKET)
            }
            return IfNode(op: TokenType.IF,bool_statement: bool_statement,true_statement: true_statement,false_statement: false_statement)
        }catch{
            throw error
        }
    }
    private func for_statement() throws -> ForNode{
        do{
            try self.eat(TokenType.LBRACKET)
            try self.eat(TokenType.FOR)
            let times = try self.expr()
            try self.eat(TokenType.RBRACKET)
            try self.eat(TokenType.LBRACKET)
            let body = try self.block()
            try self.eat(TokenType.RBRACKET)
            var hasPlayerInBody = false
            for token in lexer_out{
                if [TokenType.TTS].contains(token.type){
                    hasPlayerInBody = true
                    break
                }
            }
            
            let node = ForNode(op: TokenType.FOR, times: times, body: body, hasPlayerInBody:hasPlayerInBody)
            return node
        }catch{
            throw error
        }
    }
    private func while_statement() throws -> WhileNode{
        do{
            try self.eat(TokenType.WHILE)
            try self.eat(TokenType.LBRACKET)
            let bool_statement = try self.expr()
            try  self.eat(TokenType.RBRACKET)
            try self.eat(TokenType.LBRACKET)
            let body = try self.block()
            try self.eat(TokenType.RBRACKET)
            var hasSensorInBody = false
            for token in lexer_out{
                if [TokenType.FLIPPED, TokenType.TOUCHED].contains(token.type){
                    hasSensorInBody = true
                    break
                }
            }
            let node = WhileNode(op: TokenType.WHILE,bool_statement: bool_statement,body: body, hasSensorInBody: hasSensorInBody)
            return node
        }catch{
            throw error
        }
    }
    
    private func variable() throws-> VarNode{
        do{
            let node = VarNode(token: self.current_token, memory: self.memory)
            try self.eat(TokenType.ID)
            return node
        }catch{
            throw error
        }
    }
}
