import UIKit

final class FullSizePhotoView: UIImageView, FullSizePhotoViewProtocol {
    private let viewDelegate: FullSizePhotoViewControllerProtocol
    
    private lazy var downloadDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .systemBlue
        return label
    }()
    
    init(viewDelegate: FullSizePhotoViewControllerProtocol) {
        self.viewDelegate = viewDelegate
        super.init(frame: UIScreen.main.bounds)
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(with date: String, with image: UIImage) {
        self.image = image
        downloadDateLabel.text = date
    }
    
    private func setupConstraints() {
        contentMode = .scaleAspectFit
        addSubview(downloadDateLabel)
        NSLayoutConstraint.activate([
            downloadDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            downloadDateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            downloadDateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
        ])
    }
    
    
}
