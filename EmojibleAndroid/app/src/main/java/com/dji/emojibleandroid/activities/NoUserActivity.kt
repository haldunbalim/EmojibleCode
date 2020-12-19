package com.dji.emojibleandroid.activities

import android.content.DialogInterface
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.util.Patterns
import android.view.View
import android.view.ViewGroup
import android.widget.DatePicker
import android.widget.EditText
import android.widget.Switch
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.dataSources.UserDataSource
import com.dji.emojibleandroid.extensions.AppCompatActivityWithAlerts
import com.dji.emojibleandroid.extensions.hideProgressBar
import com.dji.emojibleandroid.extensions.showProgressBar
import com.dji.emojibleandroid.models.modelFactories.UserFactory
import com.dji.emojibleandroid.services.AuthenticationManager
import com.dji.emojibleandroid.showToast
import com.google.firebase.FirebaseApp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.activity_no_user.*
import kotlinx.android.synthetic.main.activity_no_user.emojiLayoutToolbar
import kotlinx.android.synthetic.main.activity_no_user.programLayoutToolbar
import kotlinx.android.synthetic.main.activity_no_user.tutorialLayoutToolbar
import kotlinx.android.synthetic.main.activity_no_user.userLayoutToolbar
import kotlinx.android.synthetic.main.activity_user.*
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.*
import kotlin.collections.HashMap
import kotlin.collections.MutableMap
import kotlin.collections.set

class NoUserActivity : AppCompatActivityWithAlerts() {

    private lateinit var popupLayout: ViewGroup
    private lateinit var toggle: Switch
    private var birthDate: String? = null
    private var userType: String = "Student"
    private lateinit var classID : EditText

    companion object {
        val TAG: String = NoUserActivity::class.java.simpleName
        var firstTime: Int = 0
    }


    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_no_user)
        popupLayout = findViewById(R.id.popUpLayout)
        toggle = findViewById(R.id.teacherSwitch)
        classID = findViewById(R.id.classIDEditText)
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
        } else {
            popupLayout.visibility = View.GONE
            popupLayout.removeAllViewsInLayout()
            popupLayout.removeAllViews()
        }

        loginButton.setOnClickListener {
            showToast("Login")
            val intent = Intent(this, LoginActivity::class.java)
            startActivity(intent)
        }


        toggle.setOnCheckedChangeListener { _, isChecked ->
            if (!isChecked) {
                classID.hint = "Enter your Class ID"
                userType = "Student"

            } else {
                classID.hint = "Enter your Teacher Code"
                userType = "Teacher"
            }
        }

        signupButton.setOnClickListener {
            signupUser()
        }

        birthTextView.setOnClickListener {
            val builder = AlertDialog.Builder(this)
            builder.setTitle("Date of Birth")
            val view = layoutInflater.inflate(R.layout.dialog_datepicker, null)
            builder.setView(view)

            val datePicker = view.findViewById<DatePicker>(R.id.datePicker)
            val today = Calendar.getInstance()
            datePicker.init(
                today.get(Calendar.YEAR), today.get(Calendar.MONTH),
                today.get(Calendar.DAY_OF_MONTH)

            ) { view, year, month, day ->
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                    val formatter = DateTimeFormatter.ofPattern("dd MMM yyyy")
                    birthDate = LocalDate.of(year, month + 1, day).format(formatter)
                    birthTextView.text = LocalDate.of(year, month + 1, day).format(formatter)
                }
            }
            builder.setNegativeButton("Close", DialogInterface.OnClickListener { _, _ -> })
            builder.show()
        }

        setupToolbar()
    }

    private fun setupToolbar() {

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
        
    }

    override fun onBackPressed() {

        popupLayout.visibility = View.GONE
        popupLayout.removeAllViewsInLayout()
        popupLayout.removeAllViews()

    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun signupUser() {


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

        if (birthDate == null) {
            birthTextView.error = "Please enter a birth date"
            birthTextView.requestFocus()
            return
        }



        val name: String = nameTextView.text.toString()
        val surname: String = surnameTextView.text.toString()
        val password: String = passwordTextView.text.toString()
        val email = emailTextView.text.toString()
        val classId = "123123"
        showProgressBar()
        AuthenticationManager.instance.createUserWithEmailAndPassword(email, password) { error ->
            if (error != null) {
                hideProgressBar()
                showToast(error)
            } else {
                AuthenticationManager.instance.signInWithEmailAndPassword(email, password) { error ->
                    hideProgressBar()
                    if (error != null) {
                        showToast("Authentication failed")
                        showToast(error)
                    } else {
                        UserDataSource.instance.writeData(
                            UserFactory.instance.create(
                                userType,
                                email,
                                name,
                                surname,
                                birthDate!!,
                                classId = classId
                            )
                        )
                    }
                }
                val intent = Intent(this, LoginActivity::class.java)
                startActivity(intent)
                finish()
            }
        }

//
//        user["birthDate"] = birthDate!!
//        user["classId"] = "0"
//        user["name"] = name
//        user["surname"] = surname
//        user["userType"] = userType
//        user["email"] = emailTextView.text.toString()
//
//        db.collection("Users").document(emailTextView.text.toString())
//            .set(user)
//            .addOnSuccessListener {
//                Log.d(
//                    TAG,
//                    "DocumentSnapshot added with ID: "
//                )
//                showToast("Success Firestore")
//            }
//            .addOnFailureListener { e ->
//                Log.w(
//                    TAG,
//                    "Error adding document",
//                    e
//                )
//                showToast("Failed Firestore")
//            }
//
//        auth.createUserWithEmailAndPassword(
//            emailTextView.text.toString(),
//            passwordTextView.text.toString()
//        )
//            .addOnCompleteListener(this) { task ->
//                if (task.isSuccessful) {
//                    // Sign in success, update UI with the signed-in user's information
//                    val user = auth.currentUser
//                    user?.sendEmailVerification()?.addOnCompleteListener(this) {
//                        if (task.isSuccessful) {
//
//                            Log.d(TAG, "createUserWithEmail:success")
//                            val intent = Intent(this, LoginActivity::class.java)
//                            startActivity(intent)
//                            finish()
//
//                        } else {
//
//                            showToast(task.exception!!.message.toString())
//
//                        }
//                    }
//
//                } else {
//                    // If sign in fails, display a message to the user.
//                    showToast(task.exception!!.message.toString())
//                    Log.w(TAG, "createUserWithEmail:failure", task.exception)
//                    Toast.makeText(
//                        baseContext, "Authentication failed.",
//                        Toast.LENGTH_SHORT
//                    ).show()
//                    //updateUI(null)
//                }
//            }


    }

}
