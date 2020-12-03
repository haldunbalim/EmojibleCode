package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.showToast
import kotlinx.android.synthetic.main.activity_emoji.*

class EmojiActivity : AppCompatActivity(){

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_emoji)

        programLayoutToolbar.setOnClickListener {

            showToast("Program")
            val intent = Intent(this,ProgramActivity::class.java)
            startActivity(intent)
            finish()

        }

        tutorialLayoutToolbar.setOnClickListener {

            showToast("Tutorial")
            val intent = Intent(this,TutorialActivity::class.java)
            startActivity(intent)
            finish()

        }

        emojiLayoutToolbar.setOnClickListener {

            showToast("Emoji")
            val intent = Intent(this,EmojiActivity::class.java)
            startActivity(intent)
            finish()

        }

        userLayoutToolbar.setOnClickListener {

            showToast("User")
            val intent = Intent(this,NoUserActivity::class.java)
            startActivity(intent)
            finish()

        }

    }

}