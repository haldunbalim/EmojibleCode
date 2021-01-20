package com.dji.emojibleandroid.dataSources

import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.services.AuthenticationManager
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.google.firebase.firestore.ListenerRegistration
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class TutorialDataSource {
    var database = Firebase.firestore
    var snapShotListener: ListenerRegistration? = null
    val notificationCenter: NotificationCenter = NotificationCenter.instance
    var tutorialDataSourceIndices: List<String> = listOf()

    fun startObservingProgram() {
        val tutorialsCollectionRef = database.collection("DefaultTutorials")
        snapShotListener = tutorialsCollectionRef.addSnapshotListener { querySnapshot, _ ->
            val documents = querySnapshot?.documents
            val defaultTutorials = documents?.map { CodeModel(it.data as HashMap<String, Any>) }
            tutorialDataSourceIndices = documents?.map { it.id }!!
            notificationCenter.post(
                Changes.defaultTutorialsChanged,
                null,
                "defaultTutorials" to defaultTutorials
            )
        }
    }

    fun stopObservingProgram() {
        snapShotListener?.remove()
    }

    fun editTutorial(index: Int, newModel: CodeModel) {
        database.collection("DefaultTutorials").document(tutorialDataSourceIndices[index])
            .set(newModel.dictionary)
    }

    private object HOLDER {
        val INSTANCE = TutorialDataSource()
    }

    companion object {
        val instance: TutorialDataSource by lazy { HOLDER.INSTANCE }
    }
}