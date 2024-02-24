//
//  Joke+CoreDataProperties.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 23/02/2024.
//
//

import Foundation
import CoreData


extension Joke {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Joke> {
        return NSFetchRequest<Joke>(entityName: "Joke")
    }

    @NSManaged public var category: String?
    @NSManaged public var delivery: String?
    @NSManaged public var error: Bool
    @NSManaged public var id: Int16
    @NSManaged public var joke: String?
    @NSManaged public var lang: String?
    @NSManaged public var safe: Bool
    @NSManaged public var setup: String?
    @NSManaged public var type: String?
    @NSManaged public var favorite: Bool
    @NSManaged public var dateSaved: Date?
    @NSManaged public var flags: Flag?

}

extension Joke : Identifiable {

}
