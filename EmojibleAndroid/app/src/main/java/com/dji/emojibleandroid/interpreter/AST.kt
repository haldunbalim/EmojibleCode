package com.dji.emojibleandroid.interpreter

import com.dji.emojibleandroid.models.AssignmentModel
import com.dji.emojibleandroid.models.Value
import com.dji.emojibleandroid.models.ValueType
import com.dji.emojibleandroid.utils.CodeScreenUtils

val runScreen = CodeScreenUtils.runScreen
val cancelled = Interpreter.instance.job!!.isCancelled

abstract class AST {
    open suspend fun visit(): Any? {
        return null
    }

    suspend fun safeVisit(): Any? {
        if (cancelled) {
            return null
        }
        return visit()
    }
}

class BinOpNode(private val left: AST, private val op: Token, private val right: AST) : AST() {
    val token: Token = op
    override suspend fun visit(): Any? {
        val leftVal = left.safeVisit() as Value?
        val rightVal = right.safeVisit() as Value?
        println(leftVal?.javaClass?.name)
        if (leftVal == null) {
            throw Exception("Left element of the binary operation is null")
        }
        if (rightVal == null) {
            throw Exception("Right element of the binary operation is null")
        }
        if ((leftVal.type == ValueType.Float) || rightVal.type == ValueType.Float) {
            return visitFloat(leftVal.value as Float, rightVal.value as Float)
        } else if (leftVal.type == ValueType.Integer && rightVal.type == ValueType.Integer) {
            return visitInt(leftVal.value as Int, rightVal.value as Int)
        }
        throw Exception("Unknown type for binary operation")
    }

    private fun visitFloat(leftVal: Float, rightVal: Float): Any? {
        return when (op.type) {
            TokenType.PLUS -> leftVal + rightVal
            TokenType.MINUS -> leftVal - rightVal
            TokenType.MUL -> leftVal * rightVal
            TokenType.FLOAT_DIV -> leftVal / rightVal
            TokenType.EQUALS -> leftVal == rightVal
            TokenType.LESSER_EQ -> leftVal <= rightVal
            TokenType.GREATER_EQ -> leftVal >= rightVal
            TokenType.LESSER -> leftVal < rightVal
            TokenType.GREATER -> leftVal > rightVal
            else -> null
        }
    }

    private fun visitInt(leftVal: Int, rightVal: Int): Any? {
        val result = visitFloat(leftVal.toFloat(), rightVal.toFloat())
        if (result is Boolean)
            return result


        if (result is Float && (result - result.toInt()) == 0.toFloat())
            return result.toInt()

        return result
    }
}

open class ValueNode(private val token: Token) : AST() {
    val value: Any? = token.value
    override suspend fun visit(): Any? {
        return token.value
    }

}

class NumNode(token: Token) : ValueNode(token)
class BoolNode(token: Token) : ValueNode(token)
class ColorNode(token: Token) : ValueNode(token)
class GetNumericUserInputNode(val tokenType: TokenType) : AST() {
    override suspend fun visit(): Any? {
        CodeScreenUtils.runScreen?.userInputRequested()
        Interpreter.instance.inputSemaphore?.acquire()
        if (cancelled)
            return null
        var userInput = CodeScreenUtils.runScreen?.input
        while (userInput == "") {
            Interpreter.instance.inputSemaphore?.release()
            CodeScreenUtils.runScreen?.userInputRequested()
            Interpreter.instance.inputSemaphore?.acquire()
            userInput = CodeScreenUtils.runScreen?.input
        }
        Interpreter.instance.inputSemaphore?.release()
        return when {
            userInput?.toIntOrNull() != null -> {
                userInput.toInt()
            }
            userInput?.toFloatOrNull() != null -> {
                userInput.toFloat()
            }
            else -> {
                null
            }
        }
    }
}

class SetScreenColorNode(val tokenType: TokenType, color: ColorNode) : AST() {
    val color: String = color.value as String
    override suspend fun visit(): Any? {
        CodeScreenUtils.runScreen?.changeBackgroundColor(color)
        return null
    }
}

class UnaryOpNode(private val op: Token, private val expr: AST) : AST() {
    override suspend fun visit(): Any? {
        val num = expr.safeVisit()
        if (num is Int) {
            if (op.type == TokenType.PLUS)
                return +num
            else if (op.type == TokenType.MINUS)
                return -num
        }
        if (num is Float) {
            if (op.type == TokenType.PLUS)
                return +num
            else if (op.type == TokenType.MINUS)
                return -num
        }
        return null
    }
}

class CompoundNode() : AST() {
    val children: MutableList<AST> = mutableListOf()
    override suspend fun visit(): Any? {
        for (child in children) {
            child.safeVisit()
            if (cancelled)
                return null
        }
        return null
    }
}

class AssignNode(
    private val left: VarNode,
    op: Token,
    private val right: AST,
    private val memory: Memory
) : AST() {
    val token: Token = op
    override suspend fun visit(): Any? {
        val varName = left.value
        val varValue = right.visit()
        if (cancelled)
            return null
        varValue?.let { AssignmentModel(varName as CharSequence, it) }?.let {
            memory.addAssignment(
                it
            )
        }
        return null
    }
}

class GetRandomNumberNode(
    token: TokenType,
    private val lowerBound: AST,
    private val upperBound: AST
) : AST() {
    val op: TokenType = token
    override suspend fun visit(): Any {
        val lowerBound = lowerBound.safeVisit()
        val upperBound = upperBound.safeVisit()
        if (lowerBound !is Int && !(lowerBound is Float && lowerBound as Int == lowerBound)) {
            throw Exception("Random number cannot be called with non integer lower bound")
        } else if (upperBound !is Int && !(upperBound is Float && upperBound as Int == upperBound)) {
            throw Exception("Random number cannot be called with non integer upper bound")
        }
        if (lowerBound >= upperBound)
            throw Exception("lowerBound $lowerBound must be lower than upperBound $upperBound")
        return (lowerBound..upperBound).random()
    }
}

class IfNode(
    val op: TokenType,
    private val boolStatement: AST,
    private val trueStatement: BlockNode,
    var falseStatement: AST?
) : AST() {
    init {
        falseStatement = if (falseStatement != null) falseStatement as BlockNode else NoOpNode()
    }

    override suspend fun visit() {
        val boolSt = boolStatement.safeVisit()
        if (boolSt !is Boolean) {
            throw Exception("The statement after for keyword must be a boolean")
        }
        if (boolSt) {
            trueStatement.safeVisit()
        } else {
            falseStatement?.safeVisit()
        }
    }
}

class ForNode(op: TokenType, val times: AST, private val body: BlockNode) : AST() {
    val token: TokenType = op
    override suspend fun visit(): Any? {
        val times = times.safeVisit()
        if (times !is Int || (times is Float && times == times as Int)) {
            throw Exception("$times is not an integer")
        }
        for (i in 0..times) {
            body.safeVisit()
            if (cancelled)
                return null
        }
        return null
    }
}

class WhileNode(op: TokenType, private val boolStatement: AST, private val body: AST) : AST() {
    val token: TokenType = op
    override suspend fun visit() {
        while (true) {
            val boolCond = boolStatement.safeVisit()
            if (boolCond !is Boolean) {
                throw Exception("$boolCond is not a boolean")
            }
            if (boolCond) {
                break
            }
            body.safeVisit()
        }
    }
}

class VarNode(token: Token, private val memory: Memory) : AST() {
    val value: Any? = token.value
    override suspend fun visit(): Any {
        val varName = value as CharSequence
        for (assignment in memory.assignments) {
            if (assignment.identifier == varName) {
                return assignment.value
            }
        }
        throw Exception("$varName is an undefined variable")
    }
}

class NoOpNode() : AST() {
    override suspend fun visit() {}
}

class ProgramNode(private val blockNode: BlockNode) : AST() {
    override suspend fun visit() {
        blockNode.safeVisit()
    }
}

class BlockNode(private val compoundNodeStatement: CompoundNode) : AST() {
    //    var declarations: MutableList<AST> = mutableListOf()
    override suspend fun visit() {
        compoundNodeStatement.safeVisit()
    }
}

