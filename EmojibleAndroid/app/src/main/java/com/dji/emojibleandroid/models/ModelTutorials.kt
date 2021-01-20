package com.dji.emojibleandroid.models

class ModelTutorials {

    var title: String? = "S"
    // var image:String ? = "S"

    constructor(title: String?) {
        this.title = title
        //this.image = image
    }
}

object SupplierTutorial {

    val tutorials = listOf<ModelTutorials>(
        ModelTutorials("Ders1"),
        ModelTutorials("Ders2"),
        ModelTutorials("Ders3"),
        ModelTutorials("Ders4"),
        ModelTutorials("Ders5"),
        ModelTutorials("Ders6"),
        ModelTutorials("Ders7"),
        ModelTutorials("Ders8"),
        ModelTutorials("Ders9")
    )
}