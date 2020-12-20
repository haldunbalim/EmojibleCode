package com.dji.emojibleandroid.models

data class CodeModel constructor(var name: String, var code: String) {
    var dictionary: HashMap<String, Any> = hashMapOf("name" to name, "code" to code)

    constructor(dictionary: HashMap<String, Any>) : this(
        dictionary["name"] as String,
        (dictionary["code"] as String).replace("\\n", "\n")
    )

    override operator fun equals(other: Any?): Boolean {
        return this.name == (other as CodeModel).name
    }
}