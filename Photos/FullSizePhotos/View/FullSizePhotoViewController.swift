import UIKit

protocol FullSizePhotoPresenterProtocol {
    var view: FullSizePhotoViewControllerProtocol? { get set }
    var model: FullSizeViewModel? { get set }
    
    func viewDidLoad()
    
}

protocol FullSizePhotoViewProtocol: UIImageView {
    func setupView(with date: String, with image: UIImage)
}

final class FullSizePhotoViewController: UIViewController, FullSizePhotoViewControllerProtocol {
    private let presenter: FullSizePhotoPresenterProtocol
    
    private lazy var customView: FullSizePhotoViewProtocol = FullSizePhotoView(viewDelegate: self)
    
    init(presenter: FullSizePhotoPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    func setupView(with date: String, with image: UIImage) {
        customView.setupView(with: date, with: image)
    }
}
