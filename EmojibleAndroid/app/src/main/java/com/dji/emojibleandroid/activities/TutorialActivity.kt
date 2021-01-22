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
import com.dji.emojibleandroid.adapters.TutorialsAdapter
import com.dji.emojibleandroid.dataSources.TutorialDataSource
import com.dji.emojibleandroid.dataSources.UserDataSource
import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.models.StudentModel
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import kotlinx.android.synthetic.main.activity_tutorial.*
import kotlinx.android.synthetic.main.no_user_toolbar.*
import java.util.*

class TutorialActivity : AppCompatActivity(), Observer {

    var tutorials: MutableList<CodeModel> = mutableListOf()

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_tutorial)
        UserDataSource.instance.getCurrentUserInfo {
            if (it is StudentModel) {
                toolbarLayout.removeAllViews()
                toolbarLayout.addView(View.inflate(this, R.layout.student_toolbar, null))
            }
        }
        NotificationCenter.instance.addObserver(Changes.defaultTutorialsChanged, this)
        TutorialDataSource.instance.startObservingProgram()
        setupRecyclerView()
    }

    fun openIDETab(view: View) {
        val intent = Intent(this, ProgramActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openTutorialTab(view: View) {
        return
    }

    fun openEmojiTab(view: View) {
        val intent = Intent(this, EmojiActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openStudentClassTab(view: View) {
        val intent = Intent(this, EnrollInClassActivity::class.java)
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