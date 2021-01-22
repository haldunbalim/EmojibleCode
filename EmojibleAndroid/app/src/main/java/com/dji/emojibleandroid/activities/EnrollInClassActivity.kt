package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.view.View
import androidx.annotation.RequiresApi
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.dataSources.TeacherClassDataSource
import com.dji.emojibleandroid.dataSources.UserDataSource
import com.dji.emojibleandroid.extensions.AppCompatActivityWithAlerts
import com.dji.emojibleandroid.extensions.hideProgressBar
import com.dji.emojibleandroid.extensions.showProgressBar
import com.dji.emojibleandroid.models.StudentModel
import com.dji.emojibleandroid.services.NotificationCenter
import com.dji.emojibleandroid.showToast
import kotlinx.android.synthetic.main.activity_enroll_in_class.*
import kotlinx.android.synthetic.main.dialog_class_creation_texts.*

class EnrollInClassActivity : AppCompatActivityWithAlerts() {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_enroll_in_class)
        UserDataSource.instance.getCurrentUserInfo {
            val studentModel = it as? StudentModel
            if (studentModel?.classId != null) {
                val intent = Intent(this, ClassTutorialsActivity::class.java)
                startActivity(intent)
                finish()
            }
        }
    }

    fun signUpButtonPressed(view: View) {
        val classId = editTextClassIdforStudent.text.toString()
        if (classId == "") {
            editTextClassIdforStudent.error = "Class code cannot be empty"
            editTextClassIdforStudent.requestFocus()
            return
        }
        val classPassword = editTextClassPasswordForStudent.text.toString()
        if (classPassword == "") {
            editTextClassPassword.error = "Class password cannot be empty"
            editTextClassPassword.requestFocus()
            return
        }
        showProgressBar()
        TeacherClassDataSource.instance.addStudent(classId, classPassword) { error ->
            hideProgressBar()
            if (error != null) {
                showToast("Error while signing up $error")
            } else {
                val intent = Intent(this, ClassTutorialsActivity::class.java)
                startActivity(intent)
                finish()
            }
        }

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
}