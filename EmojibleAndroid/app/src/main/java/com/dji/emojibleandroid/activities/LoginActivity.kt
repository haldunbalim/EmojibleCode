package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.showToast
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import kotlinx.android.synthetic.main.activity_login.*

class LoginActivity : AppCompatActivity(){

    companion object{
        val TAG: String = LoginActivity::class.java.simpleName
    }

    private lateinit var auth: FirebaseAuth

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)
        auth = FirebaseAuth.getInstance()

        loginButton.setOnClickListener(){

            showToast("Login")
            Log.i(TAG,"Button was clicked")
            val intent = Intent(this, BaseActivity::class.java)
            startActivity(intent)
            finish()

        }

        signupButton.setOnClickListener(){

            showToast("Sign Up")
            Log.i(TAG,"Button was clicked")
            val intent = Intent(this, SignUpActivity::class.java)
            startActivity(intent)
            finish()

        }

    }

    public override fun onStart() {
        super.onStart()
        val currentUser = auth.currentUser
        updateUI(currentUser)
    }


    public fun updateUI(currentUser: FirebaseUser?){


    }

}