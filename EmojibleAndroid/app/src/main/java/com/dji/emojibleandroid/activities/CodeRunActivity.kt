package com.dji.emojibleandroid.activities

import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.R

class CodeRunActivity private constructor(): AppCompatActivity() {

    val userInputEditText = findViewById<EditText>(R.id.userInputEditText)
    val enterButton = findViewById<Button>(R.id.enterButton)
    val terminateButton = findViewById<Button>(R.id.terminateButton)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_code_run)
        val code = intent.getStringExtra("CODE")
    }

    private object HOLDER {
        val INSTANCE = CodeRunActivity()
    }

    companion object {
        val instance: CodeRunActivity by lazy { HOLDER.INSTANCE }
    }
}