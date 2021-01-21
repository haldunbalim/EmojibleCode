package com.dji.emojibleandroid.activities

import android.content.DialogInterface
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Patterns
import android.view.View
import android.view.ViewGroup
import android.widget.DatePicker
import android.widget.Switch
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AlertDialog
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.dataSources.UserDataSource
import com.dji.emojibleandroid.extensions.AppCompatActivityWithAlerts
import com.dji.emojibleandroid.extensions.hideProgressBar
import com.dji.emojibleandroid.extensions.showProgressBar
import com.dji.emojibleandroid.models.modelFactories.UserFactory
import com.dji.emojibleandroid.services.AuthenticationManager
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.dji.emojibleandroid.showToast
import com.google.firebase.auth.FirebaseUser
import kotlinx.android.synthetic.main.activity_no_user.*
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.*

class NoUserActivity : AppCompatActivityWithAlerts(), Observer {

    private lateinit var toggle: Switch
    private var birthDate: String? = null
    private var userType: String = "Student"
    private lateinit var popupLayout: ViewGroup

    companion object {
        val TAG: String = NoUserActivity::class.java.simpleName
        var firstTime = true
    }


    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_no_user)
        NotificationCenter.instance.addObserver(Changes.authStateChanged, this)
        AuthenticationManager.instance.startListeningForAuthChanges()
        toggle = findViewById(R.id.teacherSwitch)


        popupLayout = findViewById(R.id.popUpLayout)
        if (firstTime) {
            popupLayout.bringToFront()
            firstTime = false

            shutdownButtonPopup.setOnClickListener {

                popupLayout.visibility = View.GONE
                popupLayout.removeAllViewsInLayout()

            }

            programLayoutPopup.setOnClickListener {

                val intent = Intent(this, ProgramActivity::class.java)
                startActivity(intent)
                finish()
            }

            emojiLayoutPopup.setOnClickListener {

                val intent = Intent(this, EmojiActivity::class.java)
                startActivity(intent)
                finish()

            }

            tutorialLayoutPopup.setOnClickListener {

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
            val intent = Intent(this, LoginActivity::class.java)
            startActivity(intent)
        }


        toggle.setOnCheckedChangeListener { _, isChecked ->
            if (!isChecked) {
                userType = "Student"

            } else {
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
    }

    fun openProgramTab(view: View) {
        val intent = Intent(this, GridProgramActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openTutorialTab(view: View) {
        val intent = Intent(this, TutorialActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openEmojiTab(view: View) {
        val intent = Intent(this, EmojiActivity::class.java)
        startActivity(intent)
        finish()
    }

    fun openLoginTab(view: View) {
        return
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
                                birthDate!!
                            )
                        )
                    }
                }
                val intent = Intent(this, LoginActivity::class.java)
                startActivity(intent)
                finish()
            }
        }

    }

    private fun updateUI(currentUser: FirebaseUser?) {

        if (currentUser != null) {
            val intent = Intent(this, UserActivity::class.java)
            startActivity(intent)
            finish()
        }
    }

    override fun update(o: Observable?, arg: Any?) {
        updateUI(AuthenticationManager.instance.currentUser)
    }

}
