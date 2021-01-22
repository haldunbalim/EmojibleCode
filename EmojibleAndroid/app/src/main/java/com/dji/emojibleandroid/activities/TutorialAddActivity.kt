package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import androidx.annotation.RequiresApi
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.adapters.TeacherTutorialAdapter
import com.dji.emojibleandroid.dataSources.TeacherTutorialDataSource
import com.dji.emojibleandroid.dataSources.UserDataSource
import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.models.ProgramModel
import com.dji.emojibleandroid.models.StudentModel
import com.dji.emojibleandroid.models.TeacherModel
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import kotlinx.android.synthetic.main.activity_tutorial_add.*
import kotlinx.android.synthetic.main.no_user_toolbar.*
import java.util.*
import kotlin.collections.HashMap

class TutorialAddActivity : AppCompatActivity(), Observer {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_tutorial_add)
        UserDataSource.instance.getCurrentUserInfo {
            if (it is StudentModel) {
                toolbarLayout.removeAllViews()
                toolbarLayout.addView(View.inflate(this, R.layout.student_toolbar, null))
            } else if (it is TeacherModel){
                toolbarLayout.removeAllViews()
                toolbarLayout.addView(View.inflate(this, R.layout.teacher_toolbar, null))
            }
        }
        NotificationCenter.instance.addObserver(Changes.teacherTutorialsChanged, this)
        TeacherTutorialDataSource.instance.startObservingTutorials()
        setupRecyclerView()
    }

    override fun onDestroy() {
        super.onDestroy()
        TeacherTutorialDataSource.instance.stopObservingTutorials()
    }

    fun openTutorialAddTab(view: View) {
        return
    }

    fun openEmojiTab(view: View) {
        val intent = Intent(this, EmojiActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openClassesTab(view: View) {
        val intent = Intent(this, CreateClassActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openUserTab(view: View) {
        val intent = Intent(this, UserActivity::class.java)
        startActivity(intent)
        finish()
    }

    private fun setupRecyclerView() {
        val layoutManager1 = GridLayoutManager(this, 2, LinearLayoutManager.VERTICAL, false)
        recyclerView.layoutManager = layoutManager1
        val pModels = TeacherTutorialDataSource.instance.tutorials.map { ProgramModel(TeacherTutorialAdapter.VIEW_TYPE_TWO, it) }.toMutableList()
        pModels.add(0, ProgramModel(TeacherTutorialAdapter.VIEW_TYPE_ONE, "", ""))
        val adapter1 = TeacherTutorialAdapter(this, pModels)
        recyclerView.adapter = adapter1
    }

    override fun update(o: Observable?, arg: Any?) {
        val programsFB = (arg as HashMap<String, List<CodeModel>>?) ?: return
        val pModels = programsFB["teacherTutorialsChanged"]?.map { ProgramModel(TeacherTutorialAdapter.VIEW_TYPE_TWO, it) }?.toMutableList()
        pModels?.add(0, ProgramModel(TeacherTutorialAdapter.VIEW_TYPE_ONE, "", ""))
        (recyclerView.adapter as TeacherTutorialAdapter).update(pModels!!)
    }
}