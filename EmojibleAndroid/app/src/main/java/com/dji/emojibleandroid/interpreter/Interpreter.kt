package com.dji.emojibleandroid.interpreter

import com.dji.emojibleandroid.showToast
import com.dji.emojibleandroid.utils.CodeScreenUtils
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancelAndJoin
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Semaphore
import java.lang.Exception


class Interpreter private constructor() {
    var job: Job? = null
    var inputSemaphore: Semaphore? = null
    private suspend fun interpret(tree: AST) {
        tree.visit()
    }

    fun runCode(code: String) {
        var tree: ProgramNode? = null
        try {
            val lexer = Lexer(code)
            lexer.lex()
            val localMemory = Memory(GlobalMemory.instance.assignments)
            val parser = Parser(lexer.lexedText, localMemory)
            tree = parser.parse()
        } catch (e: Exception) {
            CodeScreenUtils.runScreen?.showToast("An error occurred due to ${e.message}")
        }
        inputSemaphore = Semaphore(1)
        if (tree != null){
            job = GlobalScope.launch {
                try {
                    interpret(tree)
                    CodeScreenUtils.runScreen?.codeFinished()
                } catch (e: Exception) {
                    if (e.message != "StandaloneCoroutine was cancelled") {
                        CodeScreenUtils.runScreen?.prepareLooper()
                        CodeScreenUtils.runScreen?.showToast("An error occurred due to ${e.message}")
                    }
                }
            }
        } else {
            CodeScreenUtils.runScreen?.codeFinished()
            CodeScreenUtils.runScreen?.terminate()
        }
    }

    suspend fun finish() {
        job?.cancelAndJoin()
    }

    private object HOLDER {
        val INSTANCE = Interpreter()
    }

    companion object {
        val instance: Interpreter by lazy { HOLDER.INSTANCE }
    }
}