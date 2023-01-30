//
//  LogBookViewModel.swift
//  Nano2-Nimbl
//
//  Created by Anselmus Pavel Adriska on 04/01/23.
//

import Foundation
import CoreData
import Combine

class LogBookViewModel: ObservableObject {
    var context = CoreDataManager.shared.container.viewContext
    
    @Published var logBooks: [LogBookEntity] = []
    @Published var selectedLogBook: LogBook = LogBook(date: Date(), desc: "")
    @Published var selectedDate: Date = Date()
    @Published var todayLogBook: LogBook = LogBook(date: Date(), desc: "")
    
    @Published var debouncedDesc: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchLogBook()
        self.selectedLogBook = getLogBookForSelectedDate(date: self.selectedDate)
        setTodayLogBook()
        setupDebounce()
    }
        
    private func setupDebounce() {
        debouncedDesc = selectedLogBook.desc
        
        let publisher = $selectedLogBook.map { ($0.desc) }
        publisher.debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] str in
                self?.debouncedDesc = str
            })
            .store(in: &cancellables)
    }
    
    public func fetchLogBook() {
        let request = NSFetchRequest<LogBookEntity>(entityName: "LogBookEntity")
        
        do {
            logBooks = try context.fetch(request)
        } catch let error {
            print("Error fetching Log Books. \(error.localizedDescription)")
        }
    }
    
    public func addLogBook(_ newItem: LogBook) {
        let newLogBook = LogBookEntity(context: context)
        newLogBook.id = newItem.id
        newLogBook.date = newItem.date
        newLogBook.desc = newItem.desc
        
        logBooks.append(newLogBook)
        
        CoreDataManager.shared.save()
        fetchLogBook()
    }
    
    public func updateLogBook() {
        let index = logBooks.firstIndex { $0.date == selectedLogBook.date }
        if let foundIndex = index {
            logBooks[foundIndex].desc = selectedLogBook.desc
        } else {
            if selectedLogBook.desc != "" {
                addLogBook(selectedLogBook)
            }
        }
        
        CoreDataManager.shared.save()
        fetchLogBook()
    }
    
    public func getLogBookForSelectedDate(date: Date) -> LogBook {
        let logBook = logBooks.filter { lb in
            NSCalendar.current.isDate(date, inSameDayAs: lb.date ?? Date.now)
        }.first
        
        if let lb = logBook {
            return LogBook(id: lb.id ?? UUID(), date: lb.date ?? date, desc: lb.desc ?? "")
        } else {
            return LogBook(date: date, desc: "")
        }
    }
    
    public func setLogBookForSelectedDate() {
        selectedLogBook = getLogBookForSelectedDate(date: selectedDate)
    }
    
    public func setTodayLogBook() {
        guard let logbook = logBooks.first(where: { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: Date()) }) else { return }
        
        todayLogBook = LogBook(id: logbook.id ?? UUID(), date: logbook.date ?? Date(), desc: logbook.desc ?? "")
    }
    
    //    Old method #1
    //    private func setupDebounce() {
    //        debouncedDesc = selectedLogBook.desc
    //
    //        let publisher = $selectedLogBook.map { ($0.desc) }
    //        publisher.debounce(for: .seconds(2), scheduler: RunLoop.main)
    //            .assign(to: &$debouncedDesc)
    //    }
        
    //    Old method #2
    //    private func setupDebounce() {
    //        debouncedDesc = selectedLogBook.desc
    //
    //        let publisher = $selectedLogBook.map { ($0.desc) }
    //        publisher.debounce(for: .seconds(2), scheduler: RunLoop.main)
    //            .sink { (value) in
    //                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
    //                    DispatchQueue.main.async {
    //                        self?.debouncedDesc = value
    //                    }
    //                }
    //            }
    //            .store(in: &cancellable)
    //    }
}
