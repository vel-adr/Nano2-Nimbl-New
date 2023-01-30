//
//  ReflectionViewModel.swift
//  Nano2-Nimbl
//
//  Created by Anselmus Pavel Adriska on 07/01/23.
//

import SwiftUI
import CoreData
import Combine

class ReflectionViewModel: ObservableObject {
    var context = CoreDataManager.shared.container.viewContext
    
    @Published var reflections: [ReflectionEntity] = []
    @Published var selectedReflection: Reflection = Reflection(title: "", desc: "", updateTime: Date())
    
    @Published var debouncedTitle = ""
    @Published var debouncedDesc = ""
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchReflection()
        setupDebounce()
    }
    
    private func setupDebounce() {
        debouncedDesc = selectedReflection.desc
        debouncedTitle = selectedReflection.title
        
        let descPublisher = $selectedReflection.map { ($0.desc) }
        descPublisher.debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] str in
                self?.debouncedDesc = str
            })
            .store(in: &cancellables)
        
        let titlePublisher = $selectedReflection.map { ($0.title) }
        titlePublisher.debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] str in
                self?.debouncedTitle = str
            })
            .store(in: &cancellables)
    }
    
    public func fetchReflection() {
        let request = NSFetchRequest<ReflectionEntity>(entityName: "ReflectionEntity")
        let dateSort = NSSortDescriptor(key: "updateTime", ascending: false)
        request.sortDescriptors = [dateSort]
        
        do {
            reflections = try context.fetch(request)
        } catch let error {
            print("Error fetching Reflections. \(error.localizedDescription)")
        }
    }
    
    public func addReflection(_ newItem: Reflection) {
        let newReflection = ReflectionEntity(context: context)
        newReflection.id = newItem.id
        newReflection.title = newItem.title
        newReflection.desc = newItem.desc
        newReflection.updateTime = Date()
        
        reflections.append(newReflection)
        CoreDataManager.shared.save()
    }
    
    public func updateReflection() {
        let index = reflections.firstIndex { $0.id == selectedReflection.id }
        if let foundIndex = index {
            reflections[foundIndex].title = selectedReflection.title
            reflections[foundIndex].desc = selectedReflection.desc
            reflections[foundIndex].updateTime = Date()
        } else {
            if !selectedReflection.title.isEmpty || !selectedReflection.desc.isEmpty {
                addReflection(selectedReflection)
            }
        }
        
        CoreDataManager.shared.save()
        fetchReflection()
    }
    
    public func delete(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = reflections[index]
        
        CoreDataManager.shared.delete(object: entity)
        CoreDataManager.shared.save()
        fetchReflection()
    }
    
    public func setSelectedReflection(as reflection: Reflection) {
        selectedReflection = reflection
    }
    
    public func getTodayReflectionCount() -> Int {
        let arr = reflections.filter { r in
            Calendar.current.isDateInToday(r.updateTime ?? Date())
        }
        
        return arr.count
    }
    
    public func getRecentReflections() -> [Reflection] {
        let entityArr = reflections.prefix(3)
        let reflectionArr = entityArr.map { el in
            Reflection(id: el.id ?? UUID(), title: el.title ?? "", desc: el.desc ?? "", updateTime: el.updateTime ?? Date())
        }
        return reflectionArr
    }
}
