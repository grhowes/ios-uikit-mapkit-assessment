import MapKit
import UIKit

class DetailViewController: UIViewController, UITableViewDataSource {
    static func newInstance() -> DetailViewController? {
        guard let result = UIStoryboard(
            name: "Detail", bundle: nil
        ).instantiateInitialViewController() as? DetailViewController else { return nil }

        // Do any additional setup after loading the view.

        return result
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)

        result.textLabel?.text = "Location"
        result.detailTextLabel?.text = "0.00 miles"

        return result
    }
}

