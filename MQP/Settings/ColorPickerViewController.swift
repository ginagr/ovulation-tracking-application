
//
//  ColorPickerViewController.swift
//  SwiftColorPicker
//
//  Created by Prashant on 02/09/15.
//  Refractored by GGR on 12/21/17.
//  Copyright (c) 2015 PrashantKumar Mangukiya. All rights reserved.
//

import UIKit
import Foundation

protocol ColorPickerDelegate {
    func colorPickerDidColorSelected(selectedUIColor: UIColor, selectedHexColor: String)
}


class ColorPickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var colorPickerDelegate : ColorPickerDelegate?

    @IBOutlet var colorCollectionView : UICollectionView!

    var colorList = [String]() {
        didSet {
            self.colorCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.colorCollectionView.delegate = self
        self.colorCollectionView.dataSource = self

        self.loadColorList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        cell.backgroundColor = self.convertHexToUIColor(hexColor: self.colorList[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clickedHexColor = self.colorList[indexPath.row]
        let clickedUIColor = self.convertHexToUIColor(hexColor: clickedHexColor)
        self.colorPickerDelegate?.colorPickerDidColorSelected(selectedUIColor: clickedUIColor, selectedHexColor: clickedHexColor)
        self.closeColorPicker()
    }

    private func loadColorList(){
        let colorFilePath = Bundle.main.path(forResource: "Colors", ofType: "plist")
        let colorNSArray = NSArray(contentsOfFile: colorFilePath!)
        self.colorList = colorNSArray as! [String]
    }

    private func convertHexToUIColor(hexColor : String) -> UIColor {
        var colorString : String = hexColor.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        colorString = colorString.uppercased()

        if colorString.hasPrefix("#") {
            colorString.remove(at: colorString.startIndex)
        }

        if colorString.count != 6 {
            return UIColor.black
        }

        var rgbValue: UInt32 = 0
        Scanner(string:colorString).scanHexInt32(&rgbValue)
        let valueRed    = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let valueGreen  = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let valueBlue   = CGFloat(rgbValue & 0x0000FF) / 255.0
        let valueAlpha  = CGFloat(1.0)

        return UIColor(red: valueRed, green: valueGreen, blue: valueBlue, alpha: valueAlpha)
    }

    private func closeColorPicker(){
        self.dismiss(animated: true, completion: nil)
    }
    
}


