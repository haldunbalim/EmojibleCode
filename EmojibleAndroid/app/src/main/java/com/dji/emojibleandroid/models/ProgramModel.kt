package com.dji.emojibleandroid.models

class ProgramModel constructor(val viewType: Int, name: String, code: String): CodeModel(name, code) {

    constructor(dictionary: HashMap<String, Any>) : this(
        dictionary["viewType"] as Int,
        dictionary["name"] as String,
        (dictionary["code"] as String).replace("\\n", "\n")
    )

    constructor(viewType: Int, codeModel: CodeModel) : this(viewType, codeModel.name, codeModel.code)

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false
        if (!super.equals(other)) return false

        other as ProgramModel

        if (viewType != other.viewType) return false
        if (dictionary != other.dictionary) return false

        return true
    }
}
