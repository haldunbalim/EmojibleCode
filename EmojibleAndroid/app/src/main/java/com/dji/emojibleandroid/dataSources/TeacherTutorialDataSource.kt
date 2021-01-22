package com.dji.emojibleandroid.dataSources

import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.services.AuthenticationManager
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.google.firebase.firestore.ListenerRegistration
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class TeacherTutorialDataSource private constructor(){

    val database = Firebase.firestore
    var snapshotListener: ListenerRegistration? = null
    val notificationCenter = NotificationCenter.instance
    var tutorials = listOf<CodeModel>()
    var tutorialsDataSourceIndices = listOf<String>()

    fun startObservingTutorials() {
        val currentUser = AuthenticationManager.instance.currentUser ?: return
        val userDocRef = database.collection("Users").document(currentUser.uid)
        val tutorialsCollectionRef = userDocRef.collection("Tutorials")
        snapshotListener = tutorialsCollectionRef.addSnapshotListener { querySnapshot, error ->
            val documents = querySnapshot?.documents ?: return@addSnapshotListener
            tutorials = documents.map { CodeModel(it.data as HashMap<String, Any>) }
            tutorialsDataSourceIndices = documents.map { it.id }
            notificationCenter.post(Changes.teacherTutorialsChanged, null, hashMapOf("teacherTutorialsChanged" to tutorials))
        }
    }

    fun stopObservingTutorials() {
        val snapshotListener = snapshotListener ?: return
        snapshotListener.remove()
    }

    fun editTutorial(oldTutorial: CodeModel, newTutorial: CodeModel) {
        val currentUser = AuthenticationManager.instance.currentUser ?: return
        val oldT = tutorials.find { it.name == oldTutorial.name }
        val index = tutorials.indexOf(oldT)
        val uid = currentUser.uid
        if (index != -1)
            database.collection("Users").document(uid).collection("Tutorials").document(tutorialsDataSourceIndices[index]).set(newTutorial.dictionary)
    }

    fun removeTutorial(tutorial: CodeModel) {
        val currentUser = AuthenticationManager.instance.currentUser ?: return
        val oldT = tutorials.find { it.name == tutorial.name }
        val index = tutorials.indexOf(oldT)
        val uid = currentUser.uid
        if (index != -1)
            database.collection("Users").document(uid).collection("Tutorials").document(tutorialsDataSourceIndices[index]).delete()
    }

    fun writeTutorial(tutorial: CodeModel) {
        val currentUser = AuthenticationManager.instance.currentUser ?: return
        val uid = currentUser.uid
        database.collection("Users").document(uid).collection("Tutorials").add(tutorial.dictionary)
    }

    private object HOLDER {
        val INSTANCE = TeacherTutorialDataSource()
    }

    companion object {
        val instance: TeacherTutorialDataSource by lazy { HOLDER.INSTANCE }
    }
}