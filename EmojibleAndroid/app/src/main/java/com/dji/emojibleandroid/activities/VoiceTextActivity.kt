package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.Constants
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.showToast
import kotlinx.android.synthetic.main.activity_voicetext.*

class VoiceTextActivity: AppCompatActivity(){

    companion object{

        val TAG: String = VoiceTextActivity::class.java.simpleName

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_voicetext)

        child1LLayout.setOnClickListener {

        }

        child2LLayout.setOnClickListener {

        }

        child3LLayout.setOnClickListener {

        }

        child4LLayout.setOnClickListener {

            showToast("Kullanıcı Ayarları")
            val intent = Intent(this, NoUserActivity::class.java)
            startActivity(intent)

        }
    }

}