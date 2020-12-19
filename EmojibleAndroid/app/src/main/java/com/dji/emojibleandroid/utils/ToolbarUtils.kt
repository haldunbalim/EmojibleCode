package com.dji.emojibleandroid.utils

import android.content.Intent
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.activities.EmojiActivity
import com.dji.emojibleandroid.activities.ProgramActivity
import com.dji.emojibleandroid.activities.TutorialActivity
import com.dji.emojibleandroid.activities.UserActivity


fun setupToolbar(context: AppCompatActivity, programLayoutToolbar: View, tutorialLayoutToolbar: View, emojiLayoutToolbar: View, userLayoutToolbar: View){

    programLayoutToolbar.setOnClickListener {
        val intent = Intent(context, ProgramActivity::class.java)
        context.startActivity(intent)
        context.finish()
    }

    tutorialLayoutToolbar.setOnClickListener {
        val intent = Intent(context, TutorialActivity::class.java)
        context.startActivity(intent)
        context.finish()
    }

    emojiLayoutToolbar.setOnClickListener {
        val intent = Intent(context, EmojiActivity::class.java)
        context.startActivity(intent)
        context.finish()

    }

    userLayoutToolbar.setOnClickListener {
        val intent = Intent(context, UserActivity::class.java)
        context.startActivity(intent)
        context.finish()
    }
}
