package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AlertDialog
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.adapters.CreateClassAdapter
import com.dji.emojibleandroid.dataSources.TeacherClassDataSource
import com.dji.emojibleandroid.models.ClassModel
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import kotlinx.android.synthetic.main.activity_create_class.*
import kotlinx.android.synthetic.main.dialog_class_creation_texts.view.*
import java.util.*
import kotlin.collections.HashMap

class CreateClassActivity : AppCompatActivity(), Observer {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_create_class)
        NotificationCenter.instance.addObserver(Changes.teacherClassChanged, this)
        TeacherClassDataSource.instance.startObservingClass()
        setupReyclerView()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun setupReyclerView() {
        val layoutManager = GridLayoutManager(this, 1, LinearLayoutManager.VERTICAL, false)
        recyclerView.layoutManager = layoutManager
        val adapter = CreateClassAdapter(this, TeacherClassDataSource.instance.classroom.toMutableList())
        recyclerView.adapter = adapter
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

    override fun onDestroy() {
        super.onDestroy()
        TeacherClassDataSource.instance.stopObservingClass()
    }

    fun createNewClass(view: View) {
        val builder = AlertDialog.Builder(this)
        builder.setTitle("Create Class")
        val viewInflated = layoutInflater.inflate(R.layout.dialog_class_creation_texts, null)
        builder.setView(viewInflated)
        val alertDialog = builder.create()
        alertDialog.show()
        viewInflated.tapToCreateClassButton.setOnClickListener {
            val className = viewInflated.editTextClassName.text.toString()
            val classPassword = viewInflated.editTextClassPassword.text.toString()
            TeacherClassDataSource.instance.writeClass(
                className,
                classPassword
            )
            alertDialog.dismiss()
        }
        builder.setNegativeButton("Close") { _, _ -> }
    }

    override fun update(o: Observable?, arg: Any?) {
        val dict = (arg as HashMap<String, List<ClassModel>>)
        dict["teacherClassChanged"]?.toMutableList()?.let {
            (recyclerView.adapter as CreateClassAdapter).update(
                it
            )
        }
    }
}