package com.dji.emojibleandroid.extensions

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.utils.ProgressBarUtils
import com.mikhaellopez.circularprogressbar.CircularProgressBar

open class AppCompatActivityWithAlerts: AppCompatActivity() {
    var alertDialog: AlertDialog? = null
    lateinit var progressBarView: View
}

fun AppCompatActivityWithAlerts.showProgressBar(completion: (() -> Unit)? = null) {
        if (alertDialog != null) {
            if (completion != null) {
                completion()
            }
            return
        }

        val builder = AlertDialog.Builder(this)
        builder.setTitle("Please Wait")
        progressBarView = LayoutInflater.from(this).inflate(R.layout.progress_bar,null)
        builder.setView(progressBarView)
        progressBarView.visibility = View.VISIBLE

        val progressBar = progressBarView.findViewById<CircularProgressBar>(R.id.progressBar)
        progressBar.visibility = View.VISIBLE
        progressBar.indeterminateMode = true
        progressBar.bringToFront()
        window.setFlags(
            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
        )
        alertDialog = builder.create()
        alertDialog!!.show()

}

fun AppCompatActivityWithAlerts.hideProgressBar(completion: (() -> Unit)? = null) {
    findViewById<CircularProgressBar>(R.id.progressBar)?.indeterminateMode = false
    progressBarView.visibility = View.GONE
    window.clearFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE)
    alertDialog!!.dismiss()
}