package com.dji.emojibleandroid.interpreter

import com.dji.emojibleandroid.activities.CodeRunActivity
import com.dji.emojibleandroid.models.AssignmentModel
import java.lang.Exception

val runScreen = CodeRunActivity()
val cancelled = Interpreter.instance.cancelled

abstract class AST {
    open fun visit(): Any? {
        return null
    }

    fun safeVisit() : Any? {
        if (cancelled!!) {
            return null
        }
        return visit()
    }
}

class BinOpNode(val left: AST, val op: Token, val right: AST) : AST() {
    val token: Token = op
    override fun visit(): Any? {
        when (op.type) {
            TokenType.PLUS -> {
                return left.visit() as Float + right.visit() as Float
            }
            TokenType.MINUS -> {
                return left.visit() as Float - right.visit() as Float
            }
            TokenType.MUL -> {
                return left.visit() as Float * right.visit() as Float
            }
            TokenType.FLOAT_DIV -> {
                return left.visit() as Float / right.visit() as Float
            }
            TokenType.EQUALS -> {
                return left.visit() == right.visit()
            }
            TokenType.LESSER_EQ -> {
                return left.visit() as Float <= right.visit() as Float
            }
            TokenType.GREATER_EQ -> {
                return left.visit() as Float >= right.visit() as Float
            }
            TokenType.LESSER -> {
                return (left.visit() as Float) < (right.visit() as Float)
            }
            TokenType.GREATER -> {
                return left.visit() as Float > right.visit() as Float
            }
            else -> {
                return null
            }
        }
    }
}

open class ValueNode(val token: Token) : AST() {
    val value: Any? = token.value
    override fun visit(): Any? {
        return token.value
    }

}

class NumNode(token: Token) : ValueNode(token)
class BoolNode(token: Token) : ValueNode(token)
class ColorNode(token: Token) : ValueNode(token)
class GetNumericUserInputNode(val tokenType: TokenType) : AST() {
    override fun visit(): Any {
        return readLine()!!.toFloat()
    }
}

class SetScreenColorNode(val tokenType: TokenType, color: ColorNode) : AST() {
    val color: String = color.value as String
    override fun visit() {
        println("Screen color is set to $color")
    }
}

class UnaryOpNode(val op: Token, val expr: AST) : AST() {
    override fun visit(): Any? {
        return when (op.type) {
            TokenType.PLUS -> +(expr.visit() as Float)
            TokenType.MINUS -> -(expr.visit() as Float)
            else -> null
        }
    }
}

class CompoundNode() : AST() {
    val children: MutableList<AST> = mutableListOf()
    override fun visit() {
        for (child in children) {
            child.visit()
        }
    }
}

class AssignNode(val left: VarNode, val op: Token, val right: AST, val memory: Memory) : AST() {
    val token: Token = op
    override fun visit(): Any? {
        val varName = (left as VarNode).value
        val varValue = right.visit()
        TODO("Implement global variables")

        varValue?.let { AssignmentModel(varName as CharSequence, it) }?.let {
            memory.addAssignment(
                it
            )
        }
        return null
    }
}

class GetRandomNumberNode(val token: TokenType, val lowerBound: AST, val upperBound: AST) : AST() {
    val op: TokenType = token
    override fun visit(): Any {
        val lowerBound = this.lowerBound.visit()
        val upperBound = this.upperBound.visit()
        if (lowerBound !is Int && !(lowerBound is Float && lowerBound as Int == lowerBound)) {
            throw Exception("Random number cannot be called with non integer lower bound")
        } else if (upperBound !is Int && !(upperBound is Float && upperBound as Int == upperBound)) {
            throw Exception("Random number cannot be called with non integer upper bound")
        }
        return (lowerBound..upperBound).random()
    }
}

class IfNode(
    val op: TokenType,
    val boolStatement: AST,
    val trueStatement: BlockNode,
    var falseStatement: AST?
) : AST() {
    init {
        falseStatement = if (falseStatement != null) falseStatement else NoOpNode()
    }

    override fun visit() {
        if (boolStatement.visit() as Boolean) {
            trueStatement.visit()
        } else {
            falseStatement!!.visit()
        }
    }
}

class ForNode(val op: TokenType, val times: AST, val body: BlockNode) : AST() {
    val token: TokenType = op
    override fun visit() {
        val times = times.visit()
        if (times !is Int || (times is Float && times == times as Int)) {
            throw Exception("$times is not an integer")
        }
        for (i in 0..times) {
            body.visit()
        }
    }
}

class WhileNode(val op: TokenType, val boolStatement: AST, val body: AST) : AST() {
    val token: TokenType = op
    override fun visit() {
        while (true) {
            var boolCond = boolStatement.visit()
            if (boolCond !is Boolean) {
                throw Exception("$boolCond is not a boolean")
            }
            if (boolCond) {
                break
            }
            body.visit()
        }
    }
}

class VarNode(val token: Token) : AST() {
    val value: Any? = token.value
    override fun visit(): Any? {
        TODO()
//        var varName = value
//        if (varName !in GLOBAL_MEMORY) {
//            throw Exception("$varName is an undefined variable")
//        }
//        val varValue = GLOBAL_MEMORY.get(varName)
//        return varValue
    }
}

class NoOpNode() : AST() {
    override fun visit() {}
}

class ProgramNode(val blockNode: BlockNode) : AST() {
    override fun visit() {
        blockNode.visit()
    }
}

class BlockNode(val compoundNodeStatement: CompoundNode) : AST() {
    var declarations: MutableList<AST> = mutableListOf()
    override fun visit() {
        compoundNodeStatement.visit()
    }
}

