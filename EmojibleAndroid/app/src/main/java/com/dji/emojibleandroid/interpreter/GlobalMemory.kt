package com.dji.emojibleandroid.interpreter

import android.content.SharedPreferences
import android.os.Build
import android.os.Environment
import androidx.annotation.RequiresApi
import com.dji.emojibleandroid.models.AssignmentModel
import com.dji.emojibleandroid.models.AssignmentModelDeserializer
import com.dji.emojibleandroid.models.AssignmentModelSerializer
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import java.io.File

class GlobalMemory private constructor(assignments: List<AssignmentModel>? = null) :
    Memory(readAssignmentsFromJson()) {

    override fun editAssignment(assignment: AssignmentModel) {
        super.editAssignment(assignment)
        writeAssignmentsToJson(assignments)
    }

    @RequiresApi(Build.VERSION_CODES.N)
    override fun removeContent(assignment: AssignmentModel) {
        super.removeContent(assignment)
        writeAssignmentsToJson(assignments)
    }

    override fun addAssignment(assignment: AssignmentModel) {
        if (assignment in assignments) {
            editAssignment(assignment)
            return
        }
        super.addAssignment(assignment)
        writeAssignmentsToJson(assignments)
    }

    private object HOLDER {
        val INSTANCE = GlobalMemory()
    }

    companion object {
        val instance: GlobalMemory by lazy { HOLDER.INSTANCE }
        lateinit var sharedPreferences: SharedPreferences
        private fun readAssignmentsFromJson(): List<AssignmentModel> {
            val retVal = sharedPreferences.getString("Assignments.json", "")
            val gson = GsonBuilder().registerTypeAdapter(AssignmentModel::class.java, AssignmentModelDeserializer()).create()
            val tokenType = object: TypeToken<List<AssignmentModel>>() {}.type
            return if (retVal != "") retVal.let { gson.fromJson<List<AssignmentModel>>(it, tokenType) } else listOf()
        }

        private fun writeAssignmentsToJson(assignments: MutableList<AssignmentModel>) {
            val gson = GsonBuilder().registerTypeAdapter(AssignmentModel::class.java, AssignmentModelSerializer()).create()
            val jsonString = gson.toJson(assignments)
            val editor = sharedPreferences.edit()
            editor.putString("Assignments.json", jsonString).apply()
        }
    }
}