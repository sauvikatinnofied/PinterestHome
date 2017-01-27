//
//  PinterestPost.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 26/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation

struct PinterestPost: JSONConvertible, JSONArrayConvertible {
    public static var itemsKey: String?

    
    var id: String
    var createdAt: Date?
    var width: Int
    var height: Int
    var color: String
    var likes: Int
    var likedByUser: Bool
    
    var user: User
    var currentUserCollection: [String]
    var urls: PostURLs
    var categories: [Category]
    var links: PostLinks
    
    
    public init?(jsonDictionary: JSONDictionary?) {
        
        guard let id = jsonDictionary?["id"] as? String,
        let createdAt = jsonDictionary?["created_at"] as? String,
        let width = jsonDictionary?["width"] as? Int,
        let height = jsonDictionary?["height"] as? Int,
        let color = jsonDictionary?["color"] as? String,
        let likes = jsonDictionary?["likes"] as? Int,
        let likedByUser = jsonDictionary?["liked_by_user"] as? Bool,
            
        let userDic = jsonDictionary?["user"] as? JSONDictionary,
        let user = User(jsonDictionary: userDic),
            
        let currentUserCollection = jsonDictionary?["current_user_collections"] as? [String],
            
        let urlsDic = jsonDictionary?["urls"] as? JSONDictionary,
        let urls = PostURLs(jsonDictionary: urlsDic),
            
        let categories = jsonDictionary?["categories"] as? [JSONDictionary],
            
        let linksDic = jsonDictionary?["links"] as? JSONDictionary,
        let links = PostLinks(jsonDictionary: linksDic) else {
                return nil
        }
        self.id = id
        self.createdAt = Date.date(from: createdAt, format: .DateTimeSec)
        self.width = width
        self.height = height
        self.color = color
        self.likes = likes
        self.likedByUser = likedByUser
        self.user = user
        self.currentUserCollection = currentUserCollection
        self.urls = urls
        self.categories = categories.flatMap({ (dic) -> Category? in
            return Category(jsonDictionary: dic)
        })
        self.links = links
    
    }
}

extension JSONConvertible {
    var jsonDictionary: JSONDictionary {
        return self.jsonDictionary
    }
}
struct CategoryLink : JSONConvertible {
    
    var selfLink: String
    var photos: String
    
    public init?(jsonDictionary: JSONDictionary?) {
        guard let selfLink = jsonDictionary?["self"] as? String,
        selfLink.isHttpURL,
        let photos = jsonDictionary?["photos"] as? String,
        photos.isHttpURL else {
            return nil
        }
        
        self.selfLink = selfLink
        self.photos = photos
    }
}

struct Category : JSONConvertible {
    
    var id: Int
    var title: String
    var photoCount: Int
    var links: CategoryLink?
    
    public init?(jsonDictionary: JSONDictionary?) {
        guard let id = jsonDictionary?["id"] as? Int,
        let title = jsonDictionary?["title"] as? String,
        let photoCount = jsonDictionary?["photo_count"] as? Int,
        let linksDic = jsonDictionary?["links"] as? JSONDictionary,
        let links = CategoryLink(jsonDictionary: linksDic) else {
                return nil
        }
        self.id = id
        self.title = title
        self.photoCount = photoCount
        self.links = links
        
    }
}
struct PostLinks : JSONConvertible {
    var selfLink: String
    var html: String
    var download: String
    
    public init?(jsonDictionary: JSONDictionary?) {
        guard let selfLink = jsonDictionary?["self"] as? String,
        let html = jsonDictionary?["html"] as? String,
        let download = jsonDictionary?["download"] as? String,
        selfLink.isHttpURL,
        html.isHttpURL,
        download.isHttpURL else {
            return nil
        }
        self.selfLink = selfLink
        self.html = html
        self.download = download
    }
}

struct PostURLs: JSONConvertible {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
    
    
    public init?(jsonDictionary: JSONDictionary?) {
        guard let raw = jsonDictionary?["raw"] as? String,
        let full = jsonDictionary?["full"] as? String,
        let regular = jsonDictionary?["regular"] as? String,
        let small = jsonDictionary?["small"] as? String,
        let thumb = jsonDictionary?["thumb"] as? String,
        raw.isHttpURL,
        full.isHttpURL,
        regular.isHttpURL,
        small.isHttpURL,
        thumb.isHttpURL else {
                return nil
        }
        self.raw = raw
        self.full = full
        self.regular = regular
        self.small = small
        self.thumb = thumb
    }
}

struct ProfileImage : JSONConvertible {

    var small: String
    var medium: String
    var large: String

    
    
    public init?(jsonDictionary: JSONDictionary?) {
        guard let small = jsonDictionary?["small"] as? String,
        let medium = jsonDictionary?["medium"] as? String,
        let large = jsonDictionary?["large"] as? String,
        small.isHttpURL,
        medium.isHttpURL,
        large.isHttpURL else {
                return nil
        }
        self.small = small
        self.medium = medium
        self.large = large
    }
}

struct ProfileLinks : JSONConvertible {
    
    var selfLink: String
    var html: String
    var photos: String
    var likes: String
    
    
    public init?(jsonDictionary: JSONDictionary?) {
        guard let selfLink = jsonDictionary?["self"] as? String,
        let html = jsonDictionary?["html"] as? String,
        let photos = jsonDictionary?["photos"] as? String,
        let likes = jsonDictionary?["likes"] as? String,
        selfLink.isHttpURL,
        html.isHttpURL,
        photos.isHttpURL,
        likes.isHttpURL else{
            return nil
        }
        self.selfLink = selfLink
        self.html = html
        self.photos = photos
        self.likes = likes
    }
}

struct User: JSONConvertible  {
    
    var id: String
    var userName: String
    var name: String
    var profileImage: ProfileImage
    var profileLinks: ProfileLinks
    
    
    
    public init?(jsonDictionary: JSONDictionary?) {
        guard let id = jsonDictionary?["id"] as? String,
        let username = jsonDictionary?["username"] as? String,
        let name = jsonDictionary?["name"] as? String,
        let profileImagesDic = jsonDictionary?["profile_image"] as? JSONDictionary,
        let linksDic = jsonDictionary?["links"] as? JSONDictionary,
        let profileImage = ProfileImage(jsonDictionary: profileImagesDic),
        let profileLinks = ProfileLinks(jsonDictionary: linksDic) else {
                return nil
        }
        self.id = id
        self.userName = username
        self.name = name
        self.profileImage = profileImage
        self.profileLinks = profileLinks
    }
}

extension String {
    var isHttpURL: Bool {
        return self.hasPrefix("http://") || self.hasPrefix("https://")
    }
}
