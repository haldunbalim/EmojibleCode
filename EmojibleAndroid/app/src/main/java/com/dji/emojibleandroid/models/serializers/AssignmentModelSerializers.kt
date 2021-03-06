package com.dji.emojibleandroid.models.serializers

import com.dji.emojibleandroid.models.AssignmentModel
import com.dji.emojibleandroid.models.CodeModel
import com.google.gson.*
import java.lang.Exception
import java.lang.reflect.Type

class AssignmentModelDeserializer : JsonDeserializer<AssignmentModel> {
    override fun deserialize(
        json: JsonElement?,
        typeOfT: Type?,
        context: JsonDeserializationContext?
    ): AssignmentModel {
        json as JsonObject
        val identifier = json.get("identifier").asString as CharSequence
        var v: Any
        var vInfo: Any
        try {
            vInfo = json.getAsJsonPrimitive("v")
            v = when {
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
                    "Error"
                }
            }
        } catch (e: ClassCastException) {
            vInfo = json.get("v")
            val gson = Gson()
            v = gson.fromJson(vInfo, CodeModel::class.java)
        }

        return AssignmentModel(identifier, v)
    }
}

class AssignmentModelSerializer : JsonSerializer<AssignmentModel> {

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