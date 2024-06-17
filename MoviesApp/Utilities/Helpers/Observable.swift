//
//  Observable.swift
//  MoviesApp
//
//  Created by J. R. on 13/06/24.
//

import Foundation

public class Observable<T> {
    
    typealias Listener = (T) -> Void
    
    // MARK: - Propertiers
    
    var observe: Listener = { _ in }
        
    private(set) var property: T? {
        didSet {
            if let property = property {
                thread.async {
                    self.observe(property)
                    self.notifyObservers(property)
                }
            }
        }
    }
    
    private let thread: DispatchQueue
    private var observers: [Observer] = []
    
    // MARK: - Initializers
    
    init(_ value: T? = nil, thread dispatcherThread: DispatchQueue = .main) {
        self.thread = dispatcherThread
        self.property = value
    }
    
    // MARK: - Methods
    
    func observe(_ listener: @escaping Listener) {
        observe = listener
    }
    
    fileprivate func postValue(_ value: T?) {
        property = value
    }
    
}

// MARK: - Observable+Bind
extension Observable {
    
    // MARK: - Properties
    
    public typealias Observer = (_ observable: Observable<T>, T) -> Void
    
    // MARK: -  Methods
    
    public func bind(observer: @escaping Observer) {
        observers.append(observer)
    }
    
    private func notifyObservers(_ value: T) {
        self.observers.forEach { [unowned self](observer) in
            observer(self, value)
        }
    }
    
}

public class MutableObservable<T>: Observable<T> {
    
    // MARK: - Override Methods
    
    override func postValue(_ value: T?) {
        super.postValue(value)
    }
    
}

