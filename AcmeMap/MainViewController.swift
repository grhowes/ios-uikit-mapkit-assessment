import MapKit
import UIKit

class MainViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet private var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        addAnnotation(lat: 28.5384, long: -81.3789)
    }

    private func addAnnotation(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = .init(latitude: lat, longitude: long)
        mapView.addAnnotation(annotation)
    }

    private func presentDetail() {
        guard let detail = DetailViewController.newInstance() else { return }

        present(detail, animated: true)
    }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        presentDetail()
    }
}
