package com.dji.emojibleandroid.models

data class ClassModel(
    var id: String,
    var teacherId: String,
    var className: String,
    var password: String
) {
    var dictionary = hashMapOf<String, Any>(
        "id" to id,
        "teacherId" to teacherId,
        "className" to className,
        "password" to password
    )

    constructor(dict: HashMap<String, Any>) : this(
        dict["id"] as String,
        dict["teacherId"] as String,
        dict["className"] as String,
        dict["password"] as String
    )

    override fun equals(other: Any?): Boolean {
        if (other is ClassModel) {
            return this.id == other.id && this.teacherId == other.teacherId
        }
        return false
    }
}
