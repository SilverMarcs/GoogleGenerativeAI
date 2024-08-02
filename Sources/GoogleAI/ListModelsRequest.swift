// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

@available(iOS 15.0, macOS 11.0, macCatalyst 15.0, *)
struct ListModelsRequest {
    let options: RequestOptions
    
    public init(options: RequestOptions = RequestOptions()) {
        self.options = options
    }
}

@available(iOS 15.0, macOS 11.0, macCatalyst 15.0, *)
extension ListModelsRequest: GenerativeAIRequest {
    typealias Response = ModelList
    
    var url: URL {
        URL(string: "\(GenerativeAISwift.baseURL)/\(options.apiVersion)/models")!
    }
}

// MARK: - Responses
public struct ModelList: Codable {
    public let models: [ModelResult]
    public let nextPageToken: String?
}

public struct ModelResult: Codable {
    public let name: String
    public let baseModelId: String?
    public let version: String
    public let displayName: String?
    public let description: String?
    public let inputTokenLimit: Int?
    public let outputTokenLimit: Int?
    public let supportedGenerationMethods: [String]?
    public let temperature: Double?
    public let maxTemperature: Double?
    public let topP: Double?
    public let topK: Int?
}


// MARK: - Codable Conformances

@available(iOS 15.0, macOS 11.0, macCatalyst 15.0, *)
extension ListModelsRequest: Encodable {
    enum CodingKeys: CodingKey { }
}
