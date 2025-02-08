//
//  AddPetTests.swift
//  swift-sam-petstore
//
//  Created by Michael Einreinhof on 2/5/25.
//

import Testing
@testable import AddPet

@Test func alwaysPasses() {
    #expect(true)
}

struct TestClient: APIProtocol {
    func addPet(_ input: Operations.addPet.Input) async throws -> Operations.addPet.Output {
        <#code#>
    }
}
