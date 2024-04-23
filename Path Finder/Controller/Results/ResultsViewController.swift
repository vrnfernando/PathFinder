//
//  ResultsViewController.swift
//  Path Finder
//
//  Created by Vishwa Fernando on 2024-04-23.
//

import UIKit
import CoreData

class ResultsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var tableViewResult: UITableView!
    
    @IBOutlet var tvRoundDetail: UITextView!
    
    @IBOutlet var tvHightConstraint: NSLayoutConstraint!
    
    private var resultsList: [Result] = []
    
    private var lastResult: Result?
    
    // Orignal Height for Text View
    var orignalHeight : CGFloat?
    
    // CoreData: persistentContainer
    let persistentContainer = CoreDataManager().persistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let cellnibName = UINib(nibName: ResultTableViewCell.identifier, bundle: nil)
        self.tableViewResult.register(cellnibName, forCellReuseIdentifier: ResultTableViewCell.identifier)
        
        let headerCellnibName = UINib(nibName: ResultsHeaderTableViewCell.identifier, bundle: nil)
        self.tableViewResult.register(headerCellnibName, forHeaderFooterViewReuseIdentifier: ResultsHeaderTableViewCell.identifier)
        
        tvRoundDetail.layer.borderWidth = 1
        tvRoundDetail.layer.borderColor = UIColor.lightGray.cgColor
        
        tvRoundDetail.delegate = self
        tvRoundDetail.isScrollEnabled = false
        
        self.orignalHeight = self.tvRoundDetail.frame.size.height
        
        fetchData()
        updateLastResult()
    }
    
    // MARK: Retrive Data from DB
    func fetchData() {
        
        let context = persistentContainer.viewContext
        
        // fetch request for the "Results"
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Results")
        let sortDescriptor = NSSortDescriptor(key: "endTime", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 5
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                
                if let grideSize = result.value(forKey: "gridSize") as? Int,
                   let moveCount = result.value(forKey: "moveCount") as? Int,
                   let timeDefference = result.value(forKey: "timeDefference") as? String,
                   let startTime = result.value(forKey: "startTime") as? Date,
                   let endTime = result.value(forKey: "endTime") as? Date {
                    
                    let resultModel = Result(gridSize: grideSize, moveCount: moveCount, startTime: startTime, endTime: endTime, timeDefference: timeDefference)
                    resultsList.append(resultModel)
                }
            }
            sortTimeDifference() // Sort data
            
        } catch let error as NSError {
            print("Fetching Failed. \(error), \(error.userInfo)")
        }
    }

    
    @IBAction func actionNewGame(_ sender: Any) {
        // Move to Start of the game
        popToRootViewController()
    }
    
    
    
    private func sortTimeDifference() {
        // sort Data set according time difference
        resultsList.sort { result1, result2 in
            let firstDifference = result1.endTime?.timeIntervalSince(result1.startTime!)
            let secondDifference = result2.endTime?.timeIntervalSince(result2.startTime!)
            return firstDifference! < secondDifference!
        }
        
        // Get last Event by Date
        if let lastEvent = resultsList.max(by: { $0.endTime! < $1.endTime! }) {
            lastResult = lastEvent
        }
        
        tableViewResult.reloadData()
    }
    
    
    // Update results textView
    private func updateLastResult(){
        
        let formatedDate = Date().formatDate((lastResult?.endTime)!)
        for _ in 0...(lastResult?.gridSize)! {
            tvRoundDetail.text += "This round was completed at \(formatedDate). "
            adjuestTextViewHight()
        }
    }
    
    
    // MARK: TextView hight update
    private func adjuestTextViewHight(){
        
        let fixedWidth = tvRoundDetail.frame.size.width
        let newTvSize = tvRoundDetail.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        // Limit hight
        let tvmaxhight: CGFloat = orignalHeight!
        
        
        tvHightConstraint.constant = min(newTvSize.height, tvmaxhight)
        
        // enable Scrolling : content hight exceeds maxHight
        tvRoundDetail.isScrollEnabled = newTvSize.height > tvmaxhight
        
        // update changes
        view.layoutIfNeeded()
        
    }
    
}


extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = self.tableViewResult.dequeueReusableHeaderFooterView(withIdentifier: ResultsHeaderTableViewCell.identifier) as! ResultsHeaderTableViewCell
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell    = self.tableViewResult.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier, for: indexPath) as? ResultTableViewCell
        
        cell?.lbRank.text = "\(indexPath.row + 1)"
        cell?.lbMoves.text = "\(resultsList[indexPath.row].moveCount ?? 0)"
        cell?.lbGridSize.text = "\(resultsList[indexPath.row].gridSize ?? 0)"
        cell?.lbTime.text = resultsList[indexPath.row].timeDefference ?? ""
        
        if resultsList[indexPath.row].endTime == lastResult?.endTime {
            cell?.backgroundColor = UIColor.lightGray
        }
        return cell!
    }
    
}
