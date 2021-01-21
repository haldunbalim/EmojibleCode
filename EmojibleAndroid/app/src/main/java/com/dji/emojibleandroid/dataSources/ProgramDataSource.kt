package com.dji.emojibleandroid.dataSources

import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.services.AuthenticationManager
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.google.firebase.firestore.ListenerRegistration
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class ProgramDataSource {
    var database = Firebase.firestore
    var snapShotListener: ListenerRegistration? = null
    val notificationCenter: NotificationCenter = NotificationCenter.instance
    var programs: List<CodeModel> = listOf()
    var programDataSourceIndices: List<String> = listOf()

    fun startObservingProgram() {
        val currentUser = AuthenticationManager.instance.currentUser
        val userDocRef = currentUser?.uid?.let { database.collection("Users").document(it) }
        val programsCollectionRef = userDocRef?.collection("Programs")
        snapShotListener = programsCollectionRef?.addSnapshotListener { querySnapshot, _ ->
            val documents = querySnapshot?.documents
            programs = documents?.map { CodeModel(it.data as HashMap<String, Any>) }!!
            programDataSourceIndices = documents.map { it.id }
            notificationCenter.post(Changes.programsChanged, null, "programs" to programs)
        }
    }

    fun stopObservingProgram() {
        snapShotListener?.remove()
    }

    fun editProgram(oldProgram: CodeModel, newProgram: CodeModel) {
        val currentUser = AuthenticationManager.instance.currentUser
        val pModel = programs.find { it == oldProgram } ?: return
        val index = programs.indexOf(pModel)
        val uid = currentUser?.uid
        uid?.let {
            database.collection("Users").document(it).collection("Programs")
                .document(programDataSourceIndices[index!!]).set(newProgram.dictionary)
        }
    }

    fun removeProgram(program: CodeModel) {
        val currentUser = AuthenticationManager.instance.currentUser
        val pModel = programs.find { it == program } ?: return
        val index = programs.indexOf(pModel)
        val uid = currentUser?.uid
        uid?.let {
            database.collection("Users").document(it).collection("Programs")
                .document(programDataSourceIndices[index]).delete()
        }
    }

    fun writeProgram(program: CodeModel) {
        val currentUser = AuthenticationManager.instance.currentUser
        val uid = currentUser?.uid
        uid?.let {
            database.collection("Users").document(it).collection("Programs")
                .add(program.dictionary)
        }
    }

    private object HOLDER {
        val INSTANCE = ProgramDataSource()
    }

    companion object {
        val instance: ProgramDataSource by lazy { HOLDER.INSTANCE }
    }
}