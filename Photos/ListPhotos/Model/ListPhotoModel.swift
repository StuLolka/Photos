import UIKit

struct ListPhotoModel {
    let image: UIImage
    let date: String
    let metaInformation: String
}

final class CurrentModel {
    let model: ListPhotoModel
    init(model: ListPhotoModel) {
        self.model = model
    }
}
