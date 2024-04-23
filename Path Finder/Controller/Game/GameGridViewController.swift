//
//  GameGridViewController.swift
//  Path Finder
//
//  Created by Vishwa Fernando on 2024-04-20.
//

import UIKit
import CoreData

class GameGridViewController: UIViewController {
    
    @IBOutlet var pathCollectionView: UICollectionView!
    
    var numRows = 4
    var numColumns = 5
    private var manPosition: (Int, Int) = (0, 0) // man's firts position
    private var flagPosition: (Int, Int) = (0, 0) // flag position
    
    var moveCount: Int = 0
    
    var startTime: Date?
    var endTime: Date?
    
    @IBOutlet var btnUp: UIButton!
    @IBOutlet var btnDown: UIButton!
    
    @IBOutlet var btnLeft: UIButton!
    @IBOutlet var btnRight: UIButton!
    
    //CoreData: persistentContainer
    let persistentContainer = CoreDataManager().persistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pathCollectionView?.contentInsetAdjustmentBehavior = .always
        pathCollectionView.register(UINib(nibName:ClickableCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ClickableCollectionViewCell.identifier)
        pathCollectionView.allowsSelection = true
        
        btnUp.layer.borderWidth = 0.5
        btnUp.layer.borderColor = UIColor.systemBlue.cgColor
        btnUp.layer.cornerRadius = 8
        
        btnDown.layer.borderWidth = 0.5
        btnDown.layer.borderColor = UIColor.systemBlue.cgColor
        btnDown.layer.cornerRadius = 8
        
        btnLeft.layer.borderWidth = 0.5
        btnLeft.layer.borderColor = UIColor.systemBlue.cgColor
        btnLeft.layer.cornerRadius = 8
        
        btnRight.layer.borderWidth = 0.5
        btnRight.layer.borderColor = UIColor.systemBlue.cgColor
        btnRight.layer.cornerRadius = 8
        
        setRandomFalgPosition()
    }
    
    
    @IBAction func actionMoveUp(_ sender: Any) {
        if manPosition.0 > 0 {
            manPosition.0 -= 1
            pathCollectionView.reloadData()
            checkWinning()
        }
    }
    
    @IBAction func actionMoveDown(_ sender: Any) {
        if manPosition.0 < numRows - 1 {
            manPosition.0 += 1
            pathCollectionView.reloadData()
            checkWinning()
        }
    }
    
    @IBAction func actionMoveLeft(_ sender: Any) {
        if manPosition.1 > 0 {
            manPosition.1 -= 1
            pathCollectionView.reloadData()
            checkWinning()
        }
    }
    
    @IBAction func actionMoveRight(_ sender: Any) {
        if manPosition.1 < numColumns - 1 {
            manPosition.1 += 1
            pathCollectionView.reloadData()
            checkWinning()
        }
    }
    
    
    // MARK: Wining
    // check man reached to the flag
    private func checkWinning(){
        
        // Update Move Count
        moveCount += 1
        
        print(manPosition)
        if manPosition == flagPosition {
            saveResults()
            createAnimateLayer()
            showAlertAction(title: "Well Done!", message: "Press OK to see the results")
            
        }
    }
    
    // MARK: Custom method for flag position
    // Set Random Flag position
    private func setRandomFalgPosition(){
        
        // Set flag position randomly
        repeat {
            flagPosition = (Int.random(in: 0..<numRows), Int.random(in: 0..<numColumns))
        }while flagPosition == manPosition
        
    }
    
    // Winning Animation
    private func createAnimateLayer(){
        let layer = CAEmitterLayer()
        layer.emitterPosition = CGPoint(x: view.center.x, y: -100)
        
        let cell = CAEmitterCell()
        cell.scale = 0.1
        cell.emissionRange = .pi * 2
        cell.lifetime = 20
        cell.birthRate = 50
        cell.velocity = 200
        cell.contents = UIImage(named: "ic_celebrate")!.cgImage
        
        layer.emitterCells = [cell]
        view.layer.addSublayer(layer)
        view.isUserInteractionEnabled = false
    }
    
    
    // Save game Result data
    func saveResults(){
        
        endTime = Date()
        var timeDefference = ""
        
        if let differenceString = Date().formattedTimeDifference(from: startTime!, to: endTime!) {
            print(differenceString)
            timeDefference = differenceString
        }else{
            print("Somthing went wrong")
        }
        
        let context = persistentContainer.viewContext
        let results = NSEntityDescription.insertNewObject(forEntityName: "Results", into: context) as! Results // NSManagedObject
        
        results.gridSize = Int16(numRows * numColumns)
        results.moveCount = Int16(moveCount)
        results.timeDefference = timeDefference
        results.startTime = startTime
        results.endTime = endTime
        
        // save the obj context to persist
        do {
            try context.save()
        } catch let error as NSError {
            print("Not Saved \(error), \(error.userInfo)")
        }
    }
    
    //Alert Dialog for move to Results page
    private func showAlertAction(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let resultsViewController = storyBoard.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
            self.navigationController?.pushViewController(resultsViewController, animated: true)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


extension GameGridViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numRows * numColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClickableCollectionViewCell.identifier, for: indexPath) as! ClickableCollectionViewCell
        
        let currentCell = indexPath.item
        
        let Row = currentCell / numColumns
        let Column = currentCell % numColumns
        
        if manPosition.0 == Row && manPosition.1 == Column {
            cell.imageView.image = UIImage(named: "ic_man")
        }else{
            cell.imageView.image = UIImage(named: " ")
        }
        
        if flagPosition.0 == Row && flagPosition.1 == Column {
            cell.imageView.image = UIImage(systemName: "flag")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(pathCollectionView.frame.size.width) / (numColumns + 1) , height: Int(pathCollectionView.frame.size.height) / (numRows + 1))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell = indexPath.item
        
        let selectedRow = selectedCell / numColumns
        let selectedColumn = selectedCell % numColumns
        
        
        if (selectedRow == manPosition.0 && abs(selectedColumn - manPosition.1) == 1) || (selectedColumn == manPosition.1 && abs(selectedRow - manPosition.0) == 1) {
            
            // Move man
            manPosition = (selectedRow, selectedColumn)
            pathCollectionView.reloadData()
            checkWinning()
            
        }
    }
    
}
