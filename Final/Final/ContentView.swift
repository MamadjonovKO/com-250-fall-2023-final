import SwiftUI

struct IPAddress: Codable {
    let ip: String
}

struct MyPublicIPView: View {
    @State private var ipAddress = "Loading..."
    @State private var isLoading = true

    var body: some View {
        Text(ipAddress)
            .onAppear(perform: loadIPAddress)
            .padding()
    }
    
    func loadIPAddress() {
        guard let url = URL(string: "https://api.ipify.org?format=json") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(IPAddress.self, from: data) {
                    DispatchQueue.main.async {
                        self.ipAddress = decodedResponse.ip
                        self.isLoading = false
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                self.ipAddress = "Failed to load IP"
            }
        }.resume()
    }
}


struct ContentView: View {
    @State private var showingDateTime = false
    @State private var showingPublicIP = false

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                showingDateTime = true
            }) {
                Text("Date and Time")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .sheet(isPresented: $showingDateTime) {
                DateTimeView()
            }
            
            Button(action: {
                showingPublicIP = true
            }) {
                Text("My Public IP")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .sheet(isPresented: $showingPublicIP) {
                MyPublicIPView()
            }
        }
        .padding()
    }
}


struct DateTimeView: View {
    let now = Date()
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm MM/dd/yyyy"
        return formatter
    }()

    var body: some View {
        Text(formatter.string(from: now))
            .font(.system(size: 36))
            .padding()
    }
}
