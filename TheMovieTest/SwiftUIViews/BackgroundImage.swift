//
//  BackgroundImage.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 02/12/22.
//

import SwiftUI

struct BackgroundImage : View {
    var body: some View {
        return Image("background-image")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
            .scaledToFill()
    }
}
