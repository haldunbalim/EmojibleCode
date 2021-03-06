package com.dji.emojibleandroid.activities

import android.graphics.Color
import android.media.AudioManager
import android.os.Bundle
import android.os.Looper
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.interpreter.Interpreter
import com.dji.emojibleandroid.showToast
import com.dji.emojibleandroid.utils.CodeScreenUtils
import kotlinx.android.synthetic.main.activity_code_run.*
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class CodeRunActivity : AppCompatActivity() {

    var input: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        CodeScreenUtils.runScreen = this
        setContentView(R.layout.activity_code_run)
        val code = intent.getStringExtra("CODE")
        if (code != null) {
            Interpreter.instance.runCode(code)
        } else {
            showToast("Code is null")
            finish()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        CodeScreenUtils.runScreen = null
    }

    suspend fun userInputRequested() {
        runOnUiThread {
            inputConsoleEditText.visibility = View.VISIBLE
            enterConsoleInputButton.visibility = View.VISIBLE
        }

        Interpreter.instance.inputSemaphore?.acquire()
    }

    fun changeBackgroundColor(color: String) {
        runOnUiThread {
            window.decorView.setBackgroundColor(Color.parseColor(color))
        }
    }

    fun getAudioLevel(): Int {
        val audioManager = getSystemService(AUDIO_SERVICE) as AudioManager
        return audioManager.getStreamVolume(AudioManager.STREAM_MUSIC)
    }

    fun prepareLooper() {
        if (!CodeScreenUtils.looperCalled) {
            Looper.prepare()
            CodeScreenUtils.looperCalled = true
        }
    }

    fun terminate(view: View) {
        terminate()
    }

    fun passInput(view: View) {
        runOnUiThread {
            input = inputConsoleEditText.text.toString()
            if (input.equals("")) {
                inputConsoleEditText.error = "Please enter a non empty value!"
                inputConsoleEditText.requestFocus()
            }
            inputConsoleEditText.text.clear()
            inputConsoleEditText.visibility = View.INVISIBLE
            enterConsoleInputButton.visibility = View.INVISIBLE
            Interpreter.instance.inputSemaphore?.release()
        }
    }

    fun codeFinished() {
        runOnUiThread {
            terminateButton.text = "Exit"
        }
    }

    fun terminate() {
        GlobalScope.launch {
            Interpreter.instance.finish()
        }
        finish()
    }
}