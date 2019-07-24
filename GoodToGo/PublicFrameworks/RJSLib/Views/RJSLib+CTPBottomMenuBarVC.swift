//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

/*
 * O protocolo herda classe, para que possa ser criada uma referencia weak no delegate
 * http://stackoverflow.com/questions/24066304/how-can-i-make-a-weak-protocol-reference-in-pure-swift-w-o-objc
 */

/*
protocol CTPBottomMenuBarVCProtocol : class {
    func getMenuOptions() -> [String]
    func getMenuIcons()   -> [String]
    func getMenuIDs()     -> [String]
    func btnFilterWasPressed( _ sender : UICollectionViewCell, indexPath: IndexPath, menuID: String )
}

extension CTPBottomMenuBarVC {
    
    // Largura da barrinha em baixo por cima do item selectionado
    static func smallBottomBar() -> Bool { return false }
    static func defaultFont() -> UIFont { return UIFont.systemFont(ofSize: 15) }
    static func bottomMenuBarColor() -> UIColor { return .red }
    static func appSecundaryColor() -> UIColor { return .blue }
    static func appDefaultColor() -> UIColor { return .orange }
    static func xDeviceMargin() -> CGFloat { return 22.0 }
    static func frameSizeHeight() -> CGFloat { return 60.0 }
}

enum CTPBottomMenuBarVCMode {
    case slidable
    case unSlidable
}

class CTPBottomMenuBarVC: UIViewController {
    
    deinit { }
    
    fileprivate static let _cellID             : String  = "Cell"
    fileprivate static let _cellTextWidthAddOn : CGFloat = 10.0
    fileprivate static let _cellIconWidthAddOn : CGFloat = 10.0
    fileprivate static let _cellTextLabelID    : Int     = 100
    fileprivate static let _cellImageViewID    : Int     = 200
    fileprivate static let _cellImageBgViewID  : Int     = 300

    fileprivate var _backgroundColor         : UIColor!
    fileprivate var _currentlySelectedBarBackgroundColor : UIColor!
    fileprivate var _filterBarHeight         : CGFloat!
    fileprivate var _textFont                : UIFont!
    fileprivate var _textColor               : UIColor!
    fileprivate var _btnFilterBarOffsetX     : CGFloat = 2.0 // Largura na barra de animacao
    
    fileprivate var _bottomMenuBar         : UICollectionView!
    fileprivate var _currentlySelectedBar  : UIView!
    
    // Control vars
    fileprivate var _currentBottomMenuID  : Int = 0
    fileprivate var _previousBottomMenuID : Int = -1

    // Delegate
    weak var delegate : CTPBottomMenuBarVCProtocol?
    var mode : CTPBottomMenuBarVCMode = .slidable

    func destroy() -> Void {
        self.delegate = nil
        //COMENT
        self.view.rjs.destroy()
        //_bottomMenuBar.rjsLib.destroy()
        _currentlySelectedBar.rjs.destroy()

    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (_bottomMenuBar == nil) {
            prepareLayout()
        }

        // Posiciona-se a celula anteriormente seleccionada
        self.view.layoutIfNeeded()
        let indexPath = IndexPath(row:self._currentBottomMenuID, section: 0 )
        _bottomMenuBar.scrollToItem(at: indexPath, at:.centeredHorizontally,  animated:false)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (_bottomMenuBar.numberOfItems(inSection: 0) > 0) {
            updateBarPosition(_currentBottomMenuID, animated:false)
        }
    }
    
    convenience init(backgroundColor  : UIColor,
                     currentlySelectedBarBackgroundColor : UIColor = .white,
                     filterBarHeight  : CGFloat = 2.0,
                     textFont         : UIFont  = CTPBottomMenuBarVC.defaultFont(),
                     textColor        : UIColor = .white) {
        self.init()
        self._backgroundColor                     = backgroundColor
        self._filterBarHeight                     = filterBarHeight
        self._currentlySelectedBarBackgroundColor = currentlySelectedBarBackgroundColor
        self._textFont                            = textFont
        self._textColor                           = textColor
    }
    
    func prepareLayout() {
        
        // Limpar tudo, just in case
        view.subviews.forEach({ $0.removeFromSuperview() })
        
        // Self FRAME
        let selfFrame : CGRect = self.view.frame
        
        // BOTTOM OPTIONS BAR
        let insetTop    : CGFloat = 0.0
        let insetLeft   : CGFloat = 0.0
        let insetBottom : CGFloat = 0.0
        let insetRight  : CGFloat = 0.0
        let flowLayout  : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset            = UIEdgeInsets(top: insetTop, left:insetLeft, bottom:insetBottom, right:insetRight )
        flowLayout.scrollDirection         = UICollectionView.ScrollDirection.horizontal
        flowLayout.minimumLineSpacing      = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        
        var menuBarFrame : CGRect = CGRect.zero
        menuBarFrame.origin.x     = 0.0
        menuBarFrame.origin.y     = 0.0
        //get width from main screen to avoid clipping
        menuBarFrame.size.width  = UIScreen.main.bounds.width
        menuBarFrame.size.height = selfFrame.size.height
        
        // Defining the BOTTOM OPTIONS BAR
        _bottomMenuBar = UICollectionView(frame: menuBarFrame, collectionViewLayout: flowLayout)
        _bottomMenuBar.delegate               = self
        _bottomMenuBar.dataSource             = self
        _bottomMenuBar.backgroundColor        = _backgroundColor
        _bottomMenuBar.alwaysBounceHorizontal = false
        _bottomMenuBar.alwaysBounceVertical   = false
        _bottomMenuBar.bounces                = false
        _bottomMenuBar.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CTPBottomMenuBarVC._cellID)
        view.addSubview(_bottomMenuBar)
        
        // Adiciona o OBJECTO na barra de baixo
        var btnFilterBarFrame : CGRect = .zero
        btnFilterBarFrame.size.width   = self.cellMaxSize().width - (_btnFilterBarOffsetX * 2.0)
        btnFilterBarFrame.size.height  = _filterBarHeight
        btnFilterBarFrame.origin.x     = _btnFilterBarOffsetX
        btnFilterBarFrame.origin.y     = 2.0
        if(CTPBottomMenuBarVC.smallBottomBar()){
            btnFilterBarFrame.size.width   = self.cellMaxSize().width - (_btnFilterBarOffsetX * 2.0 + 20)
            btnFilterBarFrame.origin.x     = _btnFilterBarOffsetX + 10
        }
        
        _currentlySelectedBar = UIView(frame:btnFilterBarFrame)
        _currentlySelectedBar.backgroundColor = _currentlySelectedBarBackgroundColor
        _bottomMenuBar.addSubview(_currentlySelectedBar)
    }
    
}


extension CTPBottomMenuBarVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: Auxiliar
    
    func selectRow(_ row:Int) -> Void {
        _bottomMenuBar.scrollToItem(at: IndexPath.init(row: row, section: 0), at:.centeredHorizontally,  animated:true)
    }
    
    func updateBtnFilterBarPosition(_ sender: UICollectionViewCell, selectedIndexPath:IndexPath, animated:Bool=true) {
        
        // Otimizacao do TAMANHO da barra
        let senderFrame       : CGRect = sender.frame
        var btnFilterBarFrame : CGRect = self._currentlySelectedBar.frame
        btnFilterBarFrame.origin.x     = senderFrame.origin.x + _btnFilterBarOffsetX
        
        let animationTime : TimeInterval = animated ? RJSLib.Constants.defaultAnimationsTime : 0.0
        
        if(CTPBottomMenuBarVC.smallBottomBar()){
            btnFilterBarFrame.size.width   = self.cellMaxSize().width - (_btnFilterBarOffsetX * 2.0 + 20)
            btnFilterBarFrame.origin.x     = senderFrame.origin.x + _btnFilterBarOffsetX + 10
        }
        
        if(animated) {
            //COMENT
//            sender.rjsLib.bumpAndPerformBlock { }
        }
        
        let centerSelectedCell: (UICollectionViewCell, IndexPath) -> Void = {
            let sender          = $0
            let /*indexPath*/ _ = $1
            let selfFrame : CGRect = self.view.frame

            let senderFrame           : CGRect  = sender.frame
            let currentContentOffsetX : CGFloat = self._bottomMenuBar.contentOffset.x
            let currentMaxVisibleX    : CGFloat = currentContentOffsetX + selfFrame.size.width
            let totalCellWidth        : CGFloat = self._bottomMenuBar.contentSize.width
            let middleScreenPosX      : CGFloat = currentContentOffsetX + ( selfFrame.size.width / 2.0 )
            let refMiddleScreenPosX   : CGFloat = middleScreenPosX - ( senderFrame.size.width / 2.0 )
            let isBiggerThan          : Bool    = senderFrame.origin.x > refMiddleScreenPosX
            let isSmallerThan         : Bool    = senderFrame.origin.x < refMiddleScreenPosX
            let refValue              : CGFloat = senderFrame.origin.x - refMiddleScreenPosX
            var newContentOffset      : CGFloat = currentContentOffsetX + refValue
            
            let newMaxVisibleX : CGFloat = currentMaxVisibleX + ( isBiggerThan || isSmallerThan ? refValue : 0.0 )
            let isOverloading  : Bool = newMaxVisibleX > totalCellWidth
            let isUnderloading : Bool = newContentOffset < 0.0
            if (isOverloading) {
                newContentOffset -= ( newMaxVisibleX - totalCellWidth )
            }
            else if (isUnderloading) {
                newContentOffset = 0.0
            }
            self._bottomMenuBar.contentOffset.x = newContentOffset
        }
        
        // Anima o trajeto da barra
        UIView.animate( withDuration: animationTime, animations: {
            self._currentlySelectedBar.frame = btnFilterBarFrame
            centerSelectedCell(sender, selectedIndexPath)
            }, completion: { (value: Bool) in
                UIView.animate( withDuration: animationTime, animations: {
                    self._currentlySelectedBar.alpha = 1.0
                    }, completion: { (value: Bool) in
                })
        })
    }
    
    func imageAtIndex(_ index:Int)->UIImage {
        guard getMenuIcons().count > index else { return UIImage() }
        let imageName = getMenuIcons()[index]
        if let image = UIImage(named:imageName) { return image }
        if(imageName != "") {
            ASSERT_TRUE(false, message: "Not predicted. Image not found [\(imageName)]")
        }
        return UIImage()
    }

    // MARK: UICollectionView Delegate
    
    func collectionView( _ collectionView: UICollectionView, numberOfItemsInSection section: Int ) -> Int {
        return getMenuOptions().count
    }
    
    func collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CTPBottomMenuBarVC._cellID, for: indexPath)
        cell.subviews.forEach({ $0.removeFromSuperview() })
        cell.backgroundColor = .clear
        let cellFrame : CGRect = cell.frame
        
        //
        // Cell Image
        //
        
        let hasImage  : Bool        = cell.viewWithTag(CTPBottomMenuBarVC._cellImageViewID) as? UIImageView != nil
        var cellImage : UIImageView = UIImageView(frame: CGRect.zero)

        // Frame da BACKGROUND VIEW
        var cellImageBgViewFrame : CGRect = CGRect.zero
        cellImageBgViewFrame.size = iconMaxSize()
        
        var cellImageBgView : UIView = UIView( frame: cellImageBgViewFrame )
        
        if (hasImage) {
            cellImage       = cell.viewWithTag(CTPBottomMenuBarVC._cellImageViewID) as! UIImageView
            cellImageBgView = cell.viewWithTag(CTPBottomMenuBarVC._cellImageBgViewID )! as UIView
        }
        else {
            // Atribui os IDs aos objectos
            cellImage.tag       = CTPBottomMenuBarVC._cellImageViewID
            cellImageBgView.tag = CTPBottomMenuBarVC._cellImageBgViewID
            cellImageBgView.addSubview(cellImage)
            cell.addSubview(cellImageBgView)
        }
        
        let iconImg         = imageAtIndex(indexPath.row)
        cellImage.image     = iconImg
        cellImage.tintColor = UIColor.white
        
        //
        // Cell Title
        //
        
        let hasTitle : Bool = cell.viewWithTag(CTPBottomMenuBarVC._cellTextLabelID) as? UILabel != nil
        
        var cellTitle : UILabel = UILabel(frame: .zero)
        if (hasTitle ) {
            cellTitle = cell.viewWithTag(CTPBottomMenuBarVC._cellTextLabelID) as! UILabel
        }
        else {
            cellTitle.textAlignment = .center
            cellTitle.tag           = CTPBottomMenuBarVC._cellTextLabelID
            cellTitle.font          = _textFont
            cellTitle.textColor     = _textColor
            cell.addSubview(cellTitle)
        }
        
        cellTitle.text = getMenuOptions()[indexPath.row]
        
        // Otimiza o TAMANHO da LABEL
        cellTitle.sizeToFit()
        
        //
        // Acerto da Posicao dos Elementos
        //
        
        // Acerta a POSICAO da LABEL
        var cellTitleFrame : CGRect = cellTitle.frame
        cellTitleFrame.size.width  += CTPBottomMenuBarVC._cellTextWidthAddOn
        cellTitleFrame.origin.x     = ( ( cellFrame.size.width / 2.0 ) - ( cellTitleFrame.size.width / 2.0))
        
        // Acerta o TAMANHO e a POSICAO X da IMAGEM
        var cellImageFrame : CGRect = cellImage.bounds
        cellImageFrame.size.width   = iconImg.size.width
        cellImageFrame.size.height  = iconImg.size.height
        cellImageFrame.origin.x     = ((cellImageBgViewFrame.size.width / 2.0 ) - ( cellImageFrame.size.width / 2.0))
        cellImageFrame.origin.y     = cellImageBgViewFrame.size.height - cellImageFrame.size.height

        // Acerta a POSICAO X da IMAGE BG VIEW
        cellImageBgViewFrame.origin.x = ( cellFrame.size.width / 2.0 ) - ( cellImageBgViewFrame.size.width / 2.0 )

        // Calcula o CENTRO dos dois objectos
        let spaceBetweenBothObjs : CGFloat = 4.0
        let offsetBothObjsY : CGFloat = ( ( cellFrame.size.height - ( cellTitleFrame.size.height + cellImageBgViewFrame.size.height ) - spaceBetweenBothObjs ) / 2.0 )

        // Calcula da nova posicao Y (LABEL)
        cellTitleFrame.origin.y = cellFrame.size.height - cellTitleFrame.size.height - offsetBothObjsY

        // Calcula a nova posicao Y (IMAGEM)
        cellImageBgViewFrame.origin.y = offsetBothObjsY

        // Atribui as novas frames
        cellTitle.frame       = cellTitleFrame
        cellImage.frame       = cellImageFrame
        cellImageBgView.frame = cellImageBgViewFrame
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row != self._currentBottomMenuID) {
            _previousBottomMenuID = _currentBottomMenuID
            _currentBottomMenuID  = indexPath.row
            let sender : UICollectionViewCell = _bottomMenuBar.cellForItem( at: indexPath )!
            let optionMenuID : String = ((getMenuIDs().count > 0) && (indexPath.row < getMenuIDs().count ) ? getMenuIDs()[indexPath.row] : "" )
            updateBtnFilterBarPosition(sender, selectedIndexPath: indexPath )
            delegate?.btnFilterWasPressed(sender , indexPath:indexPath, menuID: optionMenuID)
            
        }
    }
    
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cellMaxSize()
    }

    // MARK: Cell MAX Size and Max Width
    fileprivate func cellMaxSize() -> CGSize {
        
        // BOTTOM OPTIONS BAR
        let insetTop    : CGFloat = 0.0
        let insetBottom : CGFloat = 0.0
        let sizeH       : CGFloat = self.view.frame.size.height - (insetTop + insetBottom)
        var sizeW       : CGFloat = 0.0

        if(mode == .unSlidable) {
            //
            // Controlo NAO tem o swipe (mover na lateral DESLIGADO)
            //
            let numberOfOptions = CGFloat(getMenuOptions().count)
            sizeW               = UIScreen.main.bounds.width / numberOfOptions
        }
        else if(mode == .slidable) {
            //
            // Controlo tem o swipe (mover na lateral)
            //
            guard getMenuOptions().count > 0 else {
                ASSERT_TRUE(false, message: "Sem opcoes no Menu. Delegate está bem implementado? (funcão [getMenuIDs()] devolver valores)")
                return CGSize.zero
            }
            
            let selfFrame : CGRect = self.view.frame
            for index in 0...(getMenuOptions().count - 1) {
                
                // Cell IMAGE
                let iconImg     : UIImage = imageAtIndex(index)
                var iconImgSize : CGSize  = iconImg.size
                iconImgSize.width += CTPBottomMenuBarVC._cellIconWidthAddOn
                
                // Cell TITLE
                let cellTitle : UILabel = UILabel(frame: CGRect.zero)
                cellTitle.textAlignment = .center
                cellTitle.text          = getMenuOptions()[index]
                
                // Formata a LABEL
                cellTitle.font      = _textFont
                cellTitle.textColor = _textColor
                
                // Otimiza o TAMANHO da LABEL
                cellTitle.sizeToFit()
                
                // Acerta a POSICAO da LABEL
                var cellTitleFrame : CGRect = cellTitle.frame
                cellTitleFrame.size.width  += CTPBottomMenuBarVC._cellTextWidthAddOn
                cellTitle.frame             = cellTitleFrame
                
                let iconMaxWidth : CGFloat = ( iconImgSize.width > cellTitleFrame.size.width ? iconImgSize.width : cellTitleFrame.size.width )
                
                sizeW = sizeW < iconMaxWidth ? iconMaxWidth : sizeW
                
                let regularCellSize : CGFloat = sizeW * CGFloat(getMenuOptions().count )
                
                sizeW = regularCellSize < selfFrame.size.width ? selfFrame.size.width / CGFloat(getMenuOptions().count ) : sizeW
            }
        }
        else {
            ASSERT_TRUE(false, message:"Not predicted")
        }
        
        _btnFilterBarOffsetX = sizeW * 0.25
        return CGSize(width: sizeW, height: sizeH)

    }
    
    // MARK: Icon MAX Size, Max Width and Max Height
    fileprivate func iconMaxSize() -> CGSize {

        // Valores iniciais
        var iconMaxWidth  : CGFloat = 0.0
        var iconMaxHeight : CGFloat = 0.0

        for index in 0...(getMenuOptions().count - 1 ) {
            // Cell IMAGE
            let iconImg: UIImage     = imageAtIndex(index)
            let iconImgSize: CGSize  = iconImg.size
            // Atualiza os valores maximos
            iconMaxWidth  = iconMaxWidth  < iconImgSize.width  ? iconImgSize.width  : iconMaxWidth
            iconMaxHeight = iconMaxHeight < iconImgSize.height ? iconImgSize.height : iconMaxHeight
        }

        return CGSize(width: iconMaxWidth, height: iconMaxHeight)
    }
}

// MARK: Public Actions

extension CTPBottomMenuBarVC {
    
    static func loadInView(_ blankIntance:CTPBottomMenuBarVC?, containerView:UIView, sender:UIViewController, mode:CTPBottomMenuBarVCMode = .slidable) -> CTPBottomMenuBarVC? {
        
        ASSERT_TRUE(containerView.frame.size.height==frameSizeHeight(), message: "Dimensoes do container nao são as ideais \(containerView)")
        
        var ctpBottomMenuBarVC = blankIntance
    
        var backgroundColor                     : UIColor = .white
        var currentlySelectedBarBackgroundColor : UIColor = .white
        var textColor                           : UIColor = .white
        let filterBarHeight                     : CGFloat = 2.0
        backgroundColor                     = bottomMenuBarColor()
        currentlySelectedBarBackgroundColor = .white
        textColor                           = .white

        ctpBottomMenuBarVC = CTPBottomMenuBarVC(backgroundColor: backgroundColor,
                                                currentlySelectedBarBackgroundColor: currentlySelectedBarBackgroundColor,
                                                filterBarHeight: filterBarHeight,
                                                textColor:textColor)
        
        guard ctpBottomMenuBarVC != nil else { return nil }

        ctpBottomMenuBarVC!.delegate = (sender as! CTPBottomMenuBarVCProtocol)
        
        sender.addChild(ctpBottomMenuBarVC!)
        containerView.addSubview(ctpBottomMenuBarVC!.view)
        if(true) {
            ctpBottomMenuBarVC!.view.frame = containerView.bounds
        }
        else {
            ctpBottomMenuBarVC!.view.rjsALayouts.setMargin(0, on: .top)
            ctpBottomMenuBarVC!.view.rjsALayouts.setMargin(0, on: .bottom)
            ctpBottomMenuBarVC!.view.rjsALayouts.setMargin(0, on: .left)
            ctpBottomMenuBarVC!.view.rjsALayouts.setMargin(0, on: .right)
        }
        ctpBottomMenuBarVC!.didMove(toParent: sender)
        sender.view.bringSubviewToFront(ctpBottomMenuBarVC!.view)
        return ctpBottomMenuBarVC
    }

    func setBackgroundColor(_ color:UIColor, animated:Bool=false, duration:TimeInterval=RJSLib.Constants.defaultAnimationsTime) {
        guard _bottomMenuBar != nil else { return }
        _backgroundColor = color
        if(animated) {
            UIView.animate(withDuration: duration, animations: {
                self._bottomMenuBar.backgroundColor = color
            })
        }
        else {
            _bottomMenuBar.backgroundColor = _backgroundColor
        }
    }

    // Atualiza a BARRA DE FUNDO, que assinala a celula seleccionada
    func updateBarPosition(_ newIndex:Int, animated:Bool=true, useSenderBump:Bool=true ) {
        _previousBottomMenuID = _currentBottomMenuID
        _currentBottomMenuID  = newIndex
        let indexPath : IndexPath = IndexPath(row:newIndex, section:0)
        self.view.layoutIfNeeded()
        if(_bottomMenuBar != nil) {
            _bottomMenuBar.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false )
        }
        if let senderCell = _bottomMenuBar.cellForItem(at: indexPath) {
            updateBtnFilterBarPosition(senderCell, selectedIndexPath:indexPath, animated:animated)
        }
    }

}

extension CTPBottomMenuBarVC {
    
    func getMenuIDs() -> [String] {
        guard delegate != nil else { return [] }
        return delegate!.getMenuIDs()
    }
    
    func getMenuOptions() -> [String] {
        guard delegate != nil else { return [] }
        return delegate!.getMenuOptions()
    }
    
    func getMenuIcons()-> [String]  {
        guard delegate != nil else { return [] }
        return delegate!.getMenuIcons()
    }
}

*/
