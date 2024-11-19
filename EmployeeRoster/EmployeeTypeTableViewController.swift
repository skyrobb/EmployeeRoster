
import UIKit

protocol EmployeeTypeTableViewControllerDelegate {
    func employeeTypeTableViewController(_: EmployeeTypeTableViewController, didSelect: EmployeeType)
}

class EmployeeTypeTableViewController: UITableViewController, EmployeeTypeTableViewControllerDelegate {
    
    func employeeTypeTableViewController(_: EmployeeTypeTableViewController, didSelect: EmployeeType) {
                
    }
    
    var employeeType: EmployeeType?
    var delegate: EmployeeTypeTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EmployeeType.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeType", for: indexPath)
        let type = EmployeeType.allCases[indexPath.row]
        cell.textLabel?.text = type.description
        
        if employeeType == type {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedType = EmployeeType.allCases[indexPath.row]
        employeeType = selectedType
        delegate?.employeeTypeTableViewController(self, didSelect: selectedType)
        tableView.reloadData()
    }
    
    

}
