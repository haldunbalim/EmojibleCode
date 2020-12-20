package com.dji.emojibleandroid.models

import com.google.gson.*
import java.lang.Exception
import java.lang.reflect.Type

class AssignmentModelDeserializer: JsonDeserializer<AssignmentModel> {
    override fun deserialize(
        json: JsonElement?,
        typeOfT: Type?,
        context: JsonDeserializationContext?
    ): AssignmentModel {
        json as JsonObject
        val identifier = json.get("identifier").asString as CharSequence
        val vInfo = json.getAsJsonPrimitive("v")
        val v: Any = when {
            vInfo.isNumber -> {
                if (vInfo.asFloat - vInfo.asFloat.toInt() != 0.toFloat()) {
                    vInfo.asFloat
                } else {
                    vInfo.asInt
                }
            }
            vInfo.isBoolean -> {
                vInfo.asBoolean
            }
            vInfo.isString -> {
                vInfo.asString
            }
            else -> {
                throw Exception("Unknow type for AssignmentModel.v")
            }
        }
        return AssignmentModel(identifier, v)
    }
}

class AssignmentModelSerializer: JsonSerializer<AssignmentModel> {

    override fun serialize(
        src: AssignmentModel?,
        typeOfSrc: Type?,
        context: JsonSerializationContext?
    ): JsonElement {
        val jsonObject = JsonObject()
        try {
            jsonObject.add("identifier", context?.serialize(src?.identifier))
            jsonObject.add("v", context?.serialize(src?.v))
        } catch (e: Exception) {
            throw Exception(e.message)
        }
        return jsonObject
    }
}

fun String.intOrString(): Any {
    val v = toIntOrNull()
    return when(v) {
        null -> this
        else -> v
    }
}