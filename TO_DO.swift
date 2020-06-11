// swiftlint:disable all

#warning("Add rxKeyboard")
#warning("Finish TitleTableSectionView")
#warning("add deeplink support")
#warning("Add permissions support with rx")
#warning("add SQL e paginagion")

/*

 VALIDATE UNUSED CODE

 - - - - 1 - - - -

 ./unused.rb
 ./unused.rb | grep let
 ./unused.rb | grep var
 ./unused.rb | grep func
 ./unused.rb | grep struct
 ./unused.rb | grep class
 ./unused.rb | grep protocol
 ./unused.rb | grep enum
 
 - - - - 2 - - - -

periphery scan \
--project "/Users/ricardosantos/Desktop/GitHub/RJPS_MVPCleanRx/GoodToGo.xcodeproj/" \
--schemes "AppConstants","AppResources","AppTheme","Core","Core.Bliss","Core.CarTrack","Core.GitHub","Designables","DevTools","Domain","Domain.Bliss","Domain.CarTrack","Domain.GitHub","Extensions","Factory","GoodToGo.Debug.Dev","GoodToGo.Debug.Prod","GoodToGo.Release","PointFreeFunctions","Repositories","Repositories.WebAPI" \
--targets "AppConstants","AppResources","AppTheme","Core","Core.Bliss","Core.CarTrack","Core.GitHub","Designables","DevTools","Domain","Domain.Bliss","Domain.CarTrack","Domain.GitHub","Extensions","Factory","GoodToGo","PointFreeFunctions","Repositories","Repositories.WebAPI","Test.GoodToGo","UIBase" \
--retain-public


 periphery scan \
 --project "/Users/ricardosantos/Desktop/GitHub/RJPS_MVPCleanRx/GoodToGo.xcodeproj/" \
--schemes "AppConstants","AppResources","AppTheme","Core","Core.Bliss","Core.CarTrack","Core.GitHub","Designables","DevTools","Domain","Domain.Bliss","Domain.CarTrack","Domain.GitHub","Extensions","Factory","GoodToGo.Debug.Dev","GoodToGo.Debug.Prod","GoodToGo.Release","PointFreeFunctions","Repositories","Repositories.WebAPI" \
 --targets "GoodToGo" \
 --retain-public

*/

/*

 private func setupRefreshControl() {
     refreshControl.rx.controlEvent(.valueChanged).subscribe { [interactor] _ in
         interactor?.fetchTableItems()
     }.disposed(by: disposeBag)

     tableView.refreshControl = refreshControl

     tableView.rx.contentOffset
         .asObservable()
         .filter { [weak self] _ -> Bool in
             guard let self = self else { return false }
             return self.tableView.isNearTheBottomEdge()
         }
         .subscribe(onNext: { [weak self] _ in
             self?.interactor.loadNextTimelinePage(forceReload: false)
         })
         .disposed(by: disposeBag)
 }
 */
