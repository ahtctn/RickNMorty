//
//  Constants.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//
import UIKit

enum Constants {
    static let baseURL: String = "https://rickandmortyapi.com/api"
    static let pathCharacters: String = "/character"
    static let pathEpisodes: String = "/episode"
    static let cellId: String = "CellId"
    //static let headerImageUrl: String = "https://www.freepnglogos.com/uploads/rick-and-morty-png/rick-and-morty-non-toxic-rick-sanchez-18.png"
    static let headerImageUrl: String = "file:///Users/ahmetalicetin/Desktop/rmheader%3F.png"
    
    enum HeaderAnimations {
        static let mortyTwerking: String = "mortyTwerking"
        static let mortyCrying: String = "mortyCrying"
        static let teleport: String = "teleport"
        static let rickNMortyHeaderAnimation: String = "rickNMortyHeaderAnimation"
    }
    
    enum Links {
        static let githubLink: String = "https://www.github.com/ahtctn"
        static let linkedinLink: String = "https://www.linkedin.com/in/ahtctn"
        static let twitterLink: String = "https://www.twitter.com/aliDevJourney"
        static let gmailLink: String = "ahtctn@gmail.com"
    }
}
