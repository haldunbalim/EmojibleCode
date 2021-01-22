package com.dji.emojibleandroid.activities

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.adapters.StudentsInClassAdapter
import com.dji.emojibleandroid.dataSources.StudentsInClassDataSource
import com.dji.emojibleandroid.models.StudentModel
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import kotlinx.android.synthetic.main.activity_students_in_class.*
import java.util.*
import kotlin.collections.HashMap

class StudentsInClassActivity : AppCompatActivity(), Observer {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_students_in_class)
        val className = intent.getStringExtra("className")
        val classId = intent.getStringExtra("classId")
        inClassNameTextView.text = "Class Name: $className"
        inClassIdTextView.text = "Class Id: $classId"
        NotificationCenter.instance.addObserver(Changes.studentsInClassChanged, this)
        classId?.let { StudentsInClassDataSource.instance.startObservingStudentsInAClass(it) }
        setupRecyclerView()
    }

    private fun setupRecyclerView() {
        val layoutManager = GridLayoutManager(this, 1, LinearLayoutManager.VERTICAL, false)
        recyclerView.layoutManager = layoutManager
        val adapter = StudentsInClassAdapter(this, mutableListOf())
        recyclerView.adapter = adapter
    }

    override fun onDestroy() {
        super.onDestroy()
        StudentsInClassDataSource.instance.stopObservingStudentsInAClass()
    }

    fun openTutorialAddTab(view: View) {
        val intent = Intent(this, TutorialAddActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openEmojiTab(view: View) {
        val intent = Intent(this, EmojiActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openClassesTab(view: View) {
        return
    }

    fun openUserTab(view: View) {
        val intent = Intent(this, UserActivity::class.java)
        startActivity(intent)
        finish()
    }

    override fun update(o: Observable?, arg: Any?) {
        val students = (arg as HashMap<String, List<StudentModel>?>)["studentsInClassChanged"]
        students?.let {
            (recyclerView.adapter as StudentsInClassAdapter).update(
                it.toMutableList()
            )
        }
    }
}