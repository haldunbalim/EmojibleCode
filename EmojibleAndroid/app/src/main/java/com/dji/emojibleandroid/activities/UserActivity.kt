package com.dji.emojibleandroid.activities

import android.content.Intent
import android.os.Bundle
import android.text.Editable
import android.util.Log
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.showToast
import com.google.firebase.auth.EmailAuthProvider
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.activity_base.*
import kotlinx.android.synthetic.main.activity_no_user.emojiLayoutToolbar
import kotlinx.android.synthetic.main.activity_no_user.programLayoutToolbar
import kotlinx.android.synthetic.main.activity_no_user.tutorialLayoutToolbar
import kotlinx.android.synthetic.main.activity_no_user.userLayoutToolbar
import kotlinx.android.synthetic.main.activity_user.*
import kotlinx.android.synthetic.main.activity_user.signoutButton


class UserActivity : AppCompatActivity() {


    private lateinit var auth: FirebaseAuth
    private lateinit var db: FirebaseFirestore

    companion object {
        val TAG: String = UserActivity::class.java.simpleName
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_user)

        db = FirebaseFirestore.getInstance()
        auth = FirebaseAuth.getInstance()

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
            val intent = Intent(this, UserActivity::class.java)
            startActivity(intent)
            finish()

        }


        signoutButton.setOnClickListener {

            showToast("Sign Out")
            signOutUser()

        }

        passwordButton.setOnClickListener {

            showToast("Change Password")
            changePassword()

        }

        showFeatures()
    }

    private fun showFeatures() {

        val docRef = auth.currentUser?.email?.let { db.collection("Users").document(it) }
        docRef?.get()
            ?.addOnSuccessListener { document ->
                if (document != null) {
                    Log.d(TAG, "DocumentSnapshot data: ${document.data}")
                    nameEditText.text = document.data?.get("name").toString()
                    surnameEditText.text = document.data?.get("surname").toString()
                    userTypeEditText.text = document.data?.get("userType").toString()
                    emailEditText.text = document.data?.get("email").toString()
                    birthEditText.text = document.data?.get("birthDate").toString()
                    classIdEditText.text = document.data?.get("classId").toString()
                } else {
                    Log.d(TAG, "No such document")
                }
            }
            ?.addOnFailureListener { exception ->
                Log.d(TAG, "get failed with ", exception)
            }

        if(auth.currentUser == null){
            signOutUser()
        }
    }

    private fun changePassword(){

        if (currentPasswordET.text
                .isNotEmpty() && newPasswordET.text
                .isNotEmpty() && repeatPasswordET.text.isNotEmpty()){

            if (newPasswordET.text.toString().equals(repeatPasswordET.text.toString())) {

                val user = auth.currentUser

                if (user != null && user.email != null) {

                    val credential = EmailAuthProvider.getCredential(
                        user.email!!.toString(),
                        currentPasswordET.text.toString()
                    )

                    user?.reauthenticate(credential)?.addOnCompleteListener {

                        if (it.isSuccessful) {

                            showToast("Re-Authentication success")
                            user!!.updatePassword(newPasswordET.text.toString())
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

    private fun signOutUser() {

        auth.signOut()
        val intent = Intent(this,LoginActivity::class.java)
        startActivity(intent)
        finish()

    }
}
