package com.dji.emojibleandroid.models

class ModelTutorial {

    var title: String? = "S"
    // var image:String ? = "S"

    constructor(title: String?) {
        this.title = title
        //this.image = image
    }
}

object Supplier {

    val tutorials = listOf<ModelTutorial>(
        ModelTutorial("Ders1"),
        ModelTutorial("Ders2"),
        ModelTutorial("Ders3")
    )
}