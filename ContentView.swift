import SwiftUI

struct ContentView: View {
    @State private var traceRouteOutput = ""
    
    var body: some View {
        VStack {
            Button(action: {
                startTraceRoute()
            }) {
                Text("Iniciar")
            }
            
            ScrollView {
                Text(traceRouteOutput)
                    .padding()
            }
        }
    }
    
    func startTraceRoute() {
        let domain = "twitter.com"
        let apiKey = "e656579f2b1b6c414fb4bbd646e9ce769863a389"
        
        fetchTraceRoute(domain: domain, apiKey: apiKey) { (hops, error) in
            if let error = error {
                print("Erro ao obter rota: \(error.localizedDescription)")
                return
            }
            
            var output = ""
            for hop in hops {
                output += "Hop \(hop.number): Hostname: \(hop.hostname), IP: \(hop.ip), RTT: \(hop.rtt)\n"
            }
            
            DispatchQueue.main.async {
                self.traceRouteOutput = output
            }
        }
    }
}
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
