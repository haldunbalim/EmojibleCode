//
//  Coordinator.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation

protocol Coordinator{
    var parentCoordinator: Coordinator? {get set}
    func start()
  
}
