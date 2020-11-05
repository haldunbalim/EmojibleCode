package com.dji.emojibleandroid.activities

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.showToast
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    companion object{
        val TAG: String = MainActivity::class.java.simpleName
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        teacherButton.setOnClickListener(){

            showToast("Teachers")
            Log.i(TAG,"Button was clicked")
            val intent = Intent(this, LoginActivity::class.java)
            startActivity(intent)
            finish()

        }

        studentButton.setOnClickListener(){

            showToast("Students")
            Log.i(TAG,"Button was clicked")
            val intent = Intent(this, LoginActivity::class.java)
            startActivity(intent)
            finish()

        }

    }
}
