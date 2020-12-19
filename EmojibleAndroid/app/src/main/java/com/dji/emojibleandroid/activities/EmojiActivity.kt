package com.dji.emojibleandroid.activities

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.media.MediaPlayer
import android.media.MediaRecorder
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.adapters.EmojiesAdapter
import com.dji.emojibleandroid.adapters.SavedEmojiesAdapter
import com.dji.emojibleandroid.showToast
import com.dji.emojibleandroid.utils.EmojiUtils
import kotlinx.android.synthetic.main.activity_emoji.*
import kotlinx.android.synthetic.main.activity_emoji.emojiLayoutToolbar
import kotlinx.android.synthetic.main.activity_emoji.programLayoutToolbar
import kotlinx.android.synthetic.main.activity_emoji.tutorialLayoutToolbar
import kotlinx.android.synthetic.main.activity_emoji.userLayoutToolbar
import kotlinx.android.synthetic.main.activity_no_user.*
import kotlinx.android.synthetic.main.activity_user.*

class EmojiActivity : AppCompatActivity(){

    private val REQUEST_RECORD_AUDIO_PERMISSION = 200

    private var permissionToRecordAccepted = false
    private var permissions: Array<String> = arrayOf(Manifest.permission.RECORD_AUDIO)
    private var fileName: String = ""


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_emoji)
        fileName = "${externalCacheDir?.absolutePath}/audiorecordtest.3gp"

        ActivityCompat.requestPermissions(this, permissions, REQUEST_RECORD_AUDIO_PERMISSION)

        setupRecyclerView()
        com.dji.emojibleandroid.utils.setupToolbar(
            this,
            programLayoutToolbar,
            tutorialLayoutToolbar,
            emojiLayoutToolbar,
            userLayoutToolbar
        )
        //updateRecyclerView()

    }

    private fun setupRecyclerView() {


        val layoutManager1 = GridLayoutManager(this, 3, LinearLayoutManager.HORIZONTAL,  false)
        savedRecyclerView.layoutManager = layoutManager1
        val adapter1 = SavedEmojiesAdapter(this, EmojiUtils.savedEmojies,fileName)
        savedRecyclerView.adapter = adapter1


        val layoutManager2 = GridLayoutManager(this, 4, LinearLayoutManager.HORIZONTAL,  false)
        emojiRecyclerView.layoutManager = layoutManager2
        val adapter2 = EmojiesAdapter(this, EmojiUtils.emojies,fileName)
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

}