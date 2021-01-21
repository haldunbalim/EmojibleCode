package com.dji.emojibleandroid.models

import android.os.Build
import androidx.annotation.RequiresApi
import java.time.LocalDate

class TeacherModel(
    email: String,
    name: String,
    surname: String,
    birthDate: String,
    var classIds: MutableList<String>? = mutableListOf()
) : UserModel(email, name, surname, birthDate) {
    constructor(dictionary: HashMap<String, Any>) : this(
        dictionary["email"] as String,
        dictionary["name"] as String,
        dictionary["surname"] as String,
        dictionary["birthDate"] as String
    ) {
        classIds = dictionary["classIds"] as MutableList<String>?
    }

    override var dictionary: HashMap<String, Any> = super.dictionary.let {
        it["classIds"] = classIds as Any
        it["userType"] = "Teacher"
        it
    }
}