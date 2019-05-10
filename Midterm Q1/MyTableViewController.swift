import UIKit

class MyTableViewController: UITableViewController {
    var placesList : [PLACES] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getItems()
    }//viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        getItems()
    }
    
    func getItems() {
        if let context =
            (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let coreDataPLaces = try? context.fetch(PLACES.fetchRequest()) as? [PLACES] {
                placesList = coreDataPLaces
                tableView.reloadData()
            }
        }
    }//getItems
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return placesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)    
        cell.textLabel?.text = placesList[indexPath.row].address
        return cell
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let toSaveLoc = placesList[indexPath.row]
                context.delete(toSaveLoc)
                placesList.remove(at: indexPath.row)
                try? context.save()
            }
            
            tableView.reloadData()
        }
        UserDefaults.standard.set(placesList, forKey: "PLACES")
    }
}
