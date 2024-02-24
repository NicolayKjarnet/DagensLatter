//
//  Flag+CoreDataProperties.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 23/02/2024.
//
//

import Foundation
import CoreData


extension Flag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flag> {
        return NSFetchRequest<Flag>(entityName: "Flag")
    }

    @NSManaged public var explicit: Bool
    @NSManaged public var id: Int16
    @NSManaged public var nsfw: Bool
    @NSManaged public var political: Bool
    @NSManaged public var racist: Bool
    @NSManaged public var religious: Bool
    @NSManaged public var sexist: Bool
    @NSManaged public var jokes: Joke?

}

extension Flag : Identifiable {

}
