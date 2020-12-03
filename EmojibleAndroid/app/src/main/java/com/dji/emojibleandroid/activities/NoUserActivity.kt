package com.dji.emojibleandroid.activities

import android.content.DialogInterface
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.util.Patterns
import android.view.View
import android.view.ViewGroup
import android.widget.DatePicker
import android.widget.Switch
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.showToast
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.activity_no_user.*
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.*
import kotlin.collections.HashMap
import kotlin.collections.MutableMap
import kotlin.collections.set

class NoUserActivity : AppCompatActivity() {

    private lateinit var popupLayout: ViewGroup
    private lateinit var auth: FirebaseAuth
    private lateinit var db: FirebaseFirestore
    private lateinit var toggle: Switch
    private var userType: String = "Student"

    companion object {
        val TAG: String = NoUserActivity::class.java.simpleName
        var firstTime: Int = 0
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_no_user)
        popupLayout = findViewById(R.id.popUpLayout)
        toggle = findViewById(R.id.teacherSwitch)

        if (firstTime == 0) {
            popupLayout.bringToFront()
            firstTime++

            shutdownButtonPopup.setOnClickListener {

                popupLayout.visibility = View.GONE
                popupLayout.removeAllViewsInLayout()

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
        }else{
            popupLayout.visibility = View.GONE
            popupLayout.removeAllViewsInLayout()
            popupLayout.removeAllViews()
        }

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

        birthTextView.setOnClickListener {

            val builder = AlertDialog.Builder(this)
            builder.setTitle("Date of Birth")
            val view = layoutInflater.inflate(R.layout.dialog_datepicker,null)
            builder.setView(view)


            val datePicker = view.findViewById<DatePicker>(R.id.datePicker)
            val today = Calendar.getInstance()
            datePicker.init(today.get(Calendar.YEAR), today.get(Calendar.MONTH),
                today.get(Calendar.DAY_OF_MONTH)

            ) { view, year, month, day ->
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                    val formatter = DateTimeFormatter.ofPattern("dd MMMM yyyy")
                    birthTextView.text = LocalDate.of(year, month, day).format(formatter)

                }

            }

            builder.setNegativeButton("Close",DialogInterface.OnClickListener { _, _ ->  })
            builder.show()



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

        db.collection("Users").document(emailTextView.text.toString())
            .set(user)
            .addOnSuccessListener {
                Log.d(
                    TAG,
                    "DocumentSnapshot added with ID: "
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
