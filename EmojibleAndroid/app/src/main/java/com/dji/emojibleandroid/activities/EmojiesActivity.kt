package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.Constants
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.showToast
import kotlinx.android.synthetic.main.activity_emojies.*

class EmojiesActivity : AppCompatActivity(){

    companion object{

        val TAG: String = EmojiesActivity::class.java.simpleName

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_emojies)

        recordVoiceImage.setOnClickListener(){

            val intent = Intent(this, NoUserActivity::class.java)
            startActivity(intent)

        }

    }

}