//
//  HomeVCSUI.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 02/12/22.
//

import SwiftUI

struct HomeVCSUI: View {
    @State private var indexPath = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                VStack {
                    Picker(selection: $indexPath, label: Text("MovieType")) {
                        ForEach(Array(Constants.MovieType.allCases.enumerated()), id: \.element) { index, element in
                            Text(element.title).tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    let movieType = Constants.MovieType.allCases[indexPath]
                    switch movieType {
                    case .popular:
                        DynamicScreenVCRepresentable(movieType: movieType)
                        
                    case .upcoming:
                        DynamicScreenVCRepresentable(movieType: movieType)
                        
                    case .topRated:
                        DynamicScreenVCRepresentable(movieType: movieType)
                        
                    case .nowPlaying:
                        DynamicScreenVCRepresentable(movieType: movieType)
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear{
            UINavigationBar.appearance().backgroundColor = .green
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Home", displayMode: .inline)
        .navigationViewStyle(.stack)
        .statusBar(hidden: false)
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
        //.padding()
        //.padding(.bottom, -10)
        //.edgesIgnoringSafeArea(.all)
        //.background(Color("Color.Background"))
        //.background(Color.black).edgesIgnoringSafeArea(.all)
        //.padding(.init(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
        
    }
}


#if DEBUG
struct HomeVCSUI_Previews: PreviewProvider {
    static var previews: some View {
        HomeVCSUI()
    }
}
#endif
