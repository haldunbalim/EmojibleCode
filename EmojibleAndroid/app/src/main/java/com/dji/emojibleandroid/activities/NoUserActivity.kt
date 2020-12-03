package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.util.Patterns
import android.view.View
import android.view.ViewGroup
import android.widget.Switch
import android.widget.Toast
import android.widget.ToggleButton
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.Constants
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.showToast
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.activity_no_user.*
import kotlinx.android.synthetic.main.activity_signup.*

class NoUserActivity : AppCompatActivity() {

    private lateinit var popupLayout: ViewGroup
    private lateinit var auth: FirebaseAuth
    private lateinit var db: FirebaseFirestore
    private lateinit var toggle: Switch
    private var userType: String = "Student"

    companion object {
        val TAG: String = NoUserActivity::class.java.simpleName
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_no_user)


        popupLayout = findViewById(R.id.popUpLayout)
        toggle = findViewById(R.id.teacherSwitch)
        popupLayout.bringToFront()
        auth = FirebaseAuth.getInstance()
        db = FirebaseFirestore.getInstance()

        loginButton.setOnClickListener {

            showToast("Login")
            val intent = Intent(this, LoginActivity::class.java)
            startActivity(intent)

        }

        signupButton.setOnClickListener {

            signupUser(toggle)

        }

        shutdownButtonPopup.setOnClickListener {

            popupLayout.visibility = View.GONE
            popupLayout.removeAllViewsInLayout()

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

        programLayoutPopup.setOnClickListener {

            showToast("Program")
            val intent = Intent(this, ProgramActivity::class.java)
            startActivity(intent)
            finish()
        }

        emojiLayoutPopup.setOnClickListener {

            showToast("Emoji")
            val intent = Intent(this, EmojiActivity::class.java)
            startActivity(intent)
            finish()

        }

        tutorialLayoutPopup.setOnClickListener {

            showToast("Tutorial")
            val intent = Intent(this, TutorialActivity::class.java)
            startActivity(intent)
            finish()

        }
    }

    override fun onBackPressed() {

        popupLayout.visibility = View.GONE
        popupLayout.removeAllViewsInLayout()
        popupLayout.removeAllViews()

    }

    private fun signupUser(toggle: Switch) {

        if (emailTextView.text.toString().isEmpty()) {

            emailTextView.error = "Please enter an email"
            emailTextView.requestFocus()
            return

        }

        if (!Patterns.EMAIL_ADDRESS.matcher(emailTextView.text.toString()).matches()) {

            emailTextView.error = "Please enter a valid email"
            emailTextView.requestFocus()
            return

        }

        if (passwordTextView.text.toString().isEmpty()) {

            passwordTextView.error = "Please enter a password"
            passwordTextView.requestFocus()
            return

        }
        if (!passwordTextView.text.toString().equals(repeatPassTextView.text.toString())) {

            passwordTextView.error = "Please enter the same password"
            repeatPassTextView.error = "Please enter the same pawssword"
            passwordTextView.requestFocus()
            repeatPassTextView.requestFocus()
            return

        }

        toggle.setOnCheckedChangeListener { _, isChecked ->

            if (!isChecked) {

                userType = "Student"

            } else {

                userType = "Teacher"

            }

        }

        val dateOfBirth: String = birthTextView.text.toString()
        val name: String = nameTextView.text.toString()
        val surname: String = surnameTextView.text.toString()
        val user: MutableMap<String, Any> = HashMap()

        user["birthDate"] = dateOfBirth
        user["classId"] = "0"
        user["name"] = name
        user["surname"] = surname
        user["userType"] = userType
        user["email"] = emailTextView.text.toString()

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
            emailTextView.text.toString(),
            passwordTextView.text.toString()
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