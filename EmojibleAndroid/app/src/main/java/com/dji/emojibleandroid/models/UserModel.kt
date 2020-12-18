package com.dji.emojibleandroid.models

import android.os.Build
import androidx.annotation.RequiresApi
import java.time.LocalDate
import kotlin.collections.HashMap

open class UserModel constructor(
    var email: String,
    var name: String,
    var surname: String,
    var birthDate: String
) {
    constructor(dictionary: HashMap<String, Any>) : this(
        dictionary["email"] as String,
        dictionary["name"] as String,
        dictionary["surname"] as String,
        dictionary["birthDate"] as String
    )

    open var dictionary: HashMap<String, Any> =
        hashMapOf("email" to email, "name" to name, "surname" to surname, "birthDate" to birthDate)
}
