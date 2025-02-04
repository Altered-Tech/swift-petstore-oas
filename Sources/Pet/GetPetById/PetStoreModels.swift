//
//  PetStoreModels.swift
//  swift-petstore-oas
//
//  Created by Michael Einreinhof on 2/4/25.
//


let categoriesExample: [Components.Schemas.Category] = [
    .init(id: 1, name: "Cat"),
    .init(id: 2, name: "Dog"),
    .init(id: 3, name: "Bird"),
    .init(id: 4, name: "Reptile"),
    .init(id: 5, name: "Fish")
]

let tagsExample: [Components.Schemas.Tag] = [
    .init(id: 1, name: "Cute"),
    .init(id: 2, name: "Smart"),
    .init(id: 3, name: "Lazy"),
    .init(id: 4, name: "Happy"),
    .init(id: 5, name: "Funny")
]

let petsExample: [Components.Schemas.Pet] = [
    .init(id: 0, name: "Arlo", category: categoriesExample[0], photoUrls: ["http://images4.fanpop.com/image/photos/16000000/Beautiful-Cat-cats-16096437-1280-800.jpg"], tags: [tagsExample[1]], status: .available),
    .init(id: 1, name: "Kida", category: categoriesExample[0], photoUrls: ["https://dogsandcatshq.com/wp-content/uploads/2020/07/Russian-Blue-Cat-1-scaled.jpg"], tags: [tagsExample[0]], status: .pending),
    .init(id: 2, name: "Koda", category: categoriesExample[1], photoUrls: ["https://1.bp.blogspot.com/-jxRboCGxxQs/T-ciYpWY2iI/AAAAAAAACzg/b1xy4rL33TQ/s1600/German+shepherd+images.jpg"], tags: [tagsExample[1], tagsExample[4]], status: .sold)
]
