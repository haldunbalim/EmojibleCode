package com.dji.emojibleandroid.models.modelFactories

import com.dji.emojibleandroid.models.StudentModel
import com.dji.emojibleandroid.models.TeacherModel
import com.dji.emojibleandroid.models.UserModel


class UserFactory private constructor(){

    fun create(userType: String, email: String, name: String, surname: String, birthDate: String, classIds: MutableList<String> = mutableListOf(), classId: String? = null): UserModel{
        return when(userType) {
            "Teacher" -> TeacherModel(email, name, surname, birthDate, classIds)
            "Student" -> StudentModel(email, name, surname, birthDate, classId)
            else -> throw Exception("userType $userType is not a valid userType")
        }
    }

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