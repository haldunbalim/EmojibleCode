package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.view.View
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.adapters.ProgramsAdapter
import com.dji.emojibleandroid.dataSources.ProgramDataSource
import com.dji.emojibleandroid.dataSources.UserDataSource
import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.models.ProgramModel
import com.dji.emojibleandroid.models.StudentModel
import com.dji.emojibleandroid.models.TeacherModel
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.dji.emojibleandroid.utils.EmojiUtils.programs
import kotlinx.android.synthetic.main.activity_grid_program.*
import kotlinx.android.synthetic.main.no_user_toolbar.*
import java.util.*

class GridProgramActivity : AppCompatActivity(), Observer {

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_grid_program)
        UserDataSource.instance.getCurrentUserInfo {
            if (it is StudentModel) {
                toolbarLayout.removeAllViews()
                toolbarLayout.addView(View.inflate(this, R.layout.student_toolbar, null))
            } else if (it is TeacherModel){
                toolbarLayout.removeAllViews()
                toolbarLayout.addView(View.inflate(this, R.layout.teacher_toolbar, null))
            }
        }
        NotificationCenter.instance.addObserver(Changes.programsChanged, this)
        ProgramDataSource.instance.startObservingProgram()
        setupRecyclerView()

    }

    fun openProgramTab(view: View) {
        return
    }

    fun openTutorialTab(view: View) {
        val intent = Intent(this, TutorialActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openEmojiTab(view: View) {
        val intent = Intent(this, EmojiActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openUserTab(view: View) {
        val intent = Intent(this, UserActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openLoginTab(view: View) {
        val intent = Intent(this, LoginActivity::class.java)
        startActivity(intent)
        finish()
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