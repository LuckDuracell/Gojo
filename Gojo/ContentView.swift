////
////  ContentView.swift
////  Gojo
////
////  Created by Luke Drushell on 4/17/23.
////
//
//import SwiftUI
//import WebKit
//
//struct ContentView: View {
//    
//    @State var search: String = ""
//    @State var searchCopy: String = ""
//    @State private var showWebView = false
//    
//    @State var webURL = URL(string: "https://zoro.to/")!
//    
//    @State var showString = ""
//    
//    @State var favoritedIcon: Bool = false
//    @State var reloading: Bool = false
//    
//    private let userDefaultsKey = "pastSearches"
//    private let userDefaultsKey2 = "favorites"
//    @State var pastSearches: [PastSearch] = []
//    @State var favorites: [Favorite] = []
//    func updateSearch() {
//        removeSearchMatching()
//        pastSearches.insert(PastSearch(search: search, date: Date()), at: 0)
//        saveSearchData()
//        let allowedCharacterSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
//        let encodedString = search.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? ""
//        let urlString = "https://zoro.to/search?keyword=\(encodedString)"
//        showString = urlString
//        webURL = URL(string: urlString)!
//        withAnimation {
//            showWebView.toggle()
//            searchCopy = search
//            search = ""
//        }
//    }
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Color.blue
//                    .edgesIgnoringSafeArea(.all)
//                    .opacity(0.07)
//                ScrollView {
//                    VStack {
//                        Text("Gojo TV")
//                            .font(.system(.largeTitle, design: .rounded, weight: .black))
//                        HStack {
//                            TextField("Search", text: $search)
//                                .autocorrectionDisabled(true)
//                                .textInputAutocapitalization(.words)
//                                .padding(7)
//                                .background(.regularMaterial)
//                                .cornerRadius(5)
//                                .shadow(color: .purple.opacity(0.3), radius: 10)
//                                .padding()
//                            NavigationLink(destination: {
//                                WebsiteView(webURL: $webURL, search: search, favoritedIcon: $favoritedIcon, showWebView: $showWebView, favorites: $favorites)
//                                    .onAppear(perform: {
//                                        updateSearch()
//                                    })
//                                    .edgesIgnoringSafeArea(.all)
//                            }, label: {
//                                Image(systemName: "magnifyingglass")
//                            }) .padding(.trailing, 20)
//                        }
//                        Divider()
//                            .padding()
//                        if !favorites.isEmpty {
//                            HStack {
//                                Text("Your Favorites:")
//                                    .padding(.leading)
//                                    .foregroundColor(.gray)
//                                    .shadow(color: .purple.opacity(0.25), radius: 7)
//                                Spacer()
//                            }
//                            ScrollView(.horizontal) {
//                                HStack {
//                                    ForEach(favorites, id: \.self, content: { fav in
//                                        NavigationLink(destination: {
//                                            WebsiteView(webURL: $webURL, fav: fav, search: search, favoritedIcon: $favoritedIcon, showWebView: $showWebView, favorites: $favorites)
//                                            .edgesIgnoringSafeArea(.all)
//                                        }, label: {
//                                            ZStack {
//                                                Rectangle()
//                                                    .frame(width: 160, height: 120)
//                                                    .foregroundColor(.clear)
//                                                    .background(.regularMaterial)
//                                                    .cornerRadius(15)
//                                                    .shadow(color: .purple.opacity(0.25), radius: 7)
//                                                Text(fav.title)
//                                                    .frame(width: 110, height: 165)
//                                                    .foregroundColor(.gray)
//                                            }
//                                        })
//                                    }) .padding(.leading)
//                                }
//                            } .padding(.vertical, -10)
//                            Divider()
//                                .padding()
//                        }
//                        if !pastSearches.isEmpty {
//                            HStack {
//                                Text("Past Searches:")
//                                    .padding(.leading)
//                                    .foregroundColor(.gray)
//                                    .shadow(color: .purple.opacity(0.25), radius: 7)
//                                Spacer()
//                            }
//                            ForEach(pastSearches, id: \.self, content: { pastSearch in
//                                Button {
//                                    search = pastSearch.search
//                                } label: {
//                                    HStack {
//                                        Text(pastSearch.search)
//                                        Spacer()
//                                        Text(pastSearch.date, format: .dateTime)
//                                    } .padding()
//                                        .background(.regularMaterial)
//                                        .cornerRadius(5)
//                                        .shadow(color: .purple.opacity(0.2), radius: 5)
//                                        .foregroundColor(.gray)
//                                } .padding(.horizontal, 15)
//                            })
//                            Divider()
//                                .padding()
//                        }
//                    }
//                }
//            } .onAppear(perform: {
//                if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
//                    let decoder = JSONDecoder()
//                    if let decodedData = try? decoder.decode([PastSearch].self, from: data) {
//                        pastSearches = decodedData
//                    }
//                }
//                if let data = UserDefaults.standard.data(forKey: userDefaultsKey2) {
//                    let decoder = JSONDecoder()
//                    if let decodedData = try? decoder.decode([Favorite].self, from: data) {
//                        favorites = decodedData
//                    }
//                }
//            })
//            .toolbar(content: {
//                ToolbarItem(placement: .bottomBar, content: {
//                    if !pastSearches.isEmpty {
//                        Button {
//                            withAnimation {
//                                pastSearches = []
//                                saveSearchData()
//                            }
//                        } label: {
//                            Text("Clear Search History")
//                                .foregroundColor(.gray)
//                        }
//                    }
//                })
//                ToolbarItem(placement: .bottomBar, content: {
//                    if !favorites.isEmpty {
//                        Button {
//                            withAnimation {
//                                favorites = []
//                                saveFavData()
//                            }
//                        } label: {
//                            Text("Clear Favorites")
//                                .foregroundColor(.gray)
//                        }
//                    }
//                })
//            })
//        }
//    }
//    
//    private func saveSearchData() {
//        let encoder = JSONEncoder()
//        if let encodedData = try? encoder.encode(pastSearches) {
//            UserDefaults.standard.setValue(encodedData, forKey: userDefaultsKey)
//        }
//    }
//    private func saveFavData() {
//        let encoder = JSONEncoder()
//        if let encodedData = try? encoder.encode(favorites) {
//            UserDefaults.standard.setValue(encodedData, forKey: userDefaultsKey2)
//        }
//    }
//    private func favoritesContainURL(_ url: URL) -> Bool {
//        for i in favorites {
//            if i.url == url { return true }
//        }
//        return false
//    }
//    private func removeFavoriteMatching(_ url: URL) {
//        var favCopy = favorites
//        for i in favCopy.indices {
//            if favCopy[i].url == url {
//                favCopy.remove(at: i)
//                favorites = favCopy
//                break
//            }
//        }
//        favorites = favCopy
//    }
//    private func removeSearchMatching() {
//        var searchCopy = pastSearches
//        for i in searchCopy.indices {
//            if searchCopy[i].search == search {
//                searchCopy.remove(at: i)
//                pastSearches = searchCopy
//                break
//            }
//        }
//        pastSearches = searchCopy
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .preferredColorScheme(.dark)
//    }
//}
//
//extension Color {
//    static let antiPrimary = Color("antiPrimary")
//}
//
//struct PastSearch: Hashable, Identifiable, Codable {
//    let search: String
//    let date: Date
//    var id = UUID()
//}
//
