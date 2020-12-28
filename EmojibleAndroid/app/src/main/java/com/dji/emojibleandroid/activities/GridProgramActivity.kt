package com.dji.emojibleandroid.activities

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.adapters.ProgramsAdapter
import com.dji.emojibleandroid.models.ProgramModel
import com.dji.emojibleandroid.utils.EmojiUtils.programs
import kotlinx.android.synthetic.main.activity_emoji.emojiLayoutToolbar
import kotlinx.android.synthetic.main.activity_emoji.programLayoutToolbar
import kotlinx.android.synthetic.main.activity_emoji.tutorialLayoutToolbar
import kotlinx.android.synthetic.main.activity_emoji.userLayoutToolbar
import kotlinx.android.synthetic.main.activity_grid_program.*

class GridProgramActivity : AppCompatActivity() {

    companion object {
        var firstTimeProgram: Int = 0
    }

override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_grid_program)

    if (firstTimeProgram == 0){
        programs.add(0, ProgramModel(ProgramsAdapter.VIEW_TYPE_ONE,"",""))
        firstTimeProgram++
    }
    setupRecyclerView()
    com.dji.emojibleandroid.utils.setupToolbar(
        this,
        programLayoutToolbar,
        tutorialLayoutToolbar,
        emojiLayoutToolbar,
        userLayoutToolbar
    )


}

    private fun setupRecyclerView() {

        val layoutManager1 = GridLayoutManager(this, 2, LinearLayoutManager.VERTICAL, false)
        recyclerView.layoutManager = layoutManager1
        val adapter1 = ProgramsAdapter(this, programs)
        recyclerView.adapter = adapter1
    }


}