import MapKit
import UIKit
import Combine

class MainViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet private var mapView: MKMapView!
    private var viewModel : MapFeatureModel!
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = MapFeatureModel()

        viewModel.$annotations.sink
        {
            [weak self] newAnnotations in
            self?.update(toAnnotations: newAnnotations ?? [MapFeatureAnnotation]())
        }.store(in: &cancellables)
        
        viewModel.$lastError.sink
        {
            [weak self] newError in
            self?.handle(networkError: newError)
            
        }.store(in: &cancellables)
    }
    
    private func handle(networkError: Error?)
    {
        let existingErrorAlert = self.presentedViewController as? UIAlertController
        guard let error = networkError else
        {
            existingErrorAlert?.dismiss(animated: true, completion: nil)
            return
        }
        if let resuseAlert = existingErrorAlert
        {
            resuseAlert.message = error.localizedDescription
        }
        else
        {
            let alert = UIAlertController(title: NSLocalizedString("Network Error", comment: ""), message: error.localizedDescription, preferredStyle: .actionSheet)
            let reloadAction = UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: .default) { action  in
                self.viewModel.refresh()
            }
            alert.addAction(reloadAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    private func update(toAnnotations newAnnotations: [MapFeatureAnnotation])
    {
        let (toRemove, toAdd) = MapFeatureAnnotation.determineActiveAnnotations(oldAnnotations: mapView.annotations, newAnnotations: newAnnotations)
        
        mapView.addAnnotations(toAdd)
        mapView.removeAnnotations(toRemove)
    }
    

    private func presentDetail(forFeature feature: MapFeature) {
        guard let detail = DetailViewController.newInstance() else { return }
        detail.selectedFeature = feature
        detail.model = viewModel
        present(detail, animated: true)
    }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let feature = (view.annotation as? MapFeatureAnnotation)?.feature
        {
            presentDetail(forFeature: feature)
        }
    }
    
    /// Deselect the selected pin when the presented detail view is dismissed
    /// - Parameters:
    ///   - flag: whether to animate
    ///   - completion: callback
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil)
    {
        super.dismiss(animated: flag, completion: {
            [weak self] in
            if self?.presentedViewController == nil // actually dismissed, not a partial dismiss
            {
                self?.mapView.deselectAnnotation(self?.mapView.selectedAnnotations.first, animated: flag)
            }
            completion?()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.update(toAnnotations: viewModel.annotations ?? [MapFeatureAnnotation]())
        viewModel.refresh()
    }
}
