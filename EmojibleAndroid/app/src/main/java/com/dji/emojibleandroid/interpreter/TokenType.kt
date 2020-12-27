package com.dji.emojibleandroid.interpreter

enum class TokenType constructor(val value: String) {
    PROGRAM("PROGRAM"),
    EOF("EOF"),
    INTEGER_CONST("INTEGER_CONST"),
    REAL_CONST("REAL_CONST"),
    BOOL_CONST("BOOL_CONST"),
    COLOR("COLOR"),
    ID("ID"),
    IF("🤔"),
    WHILE("🪐"),
    FOR("🔁"),
    SET_SCREEN_COLOR("📱"),
    GET_RANDOM_NUMBER("👻"),
    GET_NUMERIC_USER_INPUT("🔢"),
    PLUS("➕"),
    MINUS("➖"),
    MUL("✖️"),
    FLOAT_DIV("➗"),
    LPAREN("("),
    RPAREN(")"),
    LBRACKET("["),
    RBRACKET("]"),
    EQUALS("="),
    LESSER("<"),
    GREATER(">"),
    LESSER_EQ("<="),
    GREATER_EQ(">="),
    ASSIGN("👉"),
    LINEBREAK("\n"),
    DOT("."),
    COLON(":"),
    COMMA(","),
    COMMENT("📝");

    companion object {
        private val map = TokenType.values()
        fun fromValue(value: String) = map.associateBy(TokenType::value)[value]
        fun getMembers() = map.asList()
        fun getValues() = map.map { it -> it.value }.toList()
    }
}