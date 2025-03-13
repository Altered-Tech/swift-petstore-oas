//
//  SchemathesisAddition.swift
//  swift-sam-example
//
//  Created by Michael Einreinhof on 2/4/25.
//

// This code is only to for the ability to properly throw decoding errors from Schemathesis.
// The error comes from when it attempts an interger overflow for signed Ints.
// This should hopefully be resolved in this Issue https://github.com/apple/swift-openapi-generator/issues/717

import HTTPTypes
import OpenAPIRuntime

extension DecodingError: @retroactive HTTPResponseConvertible {
    public var httpStatus: HTTPResponse.Status {
        switch self {

        case .typeMismatch:
                .badRequest
        case .valueNotFound:
                .badRequest
        case .keyNotFound:
                .notFound
        case .dataCorrupted:
                .badRequest
        @unknown default:
                .badRequest
        }
    }
}
