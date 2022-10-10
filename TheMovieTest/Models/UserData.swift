//
//  UserData.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 10/10/22.
//

import Foundation

struct UserData: Codable {
    let id: Int
    let name: String
    let username: String
    let avatar: Avatar
    
    struct Avatar: Codable {
        let tmdb: AvatarData
    }
    
    struct AvatarData: Codable {
        let avatarPath: String
        
        enum CodingKeys: String, CodingKey {
            case avatarPath = "avatar_path"
        }
    }
}
