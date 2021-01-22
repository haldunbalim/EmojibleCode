//
//  TokenType.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 14.11.2020.
//

import Foundation

enum TokenType: String, CaseIterable, CustomStringConvertible{
    var description: String { return self.rawValue }
    
    case PROGRAM = "PROGRAM"
    case EOF = "EOF"
    case INTEGER_CONST = "INTEGER_CONST"
    case REAL_CONST = "REAL_CONST"
    case BOOL_CONST = "BOOL_CONST"
    case COLOR = "COLOR"
    case ID = "ID"
    case IF = "🤔"
    case WHILE = "🪐"
    case FOR = "🔁"
    case SET_SCREEN_COLOR = "📱"
    case GET_RANDOM_NUMBER = "👻"
    case GET_NUMERIC_USER_INPUT = "🔢"
    case DISPLAY = "📣"
    case PLUS = "➕"
    case MINUS = "➖"
    case AND = "&"
    case OR = "|"
    case MUL = "✖️"
    case FLOAT_DIV = "➗"
    case LPAREN = "("
    case RPAREN = ")"
    case LBRACKET = "["
    case RBRACKET = "]"
    case EQUALS = "="
    case LESSER = "<"
    case GREATER = ">"
    case LESSER_EQ = "<="
    case GREATER_EQ = ">="
    case ASSIGN = "👉"
    case LINEBREAK = "\n"
    case DOT = "."
    case COLON = ":"
    case COMMA = ","
    case COMMENT = "📝"
    
    case TOUCHED = "🤚"
    case FLIPPED = "🙃"
    case TTS = "🦜"
    
    
}
