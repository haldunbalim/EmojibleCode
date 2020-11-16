package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.showToast
import com.google.firebase.auth.AuthCredential
import com.google.firebase.auth.EmailAuthProvider
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import kotlinx.android.synthetic.main.activity_base.*

class BaseActivity : AppCompatActivity() {

    companion object {

        val TAG: String = BaseActivity::class.java.simpleName

    }

    private lateinit var auth: FirebaseAuth

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_base)

        auth = FirebaseAuth.getInstance()

        emojiButton.setOnClickListener {

            showToast("Emojies")
            Log.i(TAG, "Button was clicked")
            val intent = Intent(this, EmojiesActivity::class.java)
            startActivity(intent)


        }

        newCodeButton.setOnClickListener {

            showToast("Create your code")
            Log.i(TAG, "Button was clicked")
            val intent = Intent(this, CodeActivity::class.java)
            startActivity(intent)

        }
        tutorialButton.setOnClickListener {

            showToast("Tutorials", Toast.LENGTH_LONG)
            Log.i(TAG, "Button was clicked")
            val intent = Intent(this, TutorialsActivity::class.java)
            startActivity(intent)

        }

        changePassButton.setOnClickListener() {

            changePassword()

        }

        signoutButton.setOnClickListener(){

            auth.signOut()
            val intent = Intent(this,LoginActivity::class.java)
            startActivity(intent)
            finish()

        }


    }

    private fun changePassword(){

        if (editTextCurrentPassword.text
                .isNotEmpty() && editTextNewPassword.text
                .isNotEmpty() && editTextNewPassword2.text.isNotEmpty()){

            if (editTextNewPassword.text.toString().equals(editTextNewPassword2.text.toString())) {

                val user = auth.currentUser

                if (user != null && user.email != null) {

                    val credential = EmailAuthProvider.getCredential(
                        user.email!!.toString(),
                        editTextCurrentPassword.text.toString()
                    )

                    user?.reauthenticate(credential)?.addOnCompleteListener {

                        if (it.isSuccessful) {

                            showToast("Re-Authentication success")
                            user!!.updatePassword(editTextNewPassword.text.toString())
                                .addOnCompleteListener{ task ->

                                    if (task.isSuccessful) {

                                        showToast("Password changed successfully")
                                        auth.signOut()
                                        val intent = Intent(this, LoginActivity::class.java)
                                        startActivity(intent)
                                        finish()

                                    }else{

                                        showToast("Password wasn't changed")
                                        showToast(task.exception!!.message.toString())

                                    }
                                }
                        } else {

                            showToast("Re-Authentication failed")
                            showToast(it.exception!!.message.toString())

                        }
                    }
                } else {

                    val intent = Intent(this, LoginActivity::class.java)
                    startActivity(intent)
                    finish()

                }
            } else {

                showToast("Passwords are mismatching")
            }

        } else {

            showToast("Please enter all the fields")

        }
    }

}