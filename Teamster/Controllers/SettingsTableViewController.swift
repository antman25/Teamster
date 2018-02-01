//
//  SettingsTableViewController.swift
//  Teamster
//
//  Created by Anthony Magner on 1/20/18.
//  Copyright © 2018 Anthony Magner. All rights reserved.
//

import UIKit

struct SearchCell {
    var isExpanded = false
    var isExpandable = false
    var isVisible = false
    var cellIdentifier = "defaultCell"
    var primaryString = ""
    var secondaryString = ""
}

class SettingsTableViewController: UITableViewController,CustomCellDelegate {
    func dateWasSelected(selectedDateString: String) {
        print("Date")
    }
    
    func maritalStatusSwitchChangedState(isOn: Bool) {
        print("marriage")
    }
    
    func textfieldTextWasChanged(newText: String, parentCell: CustomCell) {
        print("text")
    }
    
    func sliderDidChangeValue(newSliderValue: String) {
        print("slider")
    }
    

    @IBOutlet var tblExpandable: UITableView!
    var visibleRowsPerSection = [[Int]]()
    var cellDescriptors : [SearchCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSettings()
        configureTableView()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
    
        return cellDescriptors.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? CustomCell
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath: indexPath as NSIndexPath )
        let cell = tableView.dequeueReusableCell(withIdentifier: currentCellDescriptor.cellIdentifier, for: indexPath as IndexPath) as! CustomCell
        
        
        if currentCellDescriptor.cellIdentifier == "idCellNormal" {
            /*if let primaryTitle = currentCellDescriptor.primaryString {
                cell.textLabel?.text = primaryTitle as? String
            }
            
            if let secondaryTitle = currentCellDescriptor.secondaryString {
                cell.detailTextLabel?.text = secondaryTitle as? String
            }*/
            /*if let primaryTitle = currentCellDescriptor.primaryString {
                cell.textLabel?.text = primaryTitle
            }*/
        }
        

        // Configure the cell...
        print ("index: \(indexPath) desc: \(currentCellDescriptor)")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Search Criteria"
            
        case 1:
            return "Position Critera"
            
        default:
            return "Fees Criteria"
        }
    }
    
    func loadSettings()
    {
        let cell1 = SearchCell(isExpanded: false, isExpandable: true, isVisible: true, cellIdentifier: "idCellNormal", primaryString: "Primary String", secondaryString: "Secondary String")
        let cell2 = SearchCell(isExpanded: false, isExpandable: true, isVisible: true, cellIdentifier: "idCellDatePicker", primaryString: "Primary String", secondaryString: "Secondary String")
        
        let cell3 = SearchCell(isExpanded: false, isExpandable: true, isVisible: true, cellIdentifier: "idCellSlider", primaryString: "Primary String", secondaryString: "Secondary String")
        cellDescriptors.append(cell1)
        cellDescriptors.append(cell2)
        cellDescriptors.append(cell3)
        //print ("Cell Desc: \(cellDescriptors)")
    }
    
    func configureTableView() {
        tblExpandable.delegate = self
        tblExpandable.dataSource = self
        tblExpandable.tableFooterView = UIView(frame: CGRect.zero)
        
        tblExpandable.register(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "idCellNormal")
        tblExpandable.register(UINib(nibName: "TextfieldCell", bundle: nil), forCellReuseIdentifier: "idCellTextfield")
        tblExpandable.register(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "idCellDatePicker")
        tblExpandable.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "idCellSwitch")
        tblExpandable.register(UINib(nibName: "ValuePickerCell", bundle: nil), forCellReuseIdentifier: "idCellValuePicker")
        tblExpandable.register(UINib(nibName: "SliderCell", bundle: nil), forCellReuseIdentifier: "idCellSlider")
    }
    
    func getIndicesOfVisibleRows() {
        visibleRowsPerSection.removeAll()
        
        //for desc in cellDescriptors {
        for i in 0..<cellDescriptors.count{
            var visibleRows = [Int]()
            if (cellDescriptors[i].isVisible == true){
                visibleRows.append(i)
            }
            
            //for row in 0...((currentSectionCells as! [[String: AnyObject]]).count - 1) {
            //    if currentSectionCells[row] ["isVisible"] as! Bool == true {
            //        visibleRows.append(row)
            //    }
            //}
            
            visibleRowsPerSection.append(visibleRows)
        }
    }
    
    
    func getCellDescriptorForIndexPath(indexPath: NSIndexPath) -> SearchCell {
        //let indexOfVisibleRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        //let cellDescriptor = cellDescriptors[indexPath.section][indexOfVisibleRow] as! [String: AnyObject]
        //return cellDescriptor
        return cellDescriptors[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath: indexPath as NSIndexPath)
        print ("Test3")
        switch currentCellDescriptor.cellIdentifier {
        case "idCellNormal":
            print ("normal")
            return 60.0
            
        case "idCellDatePicker":
            print ("date picker")
            return 270.0
            
        default:
            return 44.0
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
