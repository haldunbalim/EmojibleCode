package com.dji.emojibleandroid.activities

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.view.View
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.adapters.EmojiesAdapter
import com.dji.emojibleandroid.adapters.SavedEmojiesAdapter
import com.dji.emojibleandroid.dataSources.UserDataSource
import com.dji.emojibleandroid.interpreter.GlobalMemory
import com.dji.emojibleandroid.models.AssignmentModel
import com.dji.emojibleandroid.models.StudentModel
import com.dji.emojibleandroid.models.TeacherModel
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.dji.emojibleandroid.utils.EmojiUtils
import kotlinx.android.synthetic.main.activity_emoji.*
import kotlinx.android.synthetic.main.activity_grid_program.*
import kotlinx.android.synthetic.main.no_user_toolbar.*
import java.util.*

class EmojiActivity : AppCompatActivity(), Observer {

    private val REQUEST_RECORD_AUDIO_PERMISSION = 200

    private var permissionToRecordAccepted = false
    private var permissions: Array<String> = arrayOf(Manifest.permission.RECORD_AUDIO)
    private var fileName: String = ""
    private var assignments: MutableList<AssignmentModel> = mutableListOf()


    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_emoji)
        UserDataSource.instance.getCurrentUserInfo {
            if (it is StudentModel) {
                toolbarLayout.removeAllViews()
                toolbarLayout.addView(View.inflate(this, R.layout.student_toolbar, null))
            } else if (it is TeacherModel){
                toolbarLayout.removeAllViews()
                toolbarLayout.addView(View.inflate(this, R.layout.teacher_toolbar, null))
            }
        }
        fileName = "${externalCacheDir?.absolutePath}/audiorecordtest.3gp"
        NotificationCenter.instance.addObserver(Changes.assignmentsChanged, this)
        assignments = GlobalMemory.instance.assignments
        ActivityCompat.requestPermissions(this, permissions, REQUEST_RECORD_AUDIO_PERMISSION)

        setupRecyclerView()

    }

    fun openTutorialAddTab(view: View) {
        val intent = Intent(this, TutorialAddActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openProgramTab(view: View) {
        val intent = Intent(this, GridProgramActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openIDETab(view: View) {
        val intent = Intent(this, ProgramActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openTutorialTab(view: View) {
        val intent = Intent(this, TutorialActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openEmojiTab(view: View) {
        return
    }

    fun openStudentClassTab(view: View) {
        val intent = Intent(this, EnrollInClassActivity::class.java)
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

    fun openLoginTab(view: View) {
        val intent = Intent(this, LoginActivity::class.java)
        startActivity(intent)
        finish()
    }

    private fun setupRecyclerView() {


        val layoutManager1 = GridLayoutManager(this, 3, LinearLayoutManager.HORIZONTAL, false)
        savedRecyclerView.layoutManager = layoutManager1
        val adapter1 = SavedEmojiesAdapter(this, assignments, fileName)
        savedRecyclerView.adapter = adapter1


        val layoutManager2 = GridLayoutManager(this, 4, LinearLayoutManager.HORIZONTAL, false)
        emojiRecyclerView.layoutManager = layoutManager2
        val adapter2 = EmojiesAdapter(this, EmojiUtils.emojies, fileName)
        emojiRecyclerView.adapter = adapter2


    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        permissionToRecordAccepted = if (requestCode == REQUEST_RECORD_AUDIO_PERMISSION) {
            grantResults[0] == PackageManager.PERMISSION_GRANTED
        } else {
            false
        }
        if (!permissionToRecordAccepted) finish()
    }

    @RequiresApi(Build.VERSION_CODES.N)
    override fun update(o: Observable?, arg: Any?) {
        val info = arg ?: return
        when (info) {
            is AssignmentModel -> {
                GlobalMemory.instance.addAssignment(info)
            }
            is Int -> {
                GlobalMemory.instance.removeContent(assignments[info])
            }
            else -> {
                throw Exception("Unknown type of update for EmojiActivity.update")
            }
        }
        assignments = GlobalMemory.instance.assignments
        (savedRecyclerView.adapter as SavedEmojiesAdapter).update(assignments)
    }

}