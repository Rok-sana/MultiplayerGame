//
//  Area.swift
//  Intergalactic kindergarden
//
//  Created by Oksana Bolibok on 01.03.2020.
//  Copyright © 2020 Oksana Bolibok. All rights reserved.
//

import Foundation

class Area {
    private var children: Array2D<Child>
    
  
    init(columns: Int, rows: Int) {
     children = Array2D<Child>(columns: columns, rows: rows)
  }
  
  func getChild(atColumn column: Int, row: Int) -> Child? {
    precondition(column >= 0 && column < numColumns)
    precondition(row >= 0 && row < numRows)
    return children[column, row]
  }
  
  func shuffle() -> Set<Child> {
    return createInitialChild()
  }
  
  private func createInitialChild() -> Set<Child> {
    
    var set: Set<Child> = []
    for row in 0..<numRows{
        for column in 0..<numColumns {
       
          let childType = ChildType.random()
          let child = Child(column: column, row: row, type: childType)
          children[column, row] = child
          set.insert(child)
        
      }
    }
    return set
  }
}
