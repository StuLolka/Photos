import UIKit

protocol ListPhotoViewControllerProtocol: UIViewController {
    func startLoading()
    func addDataToView(data: String, image: UIImage)
    func showAlert()
    func photoDidTouch()
    func backButtonDidTouch()
    func nextButtonDidTouch()
}

protocol NetworkProtocol {
    var delegatePresenter: ListPhotoPresenterProtocol? { get set }
    func requestImages(for index: Int, completion: @escaping (Result<ListPhotoModel, Error>) -> Void)
}

final class ListPhotoPresenter: ListPhotoPresenterProtocol {
    
    var view: ListPhotoViewControllerProtocol?
    private var currentModel: CurrentModel?
    
    private var network: NetworkProtocol = Network()
    private var currentPhoto = 0
    private var totalPhoto = 0
    
    func viewDidLoad() {
        network.delegatePresenter = self
        sendRequest()
    }
    
    func sendRequest() {
        view?.startLoading()
        request()
    }
    
    func backButtonDidTouch() {
        currentPhoto -= 1
        view?.startLoading()
        request()
    }
    
    func nextButtonDidTouch() {
        currentPhoto += 1
        view?.startLoading()
        request()
    }
    
    func openFullSizePhoto()  {
        
        guard let model = currentModel else {
            assertionFailure("model is nil")
            return
        }
        
        let fullSizePhotoView = Builder.shared.getFullSizePhotoViewController(
            with: model.model.date,
            with: model.model.image)
        view?.navigationController?.pushViewController(fullSizePhotoView, animated: true)
    }
    
    func setTotalPhoto(_ count: Int) {
        totalPhoto = count
    }
    
    private func request() {
        
        if currentPhoto == -1 {
            currentPhoto = totalPhoto - 1
        }
        else if currentPhoto == totalPhoto {
            currentPhoto = 0
        }
        
        network.requestImages(for: currentPhoto) { result in
            switch result {
            case .success(let listModel):
                self.currentModel = CurrentModel(model: listModel)
                self.addDataToView(with: listModel)
            case .failure:
                self.view?.showAlert()
            }
        }
    }
    
    private func addDataToView(with model: ListPhotoModel) {
        view?.addDataToView(data: model.metaInformation, image: model.image)
    }
}
