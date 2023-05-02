//
//  MainScreen.swift
//  Gojo
//
//  Created by Luke Drushell on 4/27/23.
//

import SwiftUI
import WebKit

struct MainScreen: View {
    
    @State var favorites: [Favorite] = []
    @State var pastSearches: [Favorite] = []
    @State var search: String = ""
    
    @State var currentURL = URL(string: "https://zoro.to/")
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color(red: 0.3, green: 0.8, blue: 0.65), Color(red: 0.3, green: 0.8, blue: 0.55)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    Text("Gojo TV")
                        .font(.system(.largeTitle, design: .rounded, weight: .black))
                        .foregroundColor(.white)
                        .padding(.top)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 3, y: 3)
                    Divider()
                        .shadow(color: .black.opacity(0.9), radius: 3, x: 3, y: 3)
                        .padding()
                    SearchBar(search: $search, favorites: $favorites, pastSearches: $pastSearches)
                    Divider()
                        .shadow(color: .black.opacity(0.9), radius: 3, x: 3, y: 3)
                        .padding()
                    FavoritesView(favorites: $favorites, pastSearches: $pastSearches)
                    Divider()
                        .shadow(color: .black.opacity(0.9), radius: 3, x: 3, y: 3)
                        .padding()
                    PastSearchesView(favorites: $favorites, pastSearches: $pastSearches)
                }
            }
        } .onAppear(perform: {
            if let data = UserDefaults.standard.data(forKey: "pastSearches") {
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode([Favorite].self, from: data) {
                    pastSearches = decodedData
                }
            }
            if let data = UserDefaults.standard.data(forKey: "favorites") {
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode([Favorite].self, from: data) {
                    favorites = decodedData
                }
            }
        })
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .preferredColorScheme(.dark)
    }
}

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    let webView: WKWebView
    
    @Binding var url: URL
    
    init(url: Binding<URL>) {
            self._url = url
            webView = WKWebView(frame: .zero)
            webView.load(URLRequest(url: url.wrappedValue))
        }
    
    func makeUIView(context: Context) -> WKWebView {
        webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            DispatchQueue.main.async {
                uiView.load(URLRequest(url: url))
            }
        }
    }
}

extension UIScreen {
    static let width = UIScreen.main.bounds.width
}

extension String {
    func zoroURL() -> URL {
        let allowedCharacterSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? ""
        let urlString = "https://zoro.to/search?keyword=\(encodedString)"
        return URL(string: urlString) ?? URL(string: "https://google.com/")!
    }
}
