//
//  SearchHandler.swift
//  FightClub
//
//  Created by Anagha Wadkar on 25/04/21.
//

import Foundation

struct SearchHandler {
    
    var searchString: String
    
    var searchStringTokens: [Substring] {
        /// Spliting search string into tokens
        return searchString.split(separator: " ")
    }
    
    /// Check if string matched the search string
    func matches(_ string: String) -> Bool {
        ///Match everything if there are no search string tokens
        guard !searchStringTokens.isEmpty else { return true }
        
        /// Spliting string into tokens
        let stringTokens = string.split(separator: " ")
        
        for searchToken in searchStringTokens {
            var matched = false
            for stringToken in stringTokens {
                if let range = stringToken.range(of: searchToken, options: [.caseInsensitive]),
                   range.lowerBound == stringToken.startIndex
                {
                    matched = true
                    break
                }
            }
            
            /// Return false if a search token didn't match to any of the string tokens
            if matched == false {
                return false
            }
        }
        /// Return false if all search tokens matched to any of the string tokens
        return true
    }
}
