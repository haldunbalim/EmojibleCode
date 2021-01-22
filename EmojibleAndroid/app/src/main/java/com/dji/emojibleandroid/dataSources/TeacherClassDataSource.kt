package com.dji.emojibleandroid.dataSources

import android.os.Build
import androidx.annotation.RequiresApi
import com.dji.emojibleandroid.models.ClassModel
import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.models.StudentModel
import com.dji.emojibleandroid.services.AuthenticationManager
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.google.firebase.firestore.ListenerRegistration
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import java.lang.Exception

class TeacherClassDataSource private constructor(){
    val database = Firebase.firestore
    var snapshotListener: ListenerRegistration? = null
    val notificationCenter = NotificationCenter.instance
    var classroom = listOf<ClassModel>()
    var classRoomDataSourceIndices = listOf<String>()
    var snapshotListenerForClassTutorials: ListenerRegistration? = null
    var classTutorials = listOf<CodeModel>()

    fun startObservingClass() {
        val currentUser = AuthenticationManager.instance.currentUser ?: return
        val classesCollectionRef =
            database.collection("Classes").whereEqualTo("teacherId", currentUser.uid)
        snapshotListener = classesCollectionRef.addSnapshotListener { querySnapshot, error ->
            val documents = querySnapshot?.documents ?: return@addSnapshotListener
            classroom = documents.map { ClassModel(it.data as HashMap<String, Any>) }
            classRoomDataSourceIndices = documents.map { it.id }
            notificationCenter.post(
                Changes.teacherClassChanged,
                null,
                hashMapOf("teacherClassChanged" to classroom)
            )
        }
    }

    fun stopObservingClass() {
        val snapshotListener = snapshotListener ?: return
        snapshotListener.remove()
    }

    fun removeClass(classroom: ClassModel) {
        val cModel = this.classroom.find { it.equals(classroom) }
        val index = this.classroom.indexOf(cModel)
        UserDataSource.instance.resetUserClassIdForAllUsers(classroom.id)
        if (index != -1)
            database.collection("Classes").document(classRoomDataSourceIndices[index]).delete()
    }

    fun writeClass(className: String, classPassword: String) {
        val currentUser = AuthenticationManager.instance.currentUser ?: return
        val uid = currentUser.uid
        val doc = database.collection("Classes").document()
        val newClassModel = ClassModel(doc.id.substring(0..4), uid, className, classPassword)
        doc.set(newClassModel.dictionary)
    }

    fun checkClassOccurrence(name: String): Boolean {
        return classroom.any { it.className == name }
    }

    fun addStudent(classId: String, classPassword: String, completion: (String?) -> Unit) {
        database.collection("Classes").whereEqualTo("id", classId)
            .whereEqualTo("password", classPassword).get().addOnCompleteListener {
                if (it.isCanceled) {
                    completion("Error getting documents ${it.exception?.message}")
                } else if (it.isSuccessful) {
                    val docs = it.result?.documents
                    if (docs == null) {
                        completion("Error getting documents ${it.exception?.message}")
                        return@addOnCompleteListener
                    }
                    if (docs.isEmpty()) {
                        completion("No class with this id and password")
                    } else {
                        UserDataSource.instance.editUserData(hashMapOf("classId" to classId))
                        completion(null)
                    }
                }
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun startObservingClassTutorials() {
        UserDataSource.instance.getCurrentUserInfo { userModel ->
            val userModel = userModel as? StudentModel ?: return@getCurrentUserInfo
            val classId = userModel.classId ?: return@getCurrentUserInfo
            database.collection("Classes").whereEqualTo("id", classId).get().addOnCompleteListener { taskQuerySnapshot ->
                if (taskQuerySnapshot.isCanceled) {
                    throw Exception("Error getting documents ${taskQuerySnapshot.exception?.message}")
                } else if (taskQuerySnapshot.isSuccessful) {
                    val dict = taskQuerySnapshot.result?.documents?.get(0)?.data ?: return@addOnCompleteListener
                    val teacherId = dict["teacherId"] as String
                    val classTutorialRef = database.collection("Users").document(teacherId).collection("Tutorials")
                    snapshotListenerForClassTutorials = classTutorialRef.addSnapshotListener { docSnapshot, error ->
                        val documents = docSnapshot?.documents ?: return@addSnapshotListener
                        classTutorials = documents.map { CodeModel(it.data as HashMap<String, Any>) }
                        notificationCenter.post(Changes.classTutorialChanged, null, hashMapOf("classTutorialChanged" to classTutorials))
                    }
                }
            }
        }
    }

    fun stopObservingClassTutorials() {
        val snapshotListenerForClassTutorials = snapshotListenerForClassTutorials ?: return
        snapshotListenerForClassTutorials.remove()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun getClassName(completion: (String?) -> Unit) {
        UserDataSource.instance.getCurrentUserInfo { userModel ->
            val userModel = userModel as? StudentModel ?: return@getCurrentUserInfo
            val classId = userModel.classId ?: return@getCurrentUserInfo
            database.collection("Classes").whereEqualTo("id", classId).get().addOnCompleteListener {
                val dict = it.result?.documents?.get(0)?.data
                if (dict == null) {
                    completion(null)
                } else {
                    val className = dict["className"] as? String
                    completion(className)
                }
            }
        }
    }

    private object HOLDER {
        val INSTANCE = TeacherClassDataSource()
    }

    companion object {
        val instance: TeacherClassDataSource by lazy { HOLDER.INSTANCE }
    }
}