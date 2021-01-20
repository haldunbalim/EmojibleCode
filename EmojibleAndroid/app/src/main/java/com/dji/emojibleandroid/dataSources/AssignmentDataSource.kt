package com.dji.emojibleandroid.dataSources

import com.dji.emojibleandroid.models.AssignmentModel
import com.dji.emojibleandroid.services.AuthenticationManager
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.ListenerRegistration
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import java.util.*
import kotlin.collections.HashMap

class AssignmentDataSource private constructor() {
    val database = Firebase.firestore
    var snapShotListener: ListenerRegistration? = null
    val notificationCenter = NotificationCenter.instance
    var assignments: List<AssignmentModel> = listOf()
    var assignmentDataSourceIndices: List<String> = listOf()

    fun startObservingAssignments() {
        val currentUser = FirebaseAuth.getInstance().currentUser.let { it } ?: return
        val userDocRef = database.collection("Users").document(currentUser.uid)
        val assignmentsCollectionRef = userDocRef.collection("Assignments")
        snapShotListener = assignmentsCollectionRef.addSnapshotListener { querySnapshot, error ->
            val documents = querySnapshot?.documents ?: return@addSnapshotListener
            assignments = documents.map { AssignmentModel(it.data as HashMap<String, Any>) }
            assignmentDataSourceIndices = documents.map { it.id }
            notificationCenter.post(
                Changes.assignmentsChanged,
                null,
                "assignmentsChanged" to assignments
            )
        }
    }

    fun stopObservingAssignments() {
        snapShotListener?.remove()
    }

    fun editAssignment(oldAssignment: AssignmentModel, newValue: Any) {
        val currentUser = AuthenticationManager.instance.currentUser
        var index: Int? = null
        assignments.forEachIndexed { i, document ->
            if (document == oldAssignment)
                index = i
            return
        }
        val uid = currentUser?.uid
        uid?.let {
            database.collection("Users").document(it).collection("Assignments")
                .document(assignmentDataSourceIndices[index!!]).set(
                    AssignmentModel(
                        identifier = oldAssignment.identifier,
                        v = newValue
                    ).dictionary
                )
        }
    }

    fun removeAssignment(assignment: AssignmentModel) {
        val currentUser = AuthenticationManager.instance.currentUser
        var index: Int? = null
        assignments.forEachIndexed { i, document ->
            if (document == assignment)
                index = i
            return
        }
        val uid = currentUser?.uid
        uid?.let {
            database.collection("Users").document(it).collection("Assignments")
                .document(assignmentDataSourceIndices[index!!]).delete()
        }
    }

    fun writeAssignment(assignment: AssignmentModel) {
        val currentUser = AuthenticationManager.instance.currentUser
        val uid = currentUser?.uid
        uid?.let {
            database.collection("Users").document(it).collection("Assignments")
                .add(assignment.dictionary)
        }
    }

    private object HOLDER {
        val INSTANCE = AssignmentDataSource()
    }

    companion object {
        val instance: AssignmentDataSource by lazy { HOLDER.INSTANCE }
    }
}
