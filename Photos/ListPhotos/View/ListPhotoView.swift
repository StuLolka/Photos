import UIKit

final class ListPhotoView: UIView, ListPhotoViewProtcol {
    
    private let viewDelegate: ListPhotoViewControllerProtocol
    
    private let loadingView: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.hidesWhenStopped = true
        loading.translatesAutoresizingMaskIntoConstraints = false
        return loading
    }()
    
    private let photoView: UIButton = {
        let imageButton = UIButton()
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.contentMode = .scaleAspectFit
        imageButton.imageView?.contentMode = .scaleAspectFit
        imageButton.addTarget(self, action: #selector(photoDidTouch), for: .touchUpInside)
        return imageButton
    }()
    
    private let dataLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("BACK", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(previousPhoto), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(nextPhoto), for: .touchUpInside)
        return button
    }()
    
    init(viewDelegate: ListPhotoViewControllerProtocol) {
        self.viewDelegate = viewDelegate
        super.init(frame: UIScreen.main.bounds)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.loadingView.startAnimating()
            self.dataLabel.text = ""
            self.photoView.setImage(nil, for: .normal)
        }
    }
    
    func addDataToView(data: String, image: UIImage) {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating()
            self.dataLabel.text = data
            self.photoView.setImage(image, for: .normal)
        }
    }
    
    private func setupConstraint() {
        addSubview(loadingView)
        addSubview(photoView)
        addSubview(dataLabel)
        addSubview(backButton)
        addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            photoView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            photoView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            photoView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            photoView.heightAnchor.constraint(equalToConstant: frame.height / 1.5),
            
            dataLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 15),
            dataLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            dataLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            
            backButton.topAnchor.constraint(equalTo: dataLabel.bottomAnchor, constant: 20),
            backButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: frame.width / 3),
            
            nextButton.topAnchor.constraint(equalTo: backButton.topAnchor),
            nextButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            nextButton.widthAnchor.constraint(equalTo: backButton.widthAnchor)
        ])
        
    }
    
    @objc func photoDidTouch() {
        viewDelegate.photoDidTouch()
    }
    
    @objc func previousPhoto() {
        viewDelegate.backButtonDidTouch()
    }
    
    @objc func nextPhoto() {
        viewDelegate.nextButtonDidTouch()
    }
}
