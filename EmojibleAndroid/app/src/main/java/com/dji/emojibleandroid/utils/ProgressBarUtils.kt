package com.dji.emojibleandroid.utils

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.Window
import android.view.WindowManager
import androidx.appcompat.app.AlertDialog
import com.dji.emojibleandroid.R
import com.mikhaellopez.circularprogressbar.CircularProgressBar

object ProgressBarUtils {
    lateinit var dialog: AlertDialog
    fun showProgressBar(context: Context, window: Window): View? {
        val builder = AlertDialog.Builder(context)
        builder.setTitle("Please Wait")
        val view = LayoutInflater.from(context).inflate(R.layout.progress_bar,null)
        builder.setView(view)
        view.visibility = View.VISIBLE

        val progressBar = view.findViewById<CircularProgressBar>(R.id.progressBar)
        progressBar.visibility = View.VISIBLE
        progressBar.indeterminateMode = true
        progressBar.bringToFront()
        window.setFlags(
            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
        )
        dialog = builder.create()
        dialog.show()
        return view
    }

    fun hideProgressBar(view: View?, window: Window) {
        view?.findViewById<CircularProgressBar>(R.id.progressBar)?.indeterminateMode = false
        view?.visibility = View.GONE
        window.clearFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE)
    }
}