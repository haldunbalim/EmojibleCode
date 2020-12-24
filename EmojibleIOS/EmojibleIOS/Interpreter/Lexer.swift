//
//  Lexer.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 3.12.2020.
//

import Foundation

fileprivate let colorDict: [Character:String] = ["🟦": "Blue","🟥": "Red","🟩": "Green"]
fileprivate let boolDict: [Character:Bool] = ["👍": true,"👎": false]

class Lexer:CustomStringConvertible{
    var text:String
    var pos = 0
    var token_type_values = TokenType.allCases
    var currentLineNumber = 1
    var currentChar: Character?
    var lexedText:[Token] = []
    
    init(text:String) {
        self.text = text
        self.currentChar = self.text[self.pos]
    }
    
    private func error(){
        //TODO
        print("error")
    }
    
    private func advance(){
        self.pos += 1
        if self.pos > self.text.count - 1{
            self.currentChar = nil
        }else{
            self.currentChar = self.text[self.pos]
        }
    }
    
    
    private func peek() -> Character?{
        let peekPos = self.pos + 1
        if peekPos > self.text.count - 1{
            return nil
        }else{
            return self.text[peekPos]
        }
    }
    
    private func skipWhitespace(){
        while let currentChar = self.currentChar, currentChar.isWhitespace{
            self.advance()
        }
    }
    
    private func skipComment(){
        while self.currentChar != nil  && self.currentChar! != "\n"{
            self.advance()
        }
    }
    
    private func number()->Token{
        var result = ""
        while let currentChar = self.currentChar, currentChar.isNumber{
            result += String(describing: currentChar)
            self.advance()
        }
        if currentChar! == "."{
            result += String(describing: currentChar)
            self.advance()
            while let currentChar = self.currentChar, currentChar.isNumber{
                result += String(describing: currentChar)
                self.advance()
            }
            return Token(type: "REAL_CONST", value: Float(result)!, lineNumber: self.currentLineNumber)
        }else{
            return Token(type: "INTEGER_CONST", value: Int(result)!, lineNumber: self.currentLineNumber)
        }
    }

    private func id() -> Token{
        var result = ""
        while let currentChar = self.currentChar, EmojiChecker.getInstance().isValidIdentifier(String(describing:currentChar)){
            result += String(describing: currentChar)
            self.advance()
        }
        return Token(type: "ID", value: result, lineNumber: self.currentLineNumber)
    }
    
    private func readDoubleCharSymbol() -> Token?{
        guard let nextChar = self.peek() else {return nil}
        let symbol = "\(String(describing: self.currentChar!))\(String(describing: nextChar))"
        if let type = TokenType(rawValue: symbol){
            let token = Token(type: type.rawValue, value: type.rawValue, lineNumber: self.currentLineNumber)
            self.advance()
            self.advance()
            return token
        }else{
            return nil
        }
        
    }
        
    
    private func readSingleCharSymbol() -> Token?{
        guard let currentChar = self.currentChar else { return nil }
        if let symbol = TokenType(rawValue: String(describing:currentChar)){
            let token = Token(type: symbol.rawValue, value: symbol.rawValue, lineNumber: self.currentLineNumber)
            if token.type == TokenType.LINEBREAK{
                self.currentLineNumber += 1
            }
            self.advance()
            return token
        }else{
            return nil
        }
    }
    
    private func getNextToken() -> Token?{
        while let currentChar = self.currentChar{

            if currentChar == " "{
                self.skipWhitespace()
                continue
            }

            if currentChar.isNumber{
                return self.number()
            }

            if let color = colorDict[self.currentChar!]{
                let token = Token(type: "COLOR", value: color, lineNumber: self.currentLineNumber)
                self.advance()
                return token
            }

            if let bool = boolDict[currentChar]{
                let token = Token(type: "BOOL_CONST", value:bool, lineNumber: self.currentLineNumber)
                self.advance()
                return token
            }

            var token = self.readDoubleCharSymbol()
            if token != nil{
                return token!
            }

            token = self.readSingleCharSymbol()
            if token != nil{
                if token!.type == TokenType.COMMENT{
                    self.skipComment()
                    continue
                }
                return token!
            }

            if EmojiChecker.getInstance().isValidIdentifier(String(describing:self.currentChar!)){
                return self.id()
            }

            self.error()
        }
        return nil
    }
    
    func lex(){
        self.lexedText.append(Token(type: "PROGRAM", value: "PROGRAM",lineNumber: 0))
        while self.currentChar != nil{
            if let token = self.getNextToken(){
                self.lexedText.append(token)
            }
        }
        self.lexedText.append(Token(type: "EOF", value: "EOF", lineNumber: self.currentLineNumber+1))
    }
    
    public var description: String { return self.lexedText.description}
    
    
}
