package com.dji.emojibleandroid.interpreter

import android.os.Build
import androidx.annotation.RequiresApi
import com.dji.emojibleandroid.models.AssignmentModel
import com.dji.emojibleandroid.models.Value

open class Memory(assignments: List<AssignmentModel>?) {
    var assignments: MutableList<AssignmentModel> = assignments?.toMutableList() ?: mutableListOf()

    fun contains(identifier: CharSequence): Boolean {
        return assignments.any { it.identifier == identifier }
    }

    open fun editAssignment(assignment: AssignmentModel) {
        val assignmentIndex = assignments.indexOfFirst { it.identifier == assignment.identifier }
        assignments[assignmentIndex] = assignment
    }

    open fun addAssignment(assignment: AssignmentModel) {
        assignments.add(assignment)
    }

    @RequiresApi(Build.VERSION_CODES.N)
    open fun removeContent(assignment: AssignmentModel) {
        assignments.removeIf { it.identifier == assignment.identifier }
    }
}