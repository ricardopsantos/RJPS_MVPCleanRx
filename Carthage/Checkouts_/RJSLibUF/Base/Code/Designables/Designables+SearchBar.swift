//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public extension RJSLib.Designables {
    
    class SearchBar: UISearchBar, UISearchBarDelegate {
        
        weak var searchDelegate: UISearchBarDelegate?
        
        override public func layoutSubviews() {
            super.layoutSubviews()
            setShowsCancelButton(false, animated: false)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            delegate = self
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
            delegate = self
        }
        
        public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            if searchDelegate?.searchBarTextDidBeginEditing != nil {
                searchDelegate?.searchBarTextDidBeginEditing!(searchBar)
            }
            searchBar.setShowsCancelButton(true, animated: true)
        }
        
        public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            if searchDelegate?.searchBarCancelButtonClicked != nil {
                searchDelegate?.searchBarCancelButtonClicked!(searchBar)
            }
            searchBar.setShowsCancelButton(false, animated: true)
            searchBar.resignFirstResponder()
        }
        
        public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            if searchDelegate?.searchBarSearchButtonClicked != nil {
                searchDelegate?.searchBarSearchButtonClicked!(searchBar)
            }
            searchBar.setShowsCancelButton(false, animated: true)
            searchBar.resignFirstResponder()
        }
        
        public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if let textDidChange: (UISearchBar, String) -> Void = searchDelegate?.searchBar {
                textDidChange(searchBar, searchText)
            }
        }
    }
}
