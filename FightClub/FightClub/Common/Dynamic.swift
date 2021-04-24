//
//  Dynamic.swift
//  FightClub
//
//  Created by Anagha Wadkar on 24/04/21.
//

import Foundation

/// Binding of viewModel and view properties
final class Dynamic<T> {
    
  var listener: ((T) -> Void)?
    
  var value: T {
    didSet {
      listener?(value)
    }
  }
    
  init(_ value: T) {
    self.value = value
  }
  
  func bind(listener: ((T) -> Void)?) {
    self.listener = listener
    listener?(value)
  }
}

