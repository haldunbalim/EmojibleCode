package com.dji.emojibleandroid.activities


import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.adapters.TutorialsAdapter
import com.dji.emojibleandroid.models.Supplier
import com.dji.emojibleandroid.showToast
import kotlinx.android.synthetic.main.activity_list_emojies.*
import kotlinx.android.synthetic.main.activity_tutorial.*

class TutorialActivity : AppCompatActivity(){

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_tutorial)

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
            val intent = Intent(this,UserActivity::class.java)
            startActivity(intent)
            finish()

        }

        setupRecyclerView()


    }

    private fun setupRecyclerView() {
        val layoutManager = LinearLayoutManager(this,  LinearLayoutManager.VERTICAL,  false)
        recyclerView.layoutManager = layoutManager
        val adapter = TutorialsAdapter(this, Supplier.tutorials)
        recyclerView.adapter = adapter
    }


}