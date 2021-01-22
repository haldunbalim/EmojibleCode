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
import java.lang.Exception

class UserDataSource private constructor(){
    private val database = Firebase.firestore
    var snapShotListener: ListenerRegistration? = null
    private val notificationCenter = NotificationCenter.instance

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
            if (documentSnapshot == null) {
                return@addSnapshotListener
            }
            val dict = documentSnapshot.data ?: return@addSnapshotListener

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

    fun editUserData(newData: HashMap<String, Any?>) {
        val currentUser = AuthenticationManager.instance.currentUser ?: return
        val uid = currentUser.uid
        database.collection("Users").document(uid).update(newData)
    }

    fun resetUserClassId() {
        val currentUser = AuthenticationManager.instance.currentUser ?: return
        val uid = currentUser.uid
        database.collection("Users").document(uid).update(mapOf<String, String>("classId" to ""))
    }

    fun resetUserClassIdForAllUsers(classId: String) {
        database.collection("Users").whereEqualTo("classId", classId).get().addOnCompleteListener {
            if (it.isSuccessful) {
                for (document in it.result?.documents!!) {
                    database.collection("Users").document(document.id).update(mapOf<String, String>("classId" to ""))
                }
            } else if (it.isCanceled) {
                throw Exception("Error getting documents ${it.exception?.message}")
            }
        }
    }

    private object HOLDER {
        val INSTANCE = UserDataSource()
    }

    companion object {
        val instance: UserDataSource by lazy { HOLDER.INSTANCE }
    }
}