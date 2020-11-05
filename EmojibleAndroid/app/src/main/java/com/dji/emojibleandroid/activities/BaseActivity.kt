package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.showToast
import kotlinx.android.synthetic.main.activity_base.*

class BaseActivity : AppCompatActivity(){

    companion object{

        val TAG: String = BaseActivity::class.java.simpleName

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_base)

        emojiButton.setOnClickListener {

            showToast("Emojies")
            Log.i(TAG,"Button was clicked")
            val intent = Intent(this, EmojiesActivity::class.java)
            startActivity(intent)


        }

        newCodeButton.setOnClickListener {

            showToast("Create your code")
            Log.i(TAG,"Button was clicked")
            val intent = Intent(this, CodeActivity::class.java)
            startActivity(intent)

        }
        tutorialButton.setOnClickListener {

            showToast("Tutorials", Toast.LENGTH_LONG)
            Log.i(TAG,"Button was clicked")
            val intent = Intent(this, TutorialsActivity::class.java)
            startActivity(intent)

        }
    }

}