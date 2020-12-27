package com.dji.emojibleandroid.interpreter

import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancelAndJoin
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Semaphore


class Interpreter private constructor() {
    var job: Job? = null
    var cancelled = job?.isCancelled
    var inputSemaphore: Semaphore? = null
    private fun interpret(tree: AST) {
        tree.visit()
    }

    fun runCode(code: String) {
        val lexer = Lexer(code)
        lexer.lex()
        val localMemory =Memory(GlobalMemory.instance.assignments)
        val parser = Parser(lexer.lexedText, localMemory)
        val tree = parser.parse()
        inputSemaphore = Semaphore(1)
        GlobalScope.launch {
            interpret(tree)
        }
    }

    suspend fun finish() {
        job?.cancelAndJoin()
        inputSemaphore?.release()
    }

    private object HOLDER {
        val INSTANCE = Interpreter()
    }

    companion object {
        val instance: Interpreter by lazy { HOLDER.INSTANCE }
    }
}