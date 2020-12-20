package com.dji.emojibleandroid.models

enum class ValueType {
    Integer,
    Float,
    Boolean,
    String,
    Voice,
    Code;
}

data class AssignmentModel(var identifier: CharSequence, val v: Any) {
    var value: Value = Value(v)

    constructor(dictionary: HashMap<String, Any>) : this(
        dictionary["identifier"] as CharSequence,
        Value(dictionary["value"] as Any)
    )

    var dictionary: HashMap<String, Any> =
        hashMapOf("identifier" to identifier, "value" to value.value)

    override operator fun equals(other: Any?): Boolean {
        return this.identifier == (other as AssignmentModel).identifier
    }

    override fun hashCode(): Int {
        var result = identifier.hashCode()
        result = 31 * result + value.hashCode()
        result = 31 * result + dictionary.hashCode()
        result = 31 * result + description.hashCode()
        return result
    }

    var description: String = "$identifier 👉 ${value.description}"


}

class Value(var value: Any) {
    var type: ValueType

    init {
        type = getType(value)
    }

    companion object {
        private fun getType(value: Any): ValueType {
            return when (value) {
                is Int -> {
                    ValueType.Integer
                }
                is Float -> {
                    ValueType.Float
                }
                is Boolean -> {
                    ValueType.Boolean
                }
                is CodeModel -> ValueType.Code
                else -> {
                    println(value.javaClass.name)
                    if ((value as String).contains(".3gp")) {
                        ValueType.Voice
                    } else {
                        ValueType.String
                    }
                }
            }
        }
    }

    var description: String =
        when (type) {
            ValueType.Integer -> (value as Int).toString()
            ValueType.Float -> (value as Float).toString()
            ValueType.Boolean -> (value as Boolean).toString()
            ValueType.String -> (value as String)
            ValueType.Voice -> ""
            ValueType.Code -> (value as CodeModel).toString()
        }
}