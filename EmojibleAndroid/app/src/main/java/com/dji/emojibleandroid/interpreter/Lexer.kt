package com.dji.emojibleandroid.interpreter

import com.dji.emojibleandroid.utils.EmojiUtils
import java.lang.Exception

class Lexer(val text: String) {
    var pos: Int = 0
    var tokenTypeValues = TokenType.getValues()
    var currentLineNumber = 1
    var currentChar: String? = text[pos].toString()
    var lexedText = mutableListOf<Token>()

    companion object {
        private val colorDict = mapOf("🟦" to "Blue", "🟥" to "Red", "🟩" to "Green")
        private val boolDict = mapOf("👍" to true, "👎" to false)
    }

    private fun error() {
        throw Exception("$currentChar is an invalid character")
    }

    private fun advance() {
        pos += 1
        currentChar = if (pos > text.length - 1) {
            null
        } else {
            text[pos].toString()
        }
    }

    private fun peek(): String? {
        val peekPos = pos + 1
        if (peekPos > text.length - 1) {
            return null
        }
        return text[peekPos].toString()
    }

    private fun skipWhitespace() {
        while (currentChar != null && currentChar!![0].isWhitespace()) {
            advance()
        }
    }

    private fun skipComment() {
        while (currentChar != null && currentChar != "\n") {
            advance()
        }
    }

    private fun number(): Any {
        var result = ""
        while (currentChar != null && currentChar!![0].isDigit()) {
            result += currentChar
            advance()
        }
        return if (currentChar == ".") {
            result += currentChar
            advance()
            while (currentChar != null && currentChar!![0].isDigit()) {
                result += currentChar
                advance()
            }
            Token("REAL_CONST", result.toFloat(), currentLineNumber)
        } else {
            Token("INTEGER_CONST", result.toInt(), currentLineNumber)
        }
    }

    private fun id(): Any {
        var result = ""
        var doubleCharEmoji = currentChar + peek()
        while (currentChar != null &&
            (currentChar!![0].isLetterOrDigit()
                    || EmojiUtils.containsEmoji(currentChar!!)
                    || EmojiUtils.containsEmoji(doubleCharEmoji))
        ) {
            if (EmojiUtils.containsEmoji(doubleCharEmoji)) {
                result += doubleCharEmoji
                advance()
                advance()
                doubleCharEmoji = currentChar + peek()
            } else {
                result += currentChar
                advance()
            }
        }
        return Token(TokenType.ID.value, result, currentLineNumber)
    }

    private fun getNextToken(): Any {
        while (currentChar != null) {

            if (currentChar == " ") {
                skipWhitespace()
                continue
            }

            if (currentChar!![0].isDigit()) {
                return number()
            }

            if (currentChar + peek() in colorDict.keys) {
                val token = Token("COLOR", colorDict[currentChar + peek()], currentLineNumber)
                advance()
                advance()
                return token
            }

            if (currentChar + peek() in boolDict.keys) {
                val token = Token("BOOL_CONST", boolDict[currentChar + peek()], currentLineNumber)
                advance()
                advance()
                return token
            }

            var token = readDoubleCharSymbol()
            if (token != null) {
                if ((token as Token).type == TokenType.COMMENT) {
                    skipComment()
                    continue
                }
                return token
            }

            token = readSingleCharSymbol() as Token?
            if (token != null) {
                if (token.type == TokenType.COMMENT) {
                    skipComment()
                    continue
                }
                return token
            }

            val doubleCharEmoji = currentChar + peek()
            if (currentChar!![0].isLetter() || EmojiUtils.containsEmoji(currentChar!!) || EmojiUtils.containsEmoji(
                    doubleCharEmoji
                )
            ) return id()

            error()
        }
        return Token("EOF", null, currentLineNumber)
    }

    private fun readDoubleCharSymbol(): Any? {
        val nextChar = peek() ?: return null
        val symbol = currentChar + nextChar
        var token: Token? = null
        if (symbol in tokenTypeValues) {
            token = Token(symbol, symbol, currentLineNumber)
            advance()
            advance()
        }
        return token
    }

    private fun readSingleCharSymbol(): Any? {
        var token: Token? = null
        if (currentChar in tokenTypeValues) {
            token = currentChar?.let { Token(it, currentChar, currentLineNumber) }
            if (token?.type == TokenType.LINEBREAK) {
                currentLineNumber += 1
            }
            advance()
        }
        return token
    }

    fun lex() {
        lexedText.add(Token("PROGRAM", "PROGRAM", 0))
        while (currentChar != null) {
            lexedText.add(getNextToken() as Token)
        }
        if (lexedText[lexedText.size - 1].type != TokenType.EOF) {
            lexedText.add(Token("EOF", null, currentLineNumber + 1))
        }
    }
}