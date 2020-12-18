package com.dji.emojibleandroid.activities

import android.content.DialogInterface
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.util.Patterns
import android.widget.EditText
import androidx.appcompat.app.AlertDialog
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.extensions.AppCompatActivityWithAlerts
import com.dji.emojibleandroid.extensions.hideProgressBar
import com.dji.emojibleandroid.extensions.showProgressBar
import com.dji.emojibleandroid.services.AuthenticationManager
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.dji.emojibleandroid.showToast
import com.dji.emojibleandroid.utils.ProgressBarUtils
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import kotlinx.android.synthetic.main.activity_login.*
import kotlinx.android.synthetic.main.activity_login.emojiLayoutToolbar
import kotlinx.android.synthetic.main.activity_login.loginButton
import kotlinx.android.synthetic.main.activity_login.programLayoutToolbar
import kotlinx.android.synthetic.main.activity_login.tutorialLayoutToolbar
import kotlinx.android.synthetic.main.activity_login.userLayoutToolbar
import java.util.*

class LoginActivity : AppCompatActivityWithAlerts(), Observer {

    companion object {
        val TAG: String = LoginActivity::class.java.simpleName
    }

    private lateinit var auth: FirebaseAuth

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)
        NotificationCenter.instance.addObserver(Changes.authStateChanged, this)
        AuthenticationManager.instance.startListeningForAuthChanges()
        loginButton.setOnClickListener() {

            doLogin()

        }

        programLayoutToolbar.setOnClickListener {

            showToast("Program")
            val intent = Intent(this, ProgramActivity::class.java)
            startActivity(intent)
            finish()

        }

        tutorialLayoutToolbar.setOnClickListener {

            showToast("Tutorial")
            val intent = Intent(this, TutorialActivity::class.java)
            startActivity(intent)
            finish()

        }

        emojiLayoutToolbar.setOnClickListener {

            showToast("Emoji")
            val intent = Intent(this, EmojiActivity::class.java)
            startActivity(intent)
            finish()

        }

        userLayoutToolbar.setOnClickListener {

            showToast("User")
            val intent = Intent(this, NoUserActivity::class.java)
            startActivity(intent)
            finish()

        }

        registerButton.setOnClickListener() {

            showToast("Sign Up")
            Log.i(TAG, "Button was clicked")
            val intent = Intent(this, NoUserActivity::class.java)
            startActivity(intent)

        }

        resetButton.setOnClickListener {

            val builder = AlertDialog.Builder(this)
            builder.setTitle("Forgot Password")
            val view = layoutInflater.inflate(R.layout.dialog_reset, null)
            val username = view.findViewById<EditText>(R.id.editTextReset)
            builder.setView(view)
            builder.setPositiveButton("Reset", DialogInterface.OnClickListener { _, _ ->
                forgotPassword(username)
            })
            builder.setNegativeButton("Close", DialogInterface.OnClickListener { _, _ -> })
            builder.show()


        }

    }

    private fun forgotPassword(username: EditText) {

        if (username.text.toString().isEmpty()) {
            return
        }
        if (!Patterns.EMAIL_ADDRESS.matcher(username.text.toString()).matches()) {
            return
        }

        auth.sendPasswordResetEmail(username.text.toString()).addOnCompleteListener {
            if (it.isSuccessful) {

                showToast("Email Send")

            } else {

                showToast(it.exception!!.message.toString())

            }
        }


    }

    private fun doLogin() {
        if (emailTextView2.text.toString().isEmpty()) {

            emailTextView2.error = "Please enter an email"
            emailTextView2.requestFocus()
            return

        }

        if (!Patterns.EMAIL_ADDRESS.matcher(emailTextView2.text.toString()).matches()) {

            emailTextView2.error = "Please enter a valid email"
            emailTextView2.requestFocus()
            return

        }

        if (passwordTextView2.text.toString().isEmpty()) {

            passwordTextView2.error = "Please enter a password"
            passwordTextView2.requestFocus()
            return

        }


        showProgressBar()
        AuthenticationManager.instance.signInWithEmailAndPassword(
            emailTextView2.text.toString(),
            passwordTextView2.text.toString()
        ) { error ->
            hideProgressBar()
            if (error != null) {
                showToast("Authentication failed")
                showToast(error)
            }
        }
    }

    public override fun onStart() {

        super.onStart()
    }

    private fun updateUI(currentUser: FirebaseUser?) {

        if (currentUser != null) {
            val intent = Intent(this, UserActivity::class.java)
            startActivity(intent)
            finish()
        } else {

            showToast("Login Failed")

        }
    }

    override fun update(o: Observable?, arg: Any?) {
        updateUI(AuthenticationManager.instance.currentUser)
    }


}