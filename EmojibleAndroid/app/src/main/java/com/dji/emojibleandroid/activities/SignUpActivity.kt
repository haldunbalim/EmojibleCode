package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.util.Patterns
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.showToast
import com.google.firebase.auth.FirebaseAuth
import kotlinx.android.synthetic.main.activity_signup.*

class SignUpActivity : AppCompatActivity(){

    companion object{
        val TAG: String = com.dji.emojibleandroid.activities.SignUpActivity::class.java.simpleName
    }

    private lateinit var auth: FirebaseAuth

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_signup)
        auth = FirebaseAuth.getInstance()

        loginButton2.setOnClickListener(){

            showToast("Login")
            val intent = Intent(this, LoginActivity::class.java)
            startActivity(intent)

        }

        signupButton2.setOnClickListener(){

            signupUser()
            showToast("Sign Up")
            val intent = Intent(this, BaseActivity::class.java)
            startActivity(intent)

        }
    }

    private fun signupUser(){

        if(editTextMail2.text.toString().isEmpty()){

            editTextMail2.error = "Please enter an email"
            editTextMail2.requestFocus()
            return

        }

        if(!Patterns.EMAIL_ADDRESS.matcher(editTextMail2.text.toString()).matches()){

            editTextMail2.error = "Please enter a valid email"
            editTextMail2.requestFocus()
            return

        }

        if(editTextPassword2.text.toString().isEmpty()){

            editTextPassword2.error = "Please enter a password"
            editTextPassword2.requestFocus()
            return

        }

    }
}