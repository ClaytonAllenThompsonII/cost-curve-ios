import Foundation
import UIKit

struct ClassificationResult: Identifiable {
    let id = UUID()
    let label: String
    let score: Double
}

class DjangoService {
    static let shared = DjangoService()
    
    private init() {}
    
    /// Sends an image to the Django backend for classification.
    func classifyImageViaBackend(image: UIImage, completion: @escaping ([ClassificationResult]) -> Void) {
        // Replace with your actual Django endpoint URL
        guard let url = URL(string: "http://127.0.0.1:8000/image-classifier/classify/") else {
            print("Invalid URL")
            completion([])
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create a unique boundary string using a UUID
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Convert image to JPEG data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Could not convert image to JPEG")
            completion([])
            return
        }
        
        // Build multipart form data
        var body = Data()
        let fieldName = "image"
        let fileName = "image.jpg"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Create a session with a timeout of 10 seconds to mimic the Django settings.
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: config)
        
        // Send the request
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion([])
                return
            }
            
            // Log the raw response (similar to your Python prints)
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Django API Raw Response: \(rawResponse)")
            }
            
            do {
                // Parse the JSON response into an array of dictionaries.
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let resultsArray = json["results"] as? [[String: Any]] {
                    
                    let results: [ClassificationResult] = resultsArray.compactMap { dict in
                        guard let label = dict["label"] as? String,
                              let score = dict["score"] as? Double else {
                            return nil
                        }
                        return ClassificationResult(label: label, score: score)
                    }
                    completion(results)
                } else {
                    print("Unexpected JSON structure")
                    completion([])
                }
            } catch {
                print("JSON parsing error: \(error)")
                completion([])
            }
        }
        task.resume()
    }
}
