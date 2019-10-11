//
//  ViewController.swift
//  Testing
//
//  Created by Hao Xuan on 11/10/2019.
//  Copyright © 2019 Hao Xuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var testCollectionView: UICollectionView!
    
    @IBOutlet weak var previousButton: UIBarButtonItem!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var currentIndex : Int = 0
    
    var charArray = [String]()
    
    var backgroundColorArraay = [String]()
    
    let uppercaseLetters = (65...90).map {String(UnicodeScalar($0))}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Testing Apps"
        
        self.testCollectionView.dataSource = self
        self.testCollectionView.delegate = self
        self.testCollectionView.reloadData()
        self.testCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast //UIScrollViewDecelerationRateFast
        
        for i in 0..<3
        {
            charArray.append(self.uppercaseLetters.randomElement()!)
            backgroundColorArraay.append(randomHexColorCode())
        }
        
        
        self.previousButton.isEnabled = false
        
    }

    @IBAction func addFuc(_ sender: Any) {
        if (charArray.count > 0)
        {
            charArray.insert(uppercaseLetters.randomElement()!, at: currentIndex + 1)
            backgroundColorArraay.insert(randomHexColorCode(), at: currentIndex + 1)
            self.testCollectionView.reloadData()
            self.testCollectionView.scrollToItem(at: IndexPath(row: currentIndex+1, section: 0), at: .right, animated: true)
        }
        else
        {
            charArray.insert(uppercaseLetters.randomElement()!, at: 0)
            backgroundColorArraay.insert(randomHexColorCode(), at: 0)
            self.testCollectionView.reloadData()
        }
    }
    
    @IBAction func deleteFuc(_ sender: Any) {
        if(charArray.count > 0)
        {
            charArray.remove(at: currentIndex)
            backgroundColorArraay.remove(at: currentIndex)
            self.testCollectionView.reloadData()
            if(currentIndex != 0)
            {
                self.testCollectionView.scrollToItem(at: IndexPath(row: currentIndex - 1, section: 0), at: .left, animated: true)
            }
        }
        else
        {
            print("cannot delete")
        }
    }
    
    @IBAction func previousFunc(_ sender: Any) {
        currentIndex = currentIndex - 1
        self.testCollectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .left, animated: true)
        updateButtonStatus(index: currentIndex)
    }
    
    @IBAction func nextFunc(_ sender: Any) {
        currentIndex = currentIndex + 1
        self.testCollectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .right, animated: true)
        updateButtonStatus(index: currentIndex)
    }
    
    func updateButtonStatus(index : Int)
    {
        self.previousButton.isEnabled = true
        self.nextButton.isEnabled = true
        
        if(index == 0)
        {
            self.previousButton.isEnabled = false
        }
        else if(index == self.charArray.count - 1)
        {
            self.nextButton.isEnabled = false
        }
    }
    
}

extension ViewController :  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return charArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.testCollectionView.dequeueReusableCell(withReuseIdentifier: "TestCollectionViewCell", for: indexPath) as! TestCollectionViewCell
        cell.webView.loadHTMLString("<body style=background-color:\(self.backgroundColorArraay[indexPath.row]);><center>\(self.charArray[indexPath.row])</center></body>", baseURL: nil)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

extension ViewController : UIScrollViewDelegate
{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        
        if(scrollView.tag == 0){
            //only perform when operator is scrolling
            let layout = self.testCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
            
            var offset = targetContentOffset.pointee
            let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
            let roundedIndex = round(index)
            
            offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
            targetContentOffset.pointee = offset
            
            let path = IndexPath(item: Int(roundedIndex), section: 0)
            currentIndex = Int(roundedIndex)
            updateButtonStatus(index: currentIndex)
            self.collectionView(self.testCollectionView, didSelectItemAt: path)
        }
        
    }
}

func randomHexColorCode() -> String{
    let a = ["1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
    return "#".appending(a[Int(arc4random_uniform(15))]).appending(a[Int(arc4random_uniform(15))]).appending(a[Int(arc4random_uniform(15))])
}
