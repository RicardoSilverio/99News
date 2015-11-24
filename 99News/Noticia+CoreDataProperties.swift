//
//  Noticia+CoreDataProperties.swift
//  99News
//
//  Created by Ricardo Silverio de Souza on 24/11/15.
//  Copyright © 2015 7MOB. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Noticia {

    @NSManaged var titulo: String?
    @NSManaged var url: String?
    @NSManaged var conteudo: String?
    @NSManaged var dataPublicacao: NSDate?

}
