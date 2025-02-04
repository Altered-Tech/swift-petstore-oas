//
//  main.swift
//  swift-sam-example
//
//  Created by Michael Einreinhof on 2/3/25.
//

import Foundation
import OpenAPIRuntime
import OpenAPILambda

@main
struct GetPetById: APIProtocol, OpenAPILambdaHttpApi {
    
    init(transport: OpenAPILambdaTransport) throws {
        try self.registerHandlers(on: transport, middlewares: [ErrorHandlingMiddleware()])
    }
    
    func getPetById(_ input: Operations.getPetById.Input) async throws -> Operations.getPetById.Output {
        print("In the function")
        var petId: Int64?
        if let id: Int64 = Int64(exactly: input.path.petId) {
            petId = id
        } else {
            return .badRequest(.init())
        }
        
        if petId! < 0 {
            return .badRequest(.init())
        }
        
        guard let pet: Components.Schemas.Pet = petsExample.first(where: { $0.id == petId }) else { return .notFound(.init()) }
        
        return .ok(.init(body: .json(pet)))
    }
}
