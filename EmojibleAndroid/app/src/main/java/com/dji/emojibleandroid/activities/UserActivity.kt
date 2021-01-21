package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.text.Editable
import android.util.Log
import android.widget.Button
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.dataSources.UserDataSource
import com.dji.emojibleandroid.models.UserModel
import com.dji.emojibleandroid.services.AuthenticationManager
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.dji.emojibleandroid.showToast
import com.dji.emojibleandroid.utils.setupToolbar
import com.google.firebase.auth.EmailAuthProvider
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.activity_no_user.emojiLayoutToolbar
import kotlinx.android.synthetic.main.activity_no_user.programLayoutToolbar
import kotlinx.android.synthetic.main.activity_no_user.tutorialLayoutToolbar
import kotlinx.android.synthetic.main.activity_user.*
import kotlinx.android.synthetic.main.activity_user.signoutButton
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.*
import kotlin.collections.HashMap


class UserActivity : AppCompatActivity(), Observer {


    private lateinit var auth: FirebaseAuth

    companion object {
        val TAG: String = UserActivity::class.java.simpleName
    }


    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_user)
        NotificationCenter.instance.addObserver(Changes.userModelChagend, this)
        UserDataSource.instance.startObservingUserModel()

        setupToolbar(
            this,
            programLayoutToolbar,
            tutorialLayoutToolbar,
            emojiLayoutToolbar,
            userLayoutToolbar
        )

        signoutButton.setOnClickListener {

            showToast("Sign Out")
            signOutUser()

        }

        passwordButton.setOnClickListener {

            showToast("Change Password")
            changePassword()

        }

        signoutButton.setOnClickListener {
            signOutUser()
        }

        passwordButton.setOnClickListener {
            changePassword()
        }
    }

    private fun changePassword() {
        if (currentPasswordET.text
                .isNotEmpty() && newPasswordET.text
                .isNotEmpty() && repeatPasswordET.text.isNotEmpty()
        ) {
            if (newPasswordET.text.toString().equals(repeatPasswordET.text.toString())) {
                val user = AuthenticationManager.instance.currentUser
                if (user != null && user.email != null) {
                    val credential = EmailAuthProvider.getCredential(
                        user.email!!.toString(),
                        currentPasswordET.text.toString()
                    )
                    user.reauthenticate(credential).addOnCompleteListener {
                        if (it.isSuccessful) {
                            showToast("Re-Authentication success")
                            user.updatePassword(newPasswordET.text.toString())
                                .addOnCompleteListener { task ->
                                    if (task.isSuccessful) {
                                        showToast("Password changed successfully")
                                    } else {
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

    private fun signOutUser() {
        AuthenticationManager.instance.signOut()
        UserDataSource.instance.stopObservingUserModel()
        val intent = Intent(this, LoginActivity::class.java)
        startActivity(intent)
        finish()

    }

    override fun update(o: Observable?, arg: Any?) {
        val userModelDict = (arg as Pair<String, UserModel>).second.dictionary
        nameEditText.text = userModelDict["name"] as String
        surnameEditText.text = userModelDict["surname"] as String
        userTypeEditText.text = userModelDict["userType"] as String
        emailEditText.text = userModelDict["email"] as String
        birthEditText.text = userModelDict["birthDate"] as String
        classIdEditText.text = userModelDict["classId"] as String
    }
}
