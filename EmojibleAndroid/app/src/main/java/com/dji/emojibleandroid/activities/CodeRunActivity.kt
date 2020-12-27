package com.dji.emojibleandroid.activities

import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.EditText
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.R

class CodeRunActivity : AppCompatActivity() {

    val userInputEditText by lazy { findViewById<EditText>(R.id.userInputEditText) }
    val enterButton by lazy { findViewById<Button>(R.id.userInputEditText) }
    val terminateButton by lazy { findViewById<Button>(R.id.terminateButton) }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_code_run)
        val code = intent.getStringExtra("CODE")
    }

    fun terminate(view: View) {
        finish()
    }
}