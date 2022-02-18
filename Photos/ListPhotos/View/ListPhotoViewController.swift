import UIKit

protocol ListPhotoPresenterProtocol {
    var view: ListPhotoViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func sendRequest()
    func setTotalPhoto(_ count: Int)
    func openFullSizePhoto() 
    func backButtonDidTouch()
    func nextButtonDidTouch()
}

protocol ListPhotoViewProtcol: UIView {
    func startLoading()
    func addDataToView(data: String, image: UIImage)
}

class ListPhotoViewController: UIViewController, ListPhotoViewControllerProtocol {

    private let presenter: ListPhotoPresenterProtocol
    
    private lazy var customView: ListPhotoViewProtcol = ListPhotoView(viewDelegate: self)
    
    private lazy var alert: UIAlertController = {
        let alert = UIAlertController(title: "Bad connection", message: "Try again", preferredStyle: .alert)
        let alertActionTryAgain = UIAlertAction(title: "Try again", style: .default) { _ in
            self.presenter.sendRequest()
        }
        alert.addAction(alertActionTryAgain)
        return alert
    }()
    
    init(presenter: ListPhotoPresenterProtocol) {
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
        navigationController?.navigationBar.barTintColor = .black
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func startLoading() {
        customView.startLoading()
    }
    
    func addDataToView(data: String, image: UIImage) {
        customView.addDataToView(data: data, image: image)
    }
    
    func showAlert() {
        DispatchQueue.main.async {
            self.present(self.alert, animated: true, completion: nil)
        }
    }
    
    func photoDidTouch() {
        presenter.openFullSizePhoto()
    }
    
    func backButtonDidTouch() {
        presenter.backButtonDidTouch()
    }
    
    func nextButtonDidTouch() {
        presenter.nextButtonDidTouch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
}

