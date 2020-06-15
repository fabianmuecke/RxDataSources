//
//  SectionModelType.swift
//  RxDataSources
//
//  Created by Krunoslav Zaher on 6/28/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation

public protocol SectionModelType {
    associatedtype Item

    var items: [Item] { get }

    init(original: Self, items: [Item])
}

extension Array: SectionModelType {
    public typealias Item = Element
    public var items: [Item] { self }
    
    public init(original: Self, items: [Item]) {
        self.init(items)
    }
}
