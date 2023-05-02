//
//  PastSearchesView.swift
//  Gojo
//
//  Created by Luke Drushell on 4/27/23.
//

import SwiftUI

struct PastSearchesView: View {
    
    @Binding var favorites: [Favorite]
    @Binding var pastSearches: [Favorite]
    
    var body: some View {
        SectionTitle(title: "Past Searches")
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach($pastSearches, content: { $past in
                    NavigationLink(destination: {
                        WebsiteView(webURL: .constant(past.url), search: past.title, favoritedIcon: false, favorites: $favorites, pastSearches: $pastSearches)
                    }, label: {
                        HStack {
                            Text(past.title)
                                .foregroundColor(.white)
                                .font(.system(.title3, design: .rounded, weight: .bold))
                                .padding(15)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .padding(.trailing)
                        }
                        .frame(width: UIScreen.width * 0.95, height: UIScreen.width * 0.125)
                        .background(
                            Color.black.opacity(0.2)
                        )
                        .cornerRadius(15)
                    })
                })
            } .padding(.horizontal)
        } .shadow(color: .black.opacity(0.5), radius: 2, x: 3, y: 3)
            .padding(.horizontal, 5)
    }
}

struct PastSearchesView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
