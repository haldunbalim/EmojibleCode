package com.dji.emojibleandroid.activities

import android.content.DialogInterface
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.util.Patterns
import android.widget.EditText
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.Constants
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

            doLogin()

        }

        registerTeacherButton.setOnClickListener(){

            showToast("Sign Up")
            Log.i(TAG,"Button was clicked")
            val intent = Intent(this, SignUpActivity::class.java)
            intent.putExtra(Constants.USER_MSG_KEY,"teacher")
            startActivity(intent)

        }

        registerStudentButton.setOnClickListener(){

            showToast("Sign Up")
            Log.i(TAG,"Button was clicked")
            val intent = Intent(this, SignUpActivity::class.java)
            intent.putExtra(Constants.USER_MSG_KEY, "student")
            startActivity(intent)

        }

        resetButton.setOnClickListener{

            val builder = AlertDialog.Builder(this)
            builder.setTitle("Forgot Password")
            val view = layoutInflater.inflate(R.layout.dialog_reset,null)
            val username = view.findViewById<EditText>(R.id.editTextReset)
            builder.setView(view)
            builder.setPositiveButton("Reset",DialogInterface.OnClickListener{_, _ ->
                forgotPassword(username)
            })
            builder.setNegativeButton("Close",DialogInterface.OnClickListener { _, _ ->  })
            builder.show()
            

        }

    }

    private fun forgotPassword(username: EditText) {

        if(username.text.toString().isEmpty()){
            return
        }
        if(!Patterns.EMAIL_ADDRESS.matcher(username.text.toString()).matches()){
            return
        }

        auth.sendPasswordResetEmail(username.text.toString()).addOnCompleteListener {
            if(it.isSuccessful){

                showToast("Email Send")

            }else{

                showToast(it.exception!!.message.toString())

            }
        }

    }

    private fun doLogin() {
        if(editTextMail.text.toString().isEmpty()){

            editTextMail.error = "Please enter an email"
            editTextMail.requestFocus()
            return

        }

        if(!Patterns.EMAIL_ADDRESS.matcher(editTextMail.text.toString()).matches()){

            editTextMail.error = "Please enter a valid email"
            editTextMail.requestFocus()
            return

        }

        if(editTextPassword.text.toString().isEmpty()){

            editTextPassword.error = "Please enter a password"
            editTextPassword.requestFocus()
            return

        }

        auth.signInWithEmailAndPassword(editTextMail.text.toString(), editTextPassword.text.toString())
            .addOnCompleteListener(this) { task ->
                if (task.isSuccessful) {
                    // Sign in success, update UI with the signed-in user's information
                    Log.d(TAG, "signInWithEmail:success")
                    val user = auth.currentUser
                    updateUI(user)
                } else {
                    // If sign in fails, display a message to the user.
                    Log.w(TAG, "signInWithEmail:failure", task.exception)
                    showToast("Authentication failed")
                    showToast(task.exception!!.message.toString())
                    val user =
                        updateUI(null)
                    // [START_EXCLUDE]
                    //checkForMultiFactorFailure(task.exception!!)

                    // [END_EXCLUDE]
                }


            }
    }

    public override fun onStart() {

        super.onStart()
        val currentUser = auth.currentUser
        updateUI(currentUser)

    }

    private fun updateUI(currentUser: FirebaseUser?) {

        if(currentUser != null){
            if(currentUser.isEmailVerified){

                val intent = Intent(this, BaseActivity::class.java)
                startActivity(intent)
                finish()

            }else{

                showToast("Please verify your email address")

            }
        }else{

            showToast("Login Failed")

        }
    }


}