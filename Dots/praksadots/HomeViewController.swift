//
//  HomeViewController.swift
//  praksadots
//
//  Created by Webelinx Praksa 2 on 22.3.22..
//

import UIKit

class HomeViewController: UIViewController
{
    class Dot
    {
        var color: Int = -1
        var checked: Bool = false
        init(color: Int, checked: Bool)
        {
            self.color = color
            self.checked = checked
        }
        
        func setDotColor(color: Int)
        {
            self.color = color
        }
        func isChecked(checked: Bool)
        {
            self.checked = checked
        }
    }
    

    @IBOutlet weak var sumOfBallsLabel: UILabel!
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var gameOverLbl: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var dotCV: UICollectionView!
    
    var sumOfDestroyedBalls = 0
    var rowAndColumnNumber = 6

    var dots = [[Dot]]()
    var arrayToFill: [[Dot]] = []
    var colorsArray = [0, 1, 2, 3, 4]
    var isAnimating = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        for i in 0 ..< rowAndColumnNumber
        {
            var dotLine = [Dot]()
            for j in 0 ..< rowAndColumnNumber
            {
                dotLine.append(Dot(color: colorsArray.randomElement()!, checked: false))
            }
            dots.append(dotLine)
        }
        
        sumOfBallsLabel.text = String(sumOfDestroyedBalls)//Resi
        gameOverLbl.text = "GAME OVER"
        gameOverLbl.textColor = .red
        tryAgainButton.backgroundColor = .white
        tryAgainButton.tintColor = .red
        tryAgainButton.backgroundColor = .gray
        tryAgainButton.isHidden = true
        gameOverView.backgroundColor = .white
        gameOverView.tintColor = .red
        gameOverView.isHidden = true
    }
    
    @IBAction func onTryAgainButtonClick(_ sender: Any)
    {
        
        sumOfDestroyedBalls = 0
        sumOfBallsLabel.text = String(0)
        dotCV.reloadData()
        viewDidLoad()
    }
    
    func checkReset(matrix: inout [[Dot]])
    {
        for i in 0 ..< rowAndColumnNumber
        {
            for j in 0 ..< rowAndColumnNumber
            {
               matrix[i][j].checked = false
            }
        }
    }
    
    func checkAround(matrix: inout [[Dot]] , iDotIndex: Int, jDotIndex: Int, dotColor: Int, gameOverCheck: Bool) -> [IndexPath]
    {
        var array = [IndexPath]()
        
        if iDotIndex < 0 || iDotIndex > (rowAndColumnNumber - 1) || jDotIndex < 0 || jDotIndex > (rowAndColumnNumber - 1) || matrix[iDotIndex][jDotIndex].color != dotColor || matrix[iDotIndex][jDotIndex].color == -1
        {
            return array
        }
        else
        {
                matrix[iDotIndex][jDotIndex].isChecked(checked: true)
                matrix[iDotIndex][jDotIndex].setDotColor(color: -1)
                
            array.append(IndexPath(row: iDotIndex * rowAndColumnNumber + jDotIndex, section: 0))
            //print("i\(iDotIndex), j \(jDotIndex)")

            return (array + checkAround(matrix: &matrix, iDotIndex: (iDotIndex - 1), jDotIndex: jDotIndex, dotColor: dotColor, gameOverCheck: gameOverCheck)
                          + checkAround(matrix: &matrix, iDotIndex: (iDotIndex + 1), jDotIndex: jDotIndex, dotColor: dotColor, gameOverCheck: gameOverCheck)
                          + checkAround(matrix: &matrix, iDotIndex: iDotIndex, jDotIndex: (jDotIndex + 1), dotColor: dotColor, gameOverCheck: gameOverCheck)
                          + checkAround(matrix: &matrix, iDotIndex: iDotIndex, jDotIndex: (jDotIndex - 1), dotColor: dotColor, gameOverCheck: gameOverCheck))
        }
    }
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 36
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DotCell", for: indexPath) as! DotCell
        cell.set(dotColour: dots[indexPath.item / rowAndColumnNumber][indexPath.item % rowAndColumnNumber].color)
        cell.setVisible(!isAnimating)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width / 7, height: collectionView.frame.height / 7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.view.isUserInteractionEnabled = false
        print("CLICK \(indexPath.item)")
        
        var arrayOfBalls = checkAround(matrix: &dots, iDotIndex: (indexPath.item / rowAndColumnNumber), jDotIndex: (indexPath.item % rowAndColumnNumber), dotColor: dots[indexPath.item / rowAndColumnNumber][indexPath.item % rowAndColumnNumber].color, gameOverCheck: false)
        
        self.isAnimating = true
        self.fillAgain(numberOfDestroyed: arrayOfBalls.count)
        
        collectionView.performBatchUpdates {
            collectionView.reloadItems(at: arrayOfBalls)
        } completion: { _ in
            for index in arrayOfBalls
            {
                (collectionView.cellForItem(at: index) as? DotCell)?.animate()
            }
            self.isAnimating = false
        }
        
//        checkReset(matrix: &dots)
//        if(checkIfGameOver())
//        {
//            gameOverView.isHidden = false
//            tryAgainButton.isHidden = false
//        }
//
//        checkReset(matrix: &dots)
//
    }
    
    func fillAgain(numberOfDestroyed: Int)
    {
        let dotBackup = dots
        if(numberOfDestroyed > 2)
        {
            for i in 0 ..< rowAndColumnNumber
            {
                for j in 0 ..< rowAndColumnNumber
                {
                    if(dots[i][j].color == -1)
                    {
                        dots[i][j].setDotColor(color: colorsArray.randomElement()!)
                    }
                }
            }
            sumOfDestroyedBalls += numberOfDestroyed
            sumOfBallsLabel.text = String(sumOfDestroyedBalls)
            self.view.isUserInteractionEnabled = true
        }
        else
        {
            dots = dotBackup
        }
    }

    
    func checkIfGameOver() -> Bool
    {
        //var dotsBackup = dots
        var numOfBalls = 0
        for i in 0 ..< rowAndColumnNumber
        {
            for j in 0 ..< rowAndColumnNumber
            {
                numOfBalls = checkAround(matrix: &dots, iDotIndex: i, jDotIndex: j, dotColor: dots[i][j].color, gameOverCheck: true).count
                if(numOfBalls > 2)
                {
                    return false
                }
            }
        }
        return true
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width / 7, height: collectionView.frame.height / 7)
    }
}

