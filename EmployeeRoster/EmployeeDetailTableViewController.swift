
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTypeTableViewControllerDelegate {
    
    var isEditingBirthday = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    let dobDatePickerCellIndexPath = IndexPath(row: 2, section: 0)
    let dobLabelCellIndexPath = IndexPath(row: 1, section: 0)
    
    var employeeType: EmployeeType?

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var employeeTypeLabel: UILabel!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet var dobDatePicker: UIDatePicker!
    
    weak var delegate: EmployeeDetailTableViewControllerDelegate?
    var employee: Employee?
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        updateSaveButtonState()
    }
    
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            
            dobLabel.text = dateFormatter.string(from: employee.dateOfBirth)
            dobLabel.textColor = .black
            employeeTypeLabel.text = employee.employeeType.description
            employeeTypeLabel.textColor = .black
        } else {
            navigationItem.title = "New Employee"
            prepareDOBPicker()
        }
    }
    
    private func updateSaveButtonState() {
//        let shouldEnableSaveButton = nameTextField.text?.isEmpty == false
        
//        “only enable the Save button if employeeType contains a value”
        let shouldEnableSaveButton = nameTextField.text?.isEmpty == false && employeeType != nil
        saveBarButtonItem.isEnabled = shouldEnableSaveButton
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
              let employeeType = self.employeeType
        else {return}
        
        let employee = Employee(name: name, dateOfBirth: dobDatePicker.date, employeeType: employeeType)
        delegate?.employeeDetailTableViewController(self, didSave: employee)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
    }

    @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func datePickerDateChanged(_ sender: UIDatePicker) {
        dobLabel.text = dateFormatter.string(from: dobDatePicker.date)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == dobDatePickerCellIndexPath && isEditingBirthday == false {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == dobLabelCellIndexPath {
            isEditingBirthday.toggle()
            dobLabel.textColor = UIColor.black
            dobLabel.text = dateFormatter.string(from: dobDatePicker.date)
        }
    }
    
    @IBSegueAction func showEmployeeTypes(_ coder: NSCoder) -> EmployeeTypeTableViewController? {
        let employeTypeTableViewController = EmployeeTypeTableViewController(coder: coder)
        employeTypeTableViewController?.delegate = self
        return employeTypeTableViewController
    }
    
    
    func employeeTypeTableViewController(_: EmployeeTypeTableViewController, didSelect: EmployeeType) {
        self.employeeType = didSelect
        employeeTypeLabel.text = employeeType!.description
        employeeTypeLabel.textColor = .black
        updateSaveButtonState()
    }
    
    private func prepareDOBPicker(){
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        dateComponents.calendar = Calendar.current
        
        guard let currentYear = dateComponents.year else {
            return
        }
        
        dateComponents.month = 6
        dateComponents.day = 15
        dateComponents.year = (currentYear - 40)
        
        dobDatePicker.date = dateComponents.date ?? Date()
    }
}
