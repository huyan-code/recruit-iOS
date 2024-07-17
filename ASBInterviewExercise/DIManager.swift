//
//  DIManager.swift
//  ASBInterviewExercise
//
//  Created by ASB on 29/07/21.
//

import Foundation
import Swinject

class DIManager {
    static let shared = DIManager()
    
    var assembler: Assembler
    
    init() {
        let assembler = Assembler([ServiceAssembly(), ViewModelAssembly()])
        self.assembler = assembler
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        return assembler.resolver.resolve(type)
    }
}

class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RestClient.self) { resolver in
            return RestClient()
        }.inObjectScope(.transient)
        
        // register TransactionService
        container.register(TransactionService.self) { resolver in
            let restClient = resolver.resolve(RestClient.self)!
            return TransactionService(restClient:restClient)
        }.inObjectScope(.transient)
    }
}

class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        // register TransactionTableViewModel
        container.register(TransactionTableViewModel.self) { resolver in
            let transactionService = resolver.resolve(TransactionService.self)!
            return TransactionTableViewModel(transactionService:transactionService)
        }.inObjectScope(.transient)
    }
}
