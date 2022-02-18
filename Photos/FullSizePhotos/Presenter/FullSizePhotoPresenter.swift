import UIKit

protocol FullSizePhotoViewControllerProtocol: UIViewController {
    func setupView(with date: String, with image: UIImage)
}

final class FullSizePhotoPresenter: FullSizePhotoPresenterProtocol {
    var view: FullSizePhotoViewControllerProtocol?
    var model: FullSizeViewModel?
    
    func viewDidLoad() {
        guard let model = model else {
            assertionFailure("model is nil")
            return
        }
        view?.setupView(with: model.date, with: model.image)
    }
}
