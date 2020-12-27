package com.dji.emojibleandroid.utils

import android.content.Intent
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.activities.*


fun setupToolbar(
    context: AppCompatActivity,
    programLayoutToolbar: View,
    tutorialLayoutToolbar: View,
    emojiLayoutToolbar: View,
    userLayoutToolbar: View
) {

    if (context !is ProgramActivity) {
        programLayoutToolbar.setOnClickListener {
            val intent = Intent(context, GridProgramActivity::class.java)
            context.startActivity(intent)
            context.finish()
        }
    }

    if (context !is TutorialActivity) {
        tutorialLayoutToolbar.setOnClickListener {
            val intent = Intent(context, TutorialActivity::class.java)
            context.startActivity(intent)
            context.finish()
        }
    }
    if (context !is EmojiActivity) {
        emojiLayoutToolbar.setOnClickListener {
            val intent = Intent(context, EmojiActivity::class.java)
            context.startActivity(intent)
            context.finish()

        }
    }
    if (context !is UserActivity) {
        userLayoutToolbar.setOnClickListener {
            val intent = Intent(context, UserActivity::class.java)
            context.startActivity(intent)
            context.finish()
        }
    }
}
