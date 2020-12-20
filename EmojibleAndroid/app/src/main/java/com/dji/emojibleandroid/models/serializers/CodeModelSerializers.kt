package com.dji.emojibleandroid.models.serializers

import com.dji.emojibleandroid.models.AssignmentModel
import com.dji.emojibleandroid.models.CodeModel
import com.google.gson.*
import java.lang.Exception
import java.lang.reflect.Type

class CodeModelSerializer : JsonSerializer<CodeModel> {
    override fun serialize(
        src: CodeModel?,
        typeOfSrc: Type?,
        context: JsonSerializationContext?
    ): JsonElement {
        val jsonObject = JsonObject()
        try {
            jsonObject.add("name", context?.serialize(src?.name))
            jsonObject.add("code", context?.serialize(src?.code))
        } catch (e: Exception) {
            throw Exception(e.message)
        }
        return jsonObject
    }
}

class CodeModelDeserializer: JsonDeserializer<CodeModel> {
    override fun deserialize(
        json: JsonElement?,
        typeOfT: Type?,
        context: JsonDeserializationContext?
    ): CodeModel {
        json as JsonObject
        val name = json.get("name").asString
        val code = json.getAsJsonPrimitive("code").asString
        return CodeModel(name, code)
    }

}