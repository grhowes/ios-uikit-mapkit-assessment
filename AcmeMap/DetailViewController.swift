import MapKit
import UIKit

class DetailViewController: UIViewController, UITableViewDataSource
{
    var selectedFeature : MapFeature!
    var model : MapFeatureModel!
    var features : [MapFeature]!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        features = Array(model.features!.sort(byDistanceFrom: selectedFeature).prefix(upTo: 3))
        
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)

        let feature = self.features[indexPath.row]
        let distance = self.selectedFeature.distance(from: feature)
        let measurement = Measurement(value: distance, unit: UnitLength.meters)
        let measurementInMiles = measurement.converted(to: UnitLength.miles)
        result.textLabel?.text = feature.name
        
        result.detailTextLabel?.text = String(format: "%.2f miles", measurementInMiles.value)
        
        
        // below is just for discussion
//        if #available(iOS 15.0, *) {
//            result.detailTextLabel?.text = measurementInMiles.formatted()
//        } else {
//            result.detailTextLabel?.text = String(format: "%.2f miles", measurementInMiles.value)
//        }

        return result
    }
}

