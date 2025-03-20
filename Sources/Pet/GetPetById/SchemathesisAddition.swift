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
import Foundation

extension DecodingError: @retroactive HTTPResponseConvertible {
    public var httpStatus: HTTPResponse.Status {
        switch self {
        case .typeMismatch, .valueNotFound, .dataCorrupted:
            return .badRequest
        case .keyNotFound:
            return .notFound
        @unknown default:
            return .badRequest
        }
    }

    public var httpBody: OpenAPIRuntime.HTTPBody? {
        let errorMessage: String
        switch self {
        case .typeMismatch(let type, let context):
            errorMessage = "Type mismatch: Expected \(type) - \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            errorMessage = "Value not found: Expected \(type) - \(context.debugDescription)"
        case .keyNotFound(let key, let context):
            errorMessage = "Key not found: \(key.stringValue) - \(context.debugDescription)"
        case .dataCorrupted(let context):
            errorMessage = "Data corrupted: \(context.debugDescription)"
        @unknown default:
            errorMessage = "Unknown decoding error"
        }
        let errorResponse = Components.Schemas._Error(message: errorMessage, code: httpStatus.code)
        let jsonData = try? JSONEncoder().encode(errorResponse)
        return HTTPBody(jsonData ?? Data())
    }

    public var httpHeaderFields: HTTPTypes.HTTPFields {
        var fields = HTTPFields()
        fields[.contentType] = "application/json"
        return fields
    }
}
