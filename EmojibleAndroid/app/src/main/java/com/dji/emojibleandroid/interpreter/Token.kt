package com.dji.emojibleandroid.interpreter

class Token(private val t: String, val value: Any?, val lineNumber: Int){
    val type: TokenType = TokenType.fromValue(t)!!
    override fun toString(): String = "Token(${type}, ${value.toString()})"
}