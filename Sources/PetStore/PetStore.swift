import Foundation
import OpenAPIRuntime
import OpenAPILambda

@main
struct PetStore: APIProtocol, OpenAPILambdaHttpApi {
    
    init(transport: OpenAPILambdaTransport) throws {
        let printingMiddleware = PrintingMiddleware()
        let errorMiddleware = ErrorHandlingMiddleware()
        try self.registerHandlers(on: transport, middlewares: [printingMiddleware, errorMiddleware])
    }
    
//    func uploadFile(_ input: Operations.uploadFile.Input) async throws -> Operations.uploadFile.Output {
//        switch input.body {
//        case .none:
//            return .badRequest(.init())
//        case .some(_):
//            return .ok(.init(body: .json(.init())))
//        }
//    }
    
    func deletePet(_ input: Operations.deletePet.Input) async throws -> Operations.deletePet.Output {
        var pets2: [Components.Schemas.Pet] = pets
        var petId: Int64?
        if let id: Int64 = Int64(exactly: input.path.petId) {
            petId = id
        } else {
            return .badRequest(.init())
        }
        
        if petId! < 0 {
            return .badRequest(.init())
        }
        guard let index = pets.firstIndex(where: { $0.id == petId }) else {
            return .badRequest(.init())
        }
        pets2.remove(at: index)
        
        return .ok(.init())
    }
    
    func getPetById(_ input: Operations.getPetById.Input) async throws -> Operations.getPetById.Output {
        print("type: \(type(of: input.path.petId))")
        var petId: Int64?
        if let id: Int64 = Int64(exactly: input.path.petId) {
            petId = id
        } else {
            return .badRequest(.init())
        }
        
        if petId! < 0 {
            return .badRequest(.init())
        }
        
        guard let pet: Components.Schemas.Pet = pets.first(where: { $0.id == petId }) else { return .notFound(.init()) }
        
        return .ok(.init(body: .json(pet)))
    }
    
    func findPetsByTags(_ input: Operations.findPetsByTags.Input) async throws -> Operations.findPetsByTags.Output {
        guard let inputTags = input.query.tags else { return .badRequest(.init()) }
        //Forcing unwrap
        let matchingTags = tags.filter { inputTags.contains( $0.name! ) }
        let petsWithTags: [Components.Schemas.Pet] = pets.filter { pet in
            // Forcing unwrap
            pet.tags!.contains { petTag in
                matchingTags.contains { $0.id == petTag.id! }
            }
        }
        return .ok(.init(body: .json([pets[0], pets[1]])))
    }
    
    func findPetsByStatus(_ input: Operations.findPetsByStatus.Input) async throws -> Operations.findPetsByStatus.Output {
        let statusInput = input.query.status
        switch statusInput {
        case .available:
            let petsMatching: [Components.Schemas.Pet] = pets.filter{ $0.status == .available }
            return .ok(.init(body: .json(petsMatching)))
        case .pending:
            let petsMatching: [Components.Schemas.Pet] = pets.filter{ $0.status == .pending}
            return .ok(.init(body: .json(petsMatching)))
        case .none:
            let petsMatching: [Components.Schemas.Pet] = pets.filter{ $0.status == .none}
            return .ok(.init(body: .json(petsMatching)))
        case .sold:
            let petsMatching: [Components.Schemas.Pet] = pets.filter{ $0.status == .sold}
            return .ok(.init(body: .json(petsMatching)))
        }
    }
    
    func updatePet(_ input: Operations.updatePet.Input) async throws -> Operations.updatePet.Output {
        var pets2: [Components.Schemas.Pet] = pets
        let requestBody: Components.Schemas.Pet
        switch input.body {
            case .json(let json):
                requestBody = json
        }
        
        guard let id = requestBody.id, id > 0 else {
            return .badRequest(.init())
        }
        
        guard let index = pets.firstIndex(where: { $0.id == requestBody.id }) else {
            return .notFound(.init())
        }
        
        do {
            pets2[index] = requestBody
        } catch {
            return .unprocessableContent(.init())
        }
        
        return .ok(.init(body: .json(pets2[index])))
    }
    
    func addPet(_ input: Operations.addPet.Input) async throws -> Operations.addPet.Output {
        let requestBody: Components.Schemas.Pet
        switch input.body {
            case .json(let json): requestBody = json
        }
        var pets2: [Components.Schemas.Pet] = pets
        pets2.append(requestBody)
        
        return .ok(.init(body: .json(requestBody)))
    }
    

}

let categories: [Components.Schemas.Category] = [
    .init(id: 1, name: "Cat"),
    .init(id: 2, name: "Dog"),
    .init(id: 3, name: "Bird"),
    .init(id: 4, name: "Reptile"),
    .init(id: 5, name: "Fish")
]

let tags: [Components.Schemas.Tag] = [
    .init(id: 1, name: "Cute"),
    .init(id: 2, name: "Smart"),
    .init(id: 3, name: "Lazy"),
    .init(id: 4, name: "Happy"),
    .init(id: 5, name: "Funny")
]

let pets: [Components.Schemas.Pet] = [
    .init(id: 0, name: "ArloKitty", category: categories[0], photoUrls: ["http://images4.fanpop.com/image/photos/16000000/Beautiful-Cat-cats-16096437-1280-800.jpg"], tags: [tags[1]], status: .sold),
    .init(id: 1, name: "Arlo", category: categories[0], photoUrls: ["http://images4.fanpop.com/image/photos/16000000/Beautiful-Cat-cats-16096437-1280-800.jpg"], tags: [tags[1]], status: .available),
    .init(id: 2, name: "Kida", category: categories[0], photoUrls: ["https://dogsandcatshq.com/wp-content/uploads/2020/07/Russian-Blue-Cat-1-scaled.jpg"], tags: [tags[0]], status: .pending),
    .init(id: 3, name: "Koda", category: categories[1], photoUrls: ["https://1.bp.blogspot.com/-jxRboCGxxQs/T-ciYpWY2iI/AAAAAAAACzg/b1xy4rL33TQ/s1600/German+shepherd+images.jpg"], tags: [tags[1], tags[4]], status: .sold)
]
