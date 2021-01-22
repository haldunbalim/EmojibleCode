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
import com.dji.emojibleandroid.adapters.TutorialsAdapter
import com.dji.emojibleandroid.dataSources.StudentsInClassDataSource
import com.dji.emojibleandroid.dataSources.TeacherClassDataSource
import com.dji.emojibleandroid.dataSources.TeacherTutorialDataSource
import com.dji.emojibleandroid.dataSources.UserDataSource
import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import kotlinx.android.synthetic.main.activity_class_tutorials.*
import kotlinx.android.synthetic.main.activity_tutorial.*
import java.util.*
import kotlin.collections.HashMap

class ClassTutorialsActivity : AppCompatActivity(), Observer {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_class_tutorials)
        NotificationCenter.instance.addObserver(Changes.classTutorialChanged, this)
        TeacherClassDataSource.instance.startObservingClassTutorials()
        TeacherClassDataSource.instance.getClassName {
            val className = it ?: return@getClassName
            classNameInTutorialsTextView.text = "You are in class $className"
        }
        setupRecyclerView()
    }

    fun leaveClassRoom() {
        UserDataSource.instance.editUserData(hashMapOf("classId" to null))
        val intent = Intent(this, EnrollInClassActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openProgramTab(view: View) {
        val intent = Intent(this, GridProgramActivity::class.java)
        startActivity(intent)
        finish()
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

    fun openStudentClassTab(view: View) {
        return
    }

    fun openUserTab(view: View) {
        val intent = Intent(this, UserActivity::class.java)
        startActivity(intent)
        finish()
    }

    override fun onDestroy() {
        super.onDestroy()
        TeacherClassDataSource.instance.stopObservingClassTutorials()
    }

    private fun setupRecyclerView() {
        val layoutManager = GridLayoutManager(this, 2, LinearLayoutManager.VERTICAL, false)
        classTutorialRecyclerView.layoutManager = layoutManager
        val adapter = TutorialsAdapter(this, mutableListOf())
        classTutorialRecyclerView.adapter = adapter
    }

    override fun update(o: Observable?, arg: Any?) {
        val defaultTutorials = (arg as HashMap<String, List<CodeModel>>)["classTutorialChanged"]

        defaultTutorials?.toMutableList()?.let {
            (classTutorialRecyclerView.adapter as TutorialsAdapter).update(
                it
            )
        }


    }
}