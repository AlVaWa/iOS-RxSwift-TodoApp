//
//  Task.swift
//  RxSwift-TodoList
//
//  Created by Aleksander Waage on 03/07/2020.
//  Copyright © 2020 Waageweb. All rights reserved.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
