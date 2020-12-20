package com.dji.emojibleandroid.activities

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.media.MediaPlayer
import android.media.MediaRecorder
import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.adapters.EmojiesAdapter
import com.dji.emojibleandroid.adapters.SavedEmojiesAdapter
import com.dji.emojibleandroid.interpreter.GlobalMemory
import com.dji.emojibleandroid.models.AssignmentModel
import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.dji.emojibleandroid.showToast
import com.dji.emojibleandroid.utils.EmojiUtils
import kotlinx.android.synthetic.main.activity_emoji.*
import kotlinx.android.synthetic.main.activity_emoji.emojiLayoutToolbar
import kotlinx.android.synthetic.main.activity_emoji.programLayoutToolbar
import kotlinx.android.synthetic.main.activity_emoji.tutorialLayoutToolbar
import kotlinx.android.synthetic.main.activity_emoji.userLayoutToolbar
import kotlinx.android.synthetic.main.activity_no_user.*
import kotlinx.android.synthetic.main.activity_user.*
import java.util.*

class EmojiActivity : AppCompatActivity(), Observer {

    private val REQUEST_RECORD_AUDIO_PERMISSION = 200

    private var permissionToRecordAccepted = false
    private var permissions: Array<String> = arrayOf(Manifest.permission.RECORD_AUDIO)
    private var fileName: String = ""
    private var assignments: MutableList<AssignmentModel> = mutableListOf()


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_emoji)
        fileName = "${externalCacheDir?.absolutePath}/audiorecordtest.3gp"
        NotificationCenter.instance.addObserver(Changes.assignmentsChanged, this)
        assignments = GlobalMemory.instance.assignments
        ActivityCompat.requestPermissions(this, permissions, REQUEST_RECORD_AUDIO_PERMISSION)

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