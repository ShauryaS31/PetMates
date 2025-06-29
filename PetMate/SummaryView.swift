import SwiftUI
import WebKit

struct SummaryView: View {
    
    let totalTasks: Int
    let doneTasks: Int
    let petName: String
    let petType: String
    
    var completionRate: Double {
        totalTasks == 0 ? 0 : Double(doneTasks) / Double(totalTasks)
    }
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Today's Summary for \(petName.isEmpty ? "Your Pet" : petName)")
                .font(.title2)
                .bold()
            
            if completionRate == 1.0 {
                GIFView(url: "https://media.tenor.com/Z9rjOR3xjScAAAAC/happy-dog-dog.gif")
                    .frame(width: 150, height: 150)
            } else {
                Image(systemName: faceIcon())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(faceColor())
            }
            
            ProgressView(value: completionRate)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .padding()
            
            Text("\(Int(completionRate * 100))% of tasks completed")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(" Tasks Done: \(doneTasks)")
                Text("Tasks Missed: \(totalTasks - doneTasks)")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Daily Progress")
    }
    
    func faceIcon() -> String {
        if completionRate >= 0.5 {
            return "face.neutral"
        } else {
            return "face.dashed"
        }
    }
    
    func faceColor() -> Color {
        if completionRate >= 0.5 {
            return .yellow
        } else {
            return .red
        }
    }
}

struct GIFView: UIViewRepresentable {
    let url: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.isUserInteractionEnabled = false
        webView.backgroundColor = .clear
        if let gifURL = URL(string: url) {
            let request = URLRequest(url: gifURL)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
