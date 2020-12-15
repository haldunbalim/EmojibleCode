package com.dji.emojibleandroid.dataSources

import android.os.Build
import androidx.annotation.RequiresApi
import com.dji.emojibleandroid.models.UserModel
import com.dji.emojibleandroid.models.modelFactories.UserFactory
import com.dji.emojibleandroid.services.AuthenticationManager
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.google.firebase.firestore.ListenerRegistration
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class UserDataSource {
    val database = Firebase.firestore
    var snapShotListener: ListenerRegistration? = null
    val notificationCenter = NotificationCenter.instance

    @RequiresApi(Build.VERSION_CODES.O)
    fun getCurrentUserInfo(completion: (UserModel?) -> Unit) {
        val currentUser = AuthenticationManager.instance.currentUser
        currentUser?.let {
            val userDocRef = database.collection("Users").document(it.uid)
            userDocRef.get().addOnCompleteListener { document ->
                if (document.isSuccessful) {
                    if (document.result!!.exists()) {
                        val dict = document.result!!.data
                        val userInfo = UserFactory.instance.create((dict as HashMap<String, Any>))
                        completion(userInfo)
                    }
                    completion(null)
                } else {
                    completion(null)
                }
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun startObservingUserModel() {
        val currentUser = AuthenticationManager.instance.currentUser
        val userDocRef = currentUser?.let { database.collection("Users").document(it.uid) }
        snapShotListener = userDocRef?.addSnapshotListener { documentSnapshot, error ->
            val dict = documentSnapshot?.data
            notificationCenter.post(
                Changes.userModelChagend,
                null,
                "userModel" to UserFactory.instance.create(dict as HashMap<String, Any>)
            )
        }
    }

    fun stopObservingUserModel() {
        snapShotListener?.remove()
    }

    fun writeData(user: UserModel) {
        val currentUser = AuthenticationManager.instance.currentUser
        currentUser?.uid?.let { database.collection("Users").document(it).set(user.dictionary) }
    }

    private object HOLDER {
        val INSTANCE = UserDataSource()
    }

    companion object {
        val instance: UserDataSource by lazy { HOLDER.INSTANCE }
    }
}