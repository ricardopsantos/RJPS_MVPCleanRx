//
//  I.GalleryAppS1Interactor.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 26/08/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RxCocoa
import RxSwift
import TinyConstraints
//
import AppConstants
import AppTheme
import Designables
import DevTools
import Domain
import Extensions
import PointFreeFunctions
import UIBase
import AppResources
import Factory
import Domain_GalleryApp

//
// Interactor will fetch the Domain objects, and return that response
// to the Presenter. The Presenter will parse then into ViewModel objects
//
// The interactor contains your app’s business logic. The user taps and swipes in your UI in
// order to interact with your app. The view controller collects the user inputs from the UI
// and passes it to the interactor. It then retrieves some models and asks some workers to do the work.
//

extension I {
    class GalleryAppS1Interactor: BaseInteractorVIP {

        deinit {
            DevTools.Log.logDeInit("\(GalleryAppS1Interactor.self) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        var presenter: GalleryAppS1PresentationLogicProtocol?
        weak var basePresenter: BasePresenterVIPProtocol? { return presenter }
        var worker = GalleryAppResolver.shared.worker
    }
}

// MARK: Interator Mandatory BusinessLogicProtocol

extension I.GalleryAppS1Interactor: BaseInteractorVIPMandatoryBusinessLogicProtocol {

    /// When the screen is loaded, this function is responsible to bind the View with some (temporary or final) data
    /// till the user have all the data loaded on the view. This will improve user experience.
    func requestScreenInitialState() {
        var response: VM.GalleryAppS1.ScreenInitialState.Response!
        response = VM.GalleryAppS1.ScreenInitialState.Response(title: "")
        presenter?.presentScreenInitialState(response: response)

        requestSearchByTag(request: VM.GalleryAppS1.SearchByTag.Request(tag: "cat", page: 1))
    }

}

// MARK: Private Stuff

extension I.GalleryAppS1Interactor {

}

// MARK: BusinessLogicProtocol

extension I.GalleryAppS1Interactor: GalleryAppS1BusinessLogicProtocol {

    func requestSearchByTag(request: VM.GalleryAppS1.SearchByTag.Request) {
        guard let presenter = presenter, worker != nil else {
            return
        }

        // Lets turn things like 'cat, Dog', 'cat   dog ', 'Cat ; dog' into ["cat", "dog"]
        var escaped = request.tag
        escaped = escaped.replacingOccurrences(of: " ", with: ",")
        escaped = escaped.replacingOccurrences(of: ";", with: ",")
        escaped = escaped.replacingOccurrences(of: "-", with: ",")

        let tags: [String] = escaped.components(separatedBy: ",").map({ $0.trim.lowercased() }).filter({ $0.count > 0 })

        presenter.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: true))
        let request = GalleryAppRequests.Search(tags: tags, page: request.page)
        worker!.search(request, cacheStrategy: .cacheElseLoad).asObservable()
            .subscribe(onNext: { [weak self] (result) in
            guard let self = self else { return }
            //switch result {
            //case .success(let some):
                let response = VM.GalleryAppS1.SearchByTag.Response(photos: result.photos.photo)
                self.presenter?.presentSearchByTag(response: response)
/*
                print("\(tags) returned \(some.photos.photo.count) records")
                some.photos.photo.forEach { (photo) in
                    print("Requesting info about: \(photo.id)")
                    //let request = GalleryAppRequests.ImageInfo(photoId: some.photos.photo.first!.id)
                    let request = GalleryAppRequests.ImageInfo(photoId: photo.id)
                    self.worker?.imageInfo2(request, cacheStrategy: .cacheElseLoad).asObservable().subscribe(onNext: { [weak self] (info, image) in
                        switch info {
                        case .success(let some): print(some)
                        case .failure(let error): print(error)
                        }
                        switch image {
                        case .success(let some):
                            print(some)
                        case .failure(let error): print(error)
                        }
                    }).disposed(by: self.disposeBag)
                }*/
           // case .failure(let error):
           //     self.presentError(error: error)
           // }
        }, onError: { (error) in
            DevTools.Log.error(error)
            self.presentError(error: error)
        }, onCompleted: {
            self.presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: false))
        }).disposed(by: disposeBag)

    }

}

// MARK: Utils {

extension I.GalleryAppS1Interactor {
    func presentError(error: Error) {
        let response = BaseDisplayLogicModels.Error(title: error.localisedMessageForView)
        basePresenter?.presentError(response: response)
    }
}
