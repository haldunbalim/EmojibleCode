package com.dji.emojibleandroid.activities

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.adapters.ProgramsAdapter
import com.dji.emojibleandroid.dataSources.ProgramDataSource
import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.models.ProgramModel
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.dji.emojibleandroid.utils.EmojiUtils.programs
import kotlinx.android.synthetic.main.activity_emoji.emojiLayoutToolbar
import kotlinx.android.synthetic.main.activity_emoji.programLayoutToolbar
import kotlinx.android.synthetic.main.activity_emoji.tutorialLayoutToolbar
import kotlinx.android.synthetic.main.activity_emoji.userLayoutToolbar
import kotlinx.android.synthetic.main.activity_grid_program.*
import java.util.*

class GridProgramActivity : AppCompatActivity(), Observer {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_grid_program)
        NotificationCenter.instance.addObserver(Changes.programsChanged, this)
        ProgramDataSource.instance.startObservingProgram()
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
        for (program in ProgramDataSource.instance.programs) {
            programs.add(ProgramModel(ProgramsAdapter.VIEW_TYPE_TWO, program))
        }
        val adapter1 = ProgramsAdapter(this, programs)
        recyclerView.adapter = adapter1
    }

    override fun update(o: Observable?, arg: Any?) {
        val programsFB = (arg as Pair<String, List<CodeModel>>?) ?: return
        val pModels = mutableListOf<ProgramModel>()
        pModels.add(ProgramModel(ProgramsAdapter.VIEW_TYPE_ONE, "", ""))
        for (p in programsFB.second) {
            pModels.add(ProgramModel(ProgramsAdapter.VIEW_TYPE_TWO, p))
        }
        programs = pModels
        (recyclerView.adapter as ProgramsAdapter).update(programs)
    }


}