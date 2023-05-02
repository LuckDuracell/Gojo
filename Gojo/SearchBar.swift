//
//  SearchBar.swift
//  Gojo
//
//  Created by Luke Drushell on 5/1/23.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var search: String
    @Binding var favorites: [Favorite]
    @Binding var pastSearches: [Favorite]
    
    @State var url = URL(string: "https://zoro.to")!
    
    var body: some View {
        HStack {
            TextField("Search", text: $search)
                .padding()
                .foregroundColor(.white)
                .font(.system(.headline, design: .rounded, weight: .black))
                .autocorrectionDisabled(true)
            NavigationLink(destination: {
                WebsiteView(webURL: $url, search: search, favoritedIcon: false, favorites: $favorites, pastSearches: $pastSearches)
                    .onAppear(perform: {
                        withAnimation {
                            url = search.zoroURL()
                        }
                    })
            }, label: {
                Image(systemName: "magnifyingglass")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 1, x: 2, y: 2)
                    .padding(.trailing, 25)
            })
        }
        .frame(width: UIScreen.width * 0.95, height: UIScreen.width * 0.13)
        .background(
            Color.black.opacity(0.2)
        )
        .cornerRadius(15)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
