package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.util.Patterns
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.Constants
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.showToast
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import kotlinx.android.synthetic.main.activity_signup.*


class SignUpActivity : AppCompatActivity() {

    companion object {
        val TAG: String = com.dji.emojibleandroid.activities.SignUpActivity::class.java.simpleName
    }

    private lateinit var auth: FirebaseAuth
    private lateinit var db: FirebaseFirestore
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_signup)
        auth = FirebaseAuth.getInstance()
        db = FirebaseFirestore.getInstance()
        loginButton2.setOnClickListener() {

            showToast("Login")
            val intent = Intent(this, LoginActivity::class.java)
            startActivity(intent)

        }

        signupButton2.setOnClickListener() {

            signupUser()


        }
    }

    private fun signupUser() {

        if (editTextMail2.text.toString().isEmpty()) {

            editTextMail2.error = "Please enter an email"
            editTextMail2.requestFocus()
            return

        }

        if (!Patterns.EMAIL_ADDRESS.matcher(editTextMail2.text.toString()).matches()) {

            editTextMail2.error = "Please enter a valid email"
            editTextMail2.requestFocus()
            return

        }

        if (editTextPassword2.text.toString().isEmpty()) {

            editTextPassword2.error = "Please enter a password"
            editTextPassword2.requestFocus()
            return

        }
        if (!editTextPassword2.text.toString().equals(editTextPassword3.text.toString())) {

            editTextPassword2.error = "Please enter the same password"
            editTextPassword3.error = "Please enter the same pawssword"
            editTextPassword2.requestFocus()
            editTextPassword3.requestFocus()
            return

        }

        val bundle: Bundle? = intent.extras
        bundle?.let {

            val userType = bundle.getString(Constants.USER_MSG_KEY)
            userType?.let { it1 -> showToast(it1) }

            val dateOfBirth: String = editTextBirth.text.toString()
            val name: String = editTextName.text.toString()
            val surname: String = editTextSurname.text.toString()

            val user: MutableMap<String,Any> = HashMap()

               user["birthDate"] = dateOfBirth
               user["classId"] = "0"
               user["name"] = name
               user["surname"] = surname
               user["userType"] = userType.toString()
               user["email"] = editTextMail2.text.toString()

// Add a new document with a generated ID

// Add a new document with a generated ID
            db.collection("Users")
                .add(user)
                .addOnSuccessListener { documentReference ->
                    Log.d(
                        TAG,
                        "DocumentSnapshot added with ID: " + documentReference.id
                    )
                    showToast("Success Firestore")
                }
                .addOnFailureListener { e ->
                    Log.w(
                        TAG,
                        "Error adding document",
                        e
                    )
                    showToast("Failed Firestore")
                }

            auth.createUserWithEmailAndPassword(
                editTextMail2.text.toString(),
                editTextPassword2.text.toString()
            )
                .addOnCompleteListener(this) { task ->
                    if (task.isSuccessful) {
                        // Sign in success, update UI with the signed-in user's information
                        val user = auth.currentUser
                        user?.sendEmailVerification()?.addOnCompleteListener(this) {
                            if (task.isSuccessful) {

                                Log.d(TAG, "createUserWithEmail:success")
                                val intent = Intent(this, LoginActivity::class.java)
                                startActivity(intent)
                                finish()

                            } else {

                                showToast(task.exception!!.message.toString())

                            }
                        }

                    } else {
                        // If sign in fails, display a message to the user.
                        showToast(task.exception!!.message.toString())
                        Log.w(TAG, "createUserWithEmail:failure", task.exception)
                        Toast.makeText(
                            baseContext, "Authentication failed.",
                            Toast.LENGTH_SHORT
                        ).show()
                        //updateUI(null)
                    }
                }
        }
    }
}