//
//  WebsiteView.swift
//  Gojo
//
//  Created by Luke Drushell on 4/26/23.
//

import SwiftUI

struct WebsiteView: View {

    @Binding var webURL: URL
    @State var fav: Favorite?
    @State var search: String
    @State var favoritedIcon: Bool
    @Binding var favorites: [Favorite]
    
    @Binding var pastSearches: [Favorite]
    
    @State var removeAtDismiss = false
    
    var body: some View {
        WebView(url: $webURL)
            .onAppear(perform: {
                withAnimation {
                    if let fav { webURL = fav.url }
                    favoritedIcon = favoritesContainURL(webURL)
                    DispatchQueue.main.async {
                        withAnimation {
                            pastSearches.removeAll(where: { $0.url == webURL })
                            pastSearches.insert(Favorite(title: fav != nil ? fav!.title : search, url: webURL), at: 0)
                            saveSearchData()
                        }
                    }
                }
            })
            .onDisappear(perform: {
                if removeAtDismiss { removeFavoriteMatching(webURL) }
            })
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button {
                        if favoritesContainURL(webURL) {
                            removeAtDismiss = true
                        } else {
                            favorites.insert(Favorite(title: fav != nil ? fav!.title : search, url: webURL), at: 0)
                            removeAtDismiss = false
                        }
                        saveFavData()
                        favoritedIcon.toggle()
                    } label: {
                        Image(systemName: favoritedIcon ? "star.fill" : "star")
                    }
                })
            }) .edgesIgnoringSafeArea(.all)
    }
    private func saveFavData() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(favorites) {
            UserDefaults.standard.setValue(encodedData, forKey: "favorites")
        }
    }
    private func saveSearchData() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(pastSearches) {
            UserDefaults.standard.setValue(encodedData, forKey: "pastSearches")
        }
    }
    private func favoritesContainURL(_ url: URL) -> Bool {
        for i in favorites {
            if i.url == url { return true }
        }
        return false
    }
    private func removeFavoriteMatching(_ url: URL) {
        withAnimation {
            var favCopy = favorites
            for i in favCopy.indices {
                if favCopy[i].url == url {
                    favCopy.remove(at: i)
                    favorites = favCopy
                    break
                }
            }
            favorites = favCopy
        }
    }
}

struct WebsiteView_Previews: PreviewProvider {
    static var previews: some View {
        //WebsiteView(webURL: .constant(URL(string: "https://zoro.to/")!), fav: Favorite(title: "Test", url: URL(string: "https://zoro.to/")!), search: "", favoritedIcon: false, favorites: .constant([Favorite(title: "Test", url: URL(string: "https://zoro.to/")!)]))
        MainScreen()
            .preferredColorScheme(.dark)
    }
}
