package com.dji.emojibleandroid.models.modelFactories

import android.os.Build
import androidx.annotation.RequiresApi
import com.dji.emojibleandroid.models.StudentModel
import com.dji.emojibleandroid.models.TeacherModel
import com.dji.emojibleandroid.models.UserModel
import java.lang.Exception
import java.time.LocalDate


class UserFactory private constructor(){

    fun create(userType: String, email: String, name: String, surname: String, birthDate: LocalDate, classIds: MutableList<String> = mutableListOf(), classId: String): UserModel{
        return when(userType) {
            "Teacher" -> TeacherModel(email, name, surname, birthDate, classIds)
            "Student" -> StudentModel(email, name, surname, birthDate, classId)
            else -> throw Exception("userType $userType is not a valid userType")
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun create(dictionary: HashMap<String, Any>): UserModel {
        val userType: String = dictionary["userType"] as String
        return when (userType) {
            "Teacher" -> TeacherModel(dictionary)
            "Student" -> StudentModel(dictionary)
            else -> throw Exception("userType $userType is not a valid userType")
        }
    }

    private object HOLDER {
        val INSTANCE = UserFactory()
    }

    companion object {
        val instance: UserFactory by lazy { HOLDER.INSTANCE }
    }
}