//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

extension RJSLib {
    
    public class SearchBar : UISearchBar, UISearchBarDelegate {
    
        weak var searchDelegate: UISearchBarDelegate?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            delegate = self
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
            delegate = self
        }
        
        private func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            if (searchDelegate?.searchBarTextDidBeginEditing != nil) {
                searchDelegate?.searchBarTextDidBeginEditing!(searchBar)
            }
            searchBar.setShowsCancelButton(true, animated: true)
        }
        
        private func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            if (searchDelegate?.searchBarCancelButtonClicked != nil) {
                searchDelegate?.searchBarCancelButtonClicked!(searchBar)
            }
            searchBar.setShowsCancelButton(false, animated: true)
            searchBar.resignFirstResponder()
        }
        
        private func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            if (searchDelegate?.searchBarSearchButtonClicked != nil) {
                searchDelegate?.searchBarSearchButtonClicked!(searchBar)
            }
            searchBar.setShowsCancelButton(false, animated: true)
            searchBar.resignFirstResponder()
        }
        
        private func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if let textDidChange: (UISearchBar, String) -> Void = searchDelegate?.searchBar {
                textDidChange(searchBar, searchText)
            }
        }
        
    }
    


}

