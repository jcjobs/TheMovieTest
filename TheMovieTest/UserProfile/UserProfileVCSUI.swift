//
//  UserProfileVCSUI.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 26/11/22.
//

import SwiftUI
import Kingfisher
import Combine
import CoreComponents

struct UserProfileVCSUI: View {
    private var viewModel: UserProfileVMProtocol
    
    @State private var isLoading = true
    @State private var error: ErrorInfo?
    @State private var urlImage: URL? = nil
    @State private var image: UIImage = UIImage()
    @State private var userFullName: String = ""
    
    @ObservedObject var imageLoader = ImageLoaderService()
    
    init(with viewModel: UserProfileVMProtocol) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        let navigation =
            VStack {
                ActivityIndicator(isAnimating: isLoading) {
                    $0.color = .green
                    $0.hidesWhenStopped = true
                }
                
                if #available(iOS 14.0, *) {
                    KFImage(urlImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipped()
                } else {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:100, height:100)
                        .onReceive(imageLoader.$image) { image in
                            self.image = image
                        }
                }
                
                Text(isLoading ? "Loading..." : userFullName)
                    .fontWeight(.semibold)
                    .font(.title)
                    .padding(.top, 40)
                
            }
            .padding()
            .alert(item: $error, content: { error in
                Alert(
                    title: Text(error.title),
                    message: Text(error.description),
                    dismissButton: .default(Text("Ok"), action: {
                        
                    })
                )
            })
            .onAppear {
                print("UserProfileVCSUI appeared!")
                viewModel.fetchProfileData()
            }
            .onDisappear {
                print("UserProfileVCSUI disappeared!")
            }
        
        return navigation
            .onReceive(viewModel.isLoading.receive(on: RunLoop.main)) { outPut in
                isLoading = outPut
            }
            .onReceive(viewModel.processError.receive(on: RunLoop.main)) { outPut in
                error = ErrorInfo(id: 3, title: "Error", description: outPut.localizedDescription)
            }
            .onReceive(viewModel.didFetchData.receive(on: RunLoop.main)) { _ in
                if let currentUser = Session.shared.user {
                    userFullName = currentUser.name
                    
                    let imageUrlString = CoreConstants.imageUrl + currentUser.avatar.tmdb.avatarPath
                    
                    if #available(iOS 14.0, *) {
                        urlImage = URL(string: imageUrlString)
                    } else {
                        imageLoader.loadImage(for: imageUrlString)
                    }
                }
            }
    }
}

struct UserProfileVCSUI_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel: UserProfileVMProtocol = UserProfileVM()
        UserProfileVCSUI(with: viewModel)
    }
}

class ImageLoaderService: ObservableObject {
    @Published var image: UIImage = UIImage(systemName: "person") ?? UIImage()
    private var cancellable: AnyCancellable?
    
    func loadImage(for urlString: String) {
        guard let url = URL(string: urlString) else { return }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .sink { value in
                self.image = value ?? UIImage()
            }
    }
}
