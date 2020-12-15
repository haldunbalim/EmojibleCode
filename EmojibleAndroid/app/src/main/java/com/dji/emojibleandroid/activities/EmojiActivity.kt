package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.adapters.EmojiesAdapter
import com.dji.emojibleandroid.adapters.SavedEmojiesAdapter
import com.dji.emojibleandroid.showToast
import com.dji.emojibleandroid.utils.EmojiUtils
import kotlinx.android.synthetic.main.activity_emoji.*
import kotlinx.android.synthetic.main.activity_emoji.emojiLayoutToolbar
import kotlinx.android.synthetic.main.activity_emoji.programLayoutToolbar
import kotlinx.android.synthetic.main.activity_emoji.tutorialLayoutToolbar
import kotlinx.android.synthetic.main.activity_emoji.userLayoutToolbar

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
            val intent = Intent(this, UserActivity::class.java)
            startActivity(intent)
            finish()

        }

        setupRecyclerView()
        //updateRecyclerView()

    }
/*
    private fun updateRecyclerView() {
        TODO("Not yet implemented")

    }
*/
    private fun setupRecyclerView() {


        val layoutManager1 = GridLayoutManager(this, 3, LinearLayoutManager.HORIZONTAL,  false)
        savedRecyclerView.layoutManager = layoutManager1
        val adapter1 = SavedEmojiesAdapter(this, EmojiUtils.savedEmojies)
        savedRecyclerView.adapter = adapter1


        val layoutManager2 = GridLayoutManager(this, 4, LinearLayoutManager.HORIZONTAL,  false)
        emojiRecyclerView.layoutManager = layoutManager2
        val adapter2 = EmojiesAdapter(this, EmojiUtils.emojies)
        emojiRecyclerView.adapter = adapter2


    }

}