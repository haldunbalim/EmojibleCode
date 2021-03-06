package com.dji.emojibleandroid.models

class StudentModel(
    email: String,
    name: String,
    surname: String,
    birthDate: String,
    var classId: String?
) : UserModel(email, name, surname, birthDate) {
    constructor(dictionary: HashMap<String, Any>) : this(
        dictionary["email"] as String,
        dictionary["name"] as String,
        dictionary["surname"] as String,
        dictionary["birthDate"] as String,
        dictionary["classId"] as String?
    ) {
        if (classId == "") {
            classId = null
        }
    }

    override var dictionary: HashMap<String, Any> = super.dictionary.let {
        if (classId == null)
            classId = ""
        it["classId"] = classId as Any
        it["userType"] = "Student"
        it
    }
}
