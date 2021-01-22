package com.dji.emojibleandroid.dataSources

import com.dji.emojibleandroid.models.StudentModel
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.google.firebase.firestore.ListenerRegistration
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class StudentsInClassDataSource private constructor(){
    val database = Firebase.firestore
    var snapshotListener: ListenerRegistration? = null
    val notificationCenter = NotificationCenter.instance
    var students: List<StudentModel>? = null

    fun startObservingStudentsInAClass(classId: String) {
        val classesCollectionRef = database.collection("Users").whereEqualTo("classId", classId)
        snapshotListener = classesCollectionRef.addSnapshotListener { querySnapshot, error ->
            val documents = querySnapshot?.documents ?: return@addSnapshotListener
            students = documents.map { StudentModel(it.data as HashMap<String, Any>) }
            notificationCenter.post(Changes.studentsInClassChanged, null, hashMapOf("studentsInClassChanged" to students))
        }
    }

    fun stopObservingStudentsInAClass() {
        val snapshotListener = snapshotListener ?: return
        snapshotListener.remove()
    }

    private object HOLDER {
        val INSTANCE = StudentsInClassDataSource()
    }

    companion object {
        val instance: StudentsInClassDataSource by lazy { HOLDER.INSTANCE }
    }
}