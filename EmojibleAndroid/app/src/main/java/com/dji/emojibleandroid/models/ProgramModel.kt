package com.dji.emojibleandroid.models

data class ProgramModel constructor(val viewType: Int, var name: String, var code: String) {
    var dictionary: HashMap<String, Any> = hashMapOf("name" to name, "code" to code)

    constructor(dictionary: HashMap<String, Any>) : this(
        dictionary["viewType"] as Int,
        dictionary["name"] as String,
        (dictionary["code"] as String).replace("\\n", "\n")
    )

    override operator fun equals(other: Any?): Boolean {
        return this.name == (other as ProgramModel).name
    }

    override fun toString(): String {
        return "$name Code"
    }

    override fun hashCode(): Int {
        var result = name.hashCode()
        result = 31 * result + code.hashCode()
        return result
    }
}
