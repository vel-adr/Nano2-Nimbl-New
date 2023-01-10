//
//  ResourceViewModel.swift
//  Nano2-Nimbl
//
//  Created by Anselmus Pavel Adriska on 04/01/23.
//

import Foundation
import CoreData

class ResourceViewModel: ObservableObject {
    var context = CoreDataManager.shared.container.viewContext
    
    @Published var resources: [ResourceEntity] = []
    @Published var selectedResource: Resource = Resource(title: "", desc: "", updateTime: Date())
    
    init() {
        fetchResource()
    }
    
    public func fetchResource() {
        let request = NSFetchRequest<ResourceEntity>(entityName: "ResourceEntity")
        let dateSort = NSSortDescriptor(key: "updateTime", ascending: false)
        request.sortDescriptors = [dateSort]
        
        do {
            resources = try context.fetch(request)
        } catch let error {
            print("Error fetching Resources. \(error.localizedDescription)")
        }
    }
    
    public func addResource(_ newItem: Resource) {
        let newResource = ResourceEntity(context: context)
        newResource.id = newItem.id
        newResource.title = newItem.title
        newResource.desc = newItem.desc
        newResource.updateTime = Date()
        
        resources.append(newResource)
        CoreDataManager.shared.save()
    }
    
    public func updateResource() {
        let index = resources.firstIndex { $0.id == selectedResource.id }
        if let foundIndex = index {
            resources[foundIndex].title = selectedResource.title
            resources[foundIndex].desc = selectedResource.desc
            resources[foundIndex].updateTime = Date()
        } else {
            if !selectedResource.title.isEmpty || !selectedResource.desc.isEmpty {
                addResource(selectedResource)
            }
        }
        
        CoreDataManager.shared.save()
        fetchResource()
    }
    
    public func delete(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = resources[index]
        
        CoreDataManager.shared.delete(object: entity)
        CoreDataManager.shared.save()
        fetchResource()
    }
    
    public func setSelectedResource(as resource: Resource) {
        selectedResource = resource
    }
    
    public func getTodayResourceCount() -> Int {
        let arr = resources.filter { r in
            Calendar.current.isDateInToday(r.updateTime ?? Date())
        }
        
        return arr.count
    }
    
    public func getRecentResources() -> [Resource] {
        let entityArr = resources.prefix(3)
        let resourceArr = entityArr.map { el in
            Resource(id: el.id ?? UUID(), title: el.title ?? "", desc: el.desc ?? "", updateTime: el.updateTime ?? Date())
        }
        return resourceArr
    }
}
