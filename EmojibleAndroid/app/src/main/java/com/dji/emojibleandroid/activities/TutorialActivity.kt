package com.dji.emojibleandroid.activities


import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.adapters.TutorialsAdapter
import com.dji.emojibleandroid.dataSources.TutorialDataSource
import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import kotlinx.android.synthetic.main.activity_tutorial.*
import java.util.*

class TutorialActivity : AppCompatActivity(), Observer {

    var tutorials: MutableList<CodeModel> = mutableListOf()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_tutorial)
        NotificationCenter.instance.addObserver(Changes.defaultTutorialsChanged, this)
        TutorialDataSource.instance.startObservingProgram()

        com.dji.emojibleandroid.utils.setupToolbar(
            this,
            programLayoutToolbar,
            tutorialLayoutToolbar,
            emojiLayoutToolbar,
            userLayoutToolbar
        )
        setupRecyclerView()

    }

    private fun setupRecyclerView() {
        val layoutManager = GridLayoutManager(this, 2, LinearLayoutManager.VERTICAL, false)
        recyclerView.layoutManager = layoutManager
        val adapter = TutorialsAdapter(this, tutorials)
        recyclerView.adapter = adapter
    }

    override fun update(o: Observable?, arg: Any?) {
        val defaultTutorials = (arg as Pair<String, List<CodeModel>>?) ?: return
        tutorials = defaultTutorials.second.toMutableList()
        (recyclerView.adapter as TutorialsAdapter).update(tutorials)
    }


}