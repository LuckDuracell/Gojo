//
//  FavoritesView.swift
//  Gojo
//
//  Created by Luke Drushell on 4/27/23.
//

import SwiftUI

struct FavoritesView: View {
    
    @Binding var favorites: [Favorite]
    @Binding var pastSearches: [Favorite]
    
    var body: some View {
        SectionTitle(title: "Your Favorites")
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach($favorites, content: { $fav in
                    NavigationLink(destination: {
                        WebsiteView(webURL: $fav.url, fav: fav, search: "", favoritedIcon: false, favorites: $favorites, pastSearches: $pastSearches)
                    }, label: {
                        Text(fav.title)
                            .foregroundColor(.white)
                            .font(.system(.title3, design: .rounded, weight: .bold))
                            .padding(5)
                            .frame(width: UIScreen.width * 0.35, height: UIScreen.width * 0.4)
                            .multilineTextAlignment(.center)
                            .background(
                                Color.black.opacity(0.2)
                            )
                            .cornerRadius(25)
                    })
                })
            } .padding(.horizontal)
        } .shadow(color: .black.opacity(0.5), radius: 2, x: 3, y: 3)
            .padding(.horizontal, 5)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

struct Favorite: Hashable, Codable, Identifiable {
    let title: String
    var url: URL
    var id = UUID()
}

struct SectionTitle: View {
    
    let title: String
    
    var body: some View {
        HStack {
            Text(" " + title + ":")
                .foregroundColor(.white)
                .font(.system(.title3, design: .rounded, weight: .black))
                .shadow(color: .black.opacity(0.35), radius: 2, x: 2, y: 2)
            Spacer()
        } .padding(.leading)
    }
}
