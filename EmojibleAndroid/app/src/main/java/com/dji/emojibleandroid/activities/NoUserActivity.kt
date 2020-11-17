package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.R
import kotlinx.android.synthetic.main.activity_no_user.*

class NoUserActivity : AppCompatActivity(){

    private lateinit var popupLayout: ViewGroup
    private lateinit var programLayout: ViewGroup
    private lateinit var tutorialLayout: ViewGroup
    private lateinit var emojiLayout: ViewGroup

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_no_user)

        popupLayout = findViewById(R.id.popUpLayout)
        programLayout = findViewById(R.id.programLayout)
        tutorialLayout = findViewById(R.id.tutorialLayout)
        emojiLayout = findViewById(R.id.emojiLayout)
        popupLayout.bringToFront()

        shutdownButton.setOnClickListener {

           popupLayout.visibility = View.GONE
           popupLayout.removeAllViewsInLayout()

        }

        programLayout.setOnClickListener {

            val intent = Intent(this,ProgramActivity::class.java)
            startActivity(intent)

        }

        tutorialLayout.setOnClickListener {

            val intent = Intent(this,TutorialsActivity::class.java)
            startActivity(intent)

        }

        emojiLayout.setOnClickListener {

            val intent = Intent(this,EmojiActivity::class.java)
            startActivity(intent)

        }



    }

}
