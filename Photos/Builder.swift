import UIKit
protocol BuilderProtocol {
    func getListPhotoViewController() -> ListPhotoViewControllerProtocol
    func getFullSizePhotoViewController(with date: String, with image: UIImage) -> FullSizePhotoViewControllerProtocol
}

final class Builder: BuilderProtocol {
    
    static let shared: BuilderProtocol = {
        Builder()
    }()
    
    private var listPhotoPresenter: ListPhotoPresenterProtocol = {
        ListPhotoPresenter()
    }()
    
    private var fullSizePhotoPresenter: FullSizePhotoPresenterProtocol = {
        FullSizePhotoPresenter()
    }()
    
    private init() {}
    
    
    
    func getListPhotoViewController() -> ListPhotoViewControllerProtocol {
        let view: ListPhotoViewControllerProtocol = ListPhotoViewController(presenter: listPhotoPresenter)
        listPhotoPresenter.view = view
        return view
    }
    
    func getFullSizePhotoViewController(with date: String, with image: UIImage) -> FullSizePhotoViewControllerProtocol {
        let view: FullSizePhotoViewControllerProtocol = FullSizePhotoViewController(presenter: fullSizePhotoPresenter)
        let model = FullSizeViewModel(date: date, image: image)
        fullSizePhotoPresenter.view = view
        fullSizePhotoPresenter.model = model
        return view
    }
}
