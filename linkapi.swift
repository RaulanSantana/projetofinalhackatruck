import Foundation

struct TraceRouteResponse: Codable {
    let query: Query
    let response: Response
}

struct Query: Codable {
    let tool: String
    let domain: String
}

struct Response: Codable {
    let hops: [Hop]
}

struct Hop: Codable {
    let number: String
    let hostname: String
    let ip: String
    let rtt: String
}

func fetchTraceRoute(domain: String, apiKey: String, completion: @escaping ([Hop], Error?) -> Void) {
    guard let url = URL(string: "https://api.viewdns.info/traceroute/?domain=\(domain)&apikey=\(apiKey)&output=json") else {
        completion([], NSError(domain: "InvalidURL", code: -1, userInfo: nil))
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion([], error)
            return
        }
        
        guard let data = data else {
            completion([], NSError(domain: "EmptyData", code: -1, userInfo: nil))
            return
        }
        
        do {
            let result = try JSONDecoder().decode(TraceRouteResponse.self, from: data)
            completion(result.response.hops, nil)
        } catch {
            completion([], error)
        }
    }.resume()
}
