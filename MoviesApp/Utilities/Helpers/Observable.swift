//
//  Observable.swift
//  MoviesApp
//
//  Created by Lesly Higuera on 13/06/24.
//

import Foundation

public class Observable<T> {
    
    typealias Listener = (T) -> Void
    
    // MARK: - Internal Propertiers
    
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
    
    // MARK: - Private Propertiers
    
    private let thread : DispatchQueue
    private var observers: [Observer] = []
    
    // MARK: - Initializers
    
    init(_ value: T? = nil, thread dispatcherThread: DispatchQueue = .main) {
        self.thread = dispatcherThread
        self.property = value
    }
    
    // MARK: - Internal Methods
    
    func observe(_ listener: @escaping Listener) {
        observe = listener
    }
    
    // MARK: - Fileprivaye Methods
    
    fileprivate func postValue(_ value: T?) {
        property = value
    }
    
}

// MARK: - Observable+Bind
extension Observable {
    
    // MARK: - Public Properties
    
    public typealias Observer = (_ observable: Observable<T>, T) -> Void
    
    // MARK: - Public Methods
    
    public func bind(observer: @escaping Observer) {
        observers.append(observer)
    }
    
    // MARK: - Private Methods
    
    private func notifyObservers(_ value: T) {
        self.observers.forEach { [unowned self](observer) in
            observer(self, value)
        }
    }
    
}

public class MutableObservable<T>: Observable<T> {
    
    // MARK: - Internal Override Methods
    
    override func postValue(_ value: T?) {
        super.postValue(value)
    }
    
}

