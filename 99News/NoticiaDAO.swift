//
//  NoticiaService.swift
//  99News
//
//  Created by Ricardo Silverio de Souza on 24/11/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit
import CoreData

class NoticiaDAO: NSObject {
    
    private let managedObjectContext:NSManagedObjectContext
    
    init(managedObjectContext:NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest(entityName: "Noticia")
        
        let sortDescriptor = NSSortDescriptor(key: "dataPublicacao", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func isNoticiaSalva(url: String) -> Bool {
        
        let fetchRequest = NSFetchRequest(entityName: "Noticia")
        
        let sortDescriptor = NSSortDescriptor(key: "dataPublicacao", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "url like '" + url + "'")
        fetchRequest.predicate = predicate
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            if(results.count > 0) {
                return true
            }
        } catch {
            //print("Erro ao pesquisar notícia no banco")
        }
        return false
    }

}
