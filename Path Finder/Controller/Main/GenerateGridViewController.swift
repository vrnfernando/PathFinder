//
//  ViewController.swift
//  Path Finder
//
//  Created by Vishwa Fernando on 2024-04-20.
//

import UIKit

class GenerateGridViewController: UIViewController {
    
    @IBOutlet var btnGenerateGrid: UIButton!
    
    @IBOutlet var btnContinue: UIButton!
    
    @IBOutlet var btnRowPlus: UIButton!
    @IBOutlet var btnRowMinus: UIButton!
    
    @IBOutlet var btnColumnPlus: UIButton!
    @IBOutlet var btnColumnMinus: UIButton!
    
    @IBOutlet var lbGridStatus: UILabel!
    
    @IBOutlet var lbRowsCount: UILabel!
    
    @IBOutlet var lbColumnsCount: UILabel!
    
    @IBOutlet var lbHint: UILabel!
    
    @IBOutlet var lbGuessedStatus: UILabel!
    
    @IBOutlet var viewRow: UIView!
    @IBOutlet var viewColumn: UIView!
    
    @IBOutlet var viewBottom: UIView!
    
    var rowNumbers:Int = 0
    var columnNumbers:Int = 0
    
    var rowValue: Int = 5 {
        didSet{
            updateRowSection()
        }
    }
    
    var columnValue: Int = 5 {
        didSet{
            updateColumnSection()
        }
    }
    
    var startTime: Date?
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        lbGridStatus.text = "Please Tap Generate Grid Button to Start"
        lbHint.text = ""
        btnGenerateGrid.isHidden = false
        btnContinue.isEnabled = false
        lbGuessedStatus.isHidden = true
        
        btnRowMinus.isEnabled = false
        btnRowPlus.isEnabled = false
        btnColumnMinus.isEnabled = false
        btnColumnPlus.isEnabled = false
        
        lbRowsCount.text = "0"
        lbColumnsCount.text = "0"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pronto - Path Finder"
        
        btnGenerateGrid.layer.cornerRadius = 8
        btnContinue.layer.cornerRadius = 8
        
        btnRowPlus.layer.borderWidth = 1
        btnRowPlus.layer.borderColor = UIColor.gray.cgColor
        
        btnRowMinus.layer.borderWidth = 1
        btnRowMinus.layer.borderColor = UIColor.gray.cgColor
        
        btnColumnPlus.layer.borderWidth = 1
        btnColumnPlus.layer.borderColor = UIColor.gray.cgColor
        
        btnColumnMinus.layer.borderWidth = 1
        btnColumnMinus.layer.borderColor = UIColor.gray.cgColor
        
        viewRow.layer.borderWidth = 1
        viewRow.layer.borderColor = UIColor.lightGray.cgColor
        
        viewColumn.layer.borderWidth = 1
        viewColumn.layer.borderColor = UIColor.lightGray.cgColor
        
        
        viewBottom.layer.borderWidth = 1
        viewBottom.layer.borderColor = UIColor.lightGray.cgColor
        viewBottom.layer.cornerRadius = 8
        
        lbGuessedStatus.text = "You gussed correctly. Press continue to go to the grid."
        
    }
    
    @IBAction func actionGenrateGrid(_ sender: Any) {
        rowNumbers = generateRandomNumbers().0
        columnNumbers = generateRandomNumbers().1
        
        let totalCells = rowNumbers * columnNumbers
        lbHint.text = "Hint: Total Number of cells is \(totalCells)"
        
        lbGridStatus.text = "Grid generated. Now guess the rows and columns to get access."
        btnGenerateGrid.isHidden = true
        
        btnRowMinus.isEnabled = true
        btnRowPlus.isEnabled = true
        btnColumnMinus.isEnabled = true
        btnColumnPlus.isEnabled = true
        
        //Set Start time
        startTime = Date()
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GameGridViewController") as! GameGridViewController
        nextViewController.numColumns = columnNumbers
        nextViewController.numRows = rowNumbers
        nextViewController.startTime = startTime!
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    /**
     Plus Minus for Rows & Columns
     */
    @IBAction func actionRowMinus(_ sender: Any) {
        if rowValue > 4 {
            rowValue -= 1
            checkRowsColumnsGuessing()
        }
    }
    
    @IBAction func actionRowPlus(_ sender: Any) {
        if rowValue < 6 {
            rowValue += 1
            checkRowsColumnsGuessing()
        }
    }
    
    @IBAction func actionColumnMinus(_ sender: Any) {
        if columnValue > 4 {
            columnValue -= 1
            checkRowsColumnsGuessing()
        }
    }
    
    @IBAction func actionColumnPlus(_ sender: Any) {
        if columnValue < 6 {
            columnValue += 1
            checkRowsColumnsGuessing()
        }
    }
    
    // Check Row count and Column count matched to the Gussed Row and Column count
    func checkRowsColumnsGuessing(){
        if (rowValue == rowNumbers) && (columnValue == columnNumbers) {
            
            btnRowMinus.isEnabled = false
            btnRowPlus.isEnabled = false
            btnColumnMinus.isEnabled = false
            btnColumnPlus.isEnabled = false
            
            lbGuessedStatus.isHidden = false
            btnContinue.isEnabled = true
        }
    }
    
    // Validate Row count between 4-6
    func updateRowSection(){
        lbRowsCount.text = "\(rowValue)"
        lbColumnsCount.text = "\(columnValue)"
        btnRowPlus.isEnabled = rowValue < 6
        btnRowMinus.isEnabled = rowValue > 4
    }
    
    // Validate Column count between 4-6
    func updateColumnSection(){
        lbRowsCount.text = "\(rowValue)"
        lbColumnsCount.text = "\(columnValue)"
        btnColumnPlus.isEnabled = columnValue < 6
        btnColumnMinus.isEnabled = columnValue > 4
    }
    
    // RandomNumbers Between 4 & 6
    func generateRandomNumbers() -> (Int, Int) {
        let lowerBound = 4
        let upperBound = 6
        
        let random1 = Int.random(in: lowerBound...upperBound)
        let random2 = Int.random(in: lowerBound...upperBound)
        
        return (random1, random2)
    }
    
}

