// Copyright 2023 Google LLC
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
struct GenerateContentRequest {
  /// Model name.
  let model: String
  let contents: [ModelContent]
  let generationConfig: GenerationConfig?
  let safetySettings: [SafetySetting]?
  let tools: [Tool]?
  let toolConfig: ToolConfig?
  let systemInstruction: ModelContent?
  let isStreaming: Bool
  let options: RequestOptions
}

@available(iOS 15.0, macOS 11.0, macCatalyst 15.0, *)
extension GenerateContentRequest: Encodable {
  enum CodingKeys: String, CodingKey {
    case model
    case contents
    case generationConfig
    case safetySettings
    case tools
    case toolConfig
    case systemInstruction
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(model, forKey: .model)
    try container.encode(contents, forKey: .contents)
    try container.encodeIfPresent(generationConfig, forKey: .generationConfig)
    try container.encodeIfPresent(safetySettings, forKey: .safetySettings)
    try container.encodeIfPresent(toolConfig, forKey: .toolConfig)
    try container.encodeIfPresent(systemInstruction, forKey: .systemInstruction)
    
    // Special handling for tools to merge function declarations
    if let tools = tools {
      var mergedTool = CombinedTool()
      for tool in tools {
        if let functionDeclarations = tool.functionDeclarations {
          mergedTool.functionDeclarations.append(contentsOf: functionDeclarations)
        }
        if tool.codeExecution != nil {
          mergedTool.codeExecution = tool.codeExecution
        }
        if tool.googleSearchRetrieval != nil {
          mergedTool.googleSearchRetrieval = tool.googleSearchRetrieval
        }
      }
      try container.encode([mergedTool], forKey: .tools)
    }
  }
  
  // Helper structure to combine tools
  private struct CombinedTool: Encodable {
    var functionDeclarations: [FunctionDeclaration] = []
    var codeExecution: CodeExecution?
    var googleSearchRetrieval: GoogleSearchRetrieval?
    
    enum CodingKeys: String, CodingKey {
      case functionDeclarations = "function_declarations"
      case codeExecution
      case googleSearchRetrieval
    }
  }
}

@available(iOS 15.0, macOS 11.0, macCatalyst 15.0, *)
extension GenerateContentRequest: GenerativeAIRequest {
  typealias Response = GenerateContentResponse

  var url: URL {
    let modelURL = "\(GenerativeAISwift.baseURL)/\(options.apiVersion)/\(model)"
    if isStreaming {
      return URL(string: "\(modelURL):streamGenerateContent?alt=sse")!
    } else {
      return URL(string: "\(modelURL):generateContent")!
    }
  }
}
