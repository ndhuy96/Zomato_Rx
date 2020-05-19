//
//  ErrorTracker.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/21/20.
//  Copyright © 2020 sun. All rights reserved.
//

final class ErrorTracker: SharedSequenceConvertibleType {
    typealias SharingStrategy = DriverSharingStrategy

    private let _subject = PublishSubject<Error>()

    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: onError)
    }

    func asSharedSequence() -> SharedSequence<DriverSharingStrategy, Error> {
        return _subject.asObservable().asDriverOnErrorJustComplete()
    }

    func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }

    private func onError(_ error: Error) {
        _subject.onNext(error)
    }

    deinit {
        _subject.onCompleted()
    }
}

extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}

extension ObservableType {
    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

extension Driver {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }

    /**
     Invokes an action for each event in the observable sequence,
     and propagates all observer messages through the result sequence.

     - parameter variable: Target variable for sequence elements.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func `do`(_ variable: Variable<E>) -> SharedSequence<SharingStrategy, E> {
        return `do`(onNext: { e in
            variable.value = e
        })
    }

    /**
     Invokes an action for each event in the observable sequence,
     and propagates all observer messages through the result sequence.

     - parameter variable: Target variable for sequence elements.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func `do`(_ variable: Variable<E?>) -> SharedSequence<SharingStrategy, E> {
        return `do`(onNext: { e in
            variable.value = e
        })
    }
}
