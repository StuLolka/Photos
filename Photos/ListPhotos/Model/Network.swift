import Foundation
import UIKit

enum NetworkingError: Error {
    case urlError
    case parseError
    case connectionError
}

final class Network: NetworkProtocol {
    var delegatePresenter: ListPhotoPresenterProtocol?
    
    private let requestString = "https://api.unsplash.com/photos/?client_id="
    private let token = "3XFyivs56WbytYqVILq0BPlUaVEtTd5-v5XRg5rwSkg"
    
    
    func requestImages(for index: Int, completion: @escaping (Result<ListPhotoModel, Error>) -> Void) {
        
        guard let url = URL(string: requestString + token) else {
            completion(.failure(NetworkingError.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(NetworkingError.parseError))
                return
            }
            
            self?.parseImages(from: data, for: index, completion: { result in
                switch result {
                case .success(let model):
                    completion(.success(model))
                case .failure:
                    completion(.failure(NetworkingError.parseError))
                }
            })
        }.resume()
    }
    
    
    
    private func parseImages(from data: Data, for index: Int, completion: @escaping (Result<ListPhotoModel, Error>) -> Void) {
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard let json = jsonObject as? [[String : Any]] else {
                completion(.failure(NetworkingError.parseError))
                return
            }
            
            delegatePresenter?.setTotalPhoto(json.count)
            
            guard let urls = json[index]["urls"],
                  let user = json[index]["user"],
                  let allUrls = urls as? [String : String],
                  let userData = user as? [String : Any] else {
                      completion(.failure(NetworkingError.parseError))
                      return
                  }
            
            guard let full = allUrls["full"],
                  let userName = userData["username"],
                  let totalLikes = userData["total_likes"] else {
                      completion(.failure(NetworkingError.parseError))
                      return
                  }
            
            requestImage(for: full) { result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        completion(.failure(NetworkingError.parseError))
                        return
                    }
                    completion(.success(ListPhotoModel(
                        image: image,
                        date: self.getCurrentDate(),
                        metaInformation: "\(userName), likes: \(totalLikes)"))
                    )
                case .failure:
                    completion(.failure(NetworkingError.parseError))
                }
            }
            
        }
        catch {
            completion(.failure(NetworkingError.connectionError))
        }
    }
    
    private func requestImage(for urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkingError.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                  error == nil else {
                      completion(.failure(NetworkingError.parseError))
                      return
                  }
            
            completion(.success(data))
        }.resume()
    }
    
    private func getCurrentDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        guard let year = components.year,
              let month = components.month,
              let day = components.day,
              let hour = components.hour,
              let minute = components.minute,
              let second = components.second else { return ""}
        
        let monthString = addZeroIfNeeded(to: month)
        let hourString = addZeroIfNeeded(to: hour)
        let minuteString = addZeroIfNeeded(to: minute)
        let secondString = addZeroIfNeeded(to: second)
        
        return """
\(hourString):\(minuteString):\(secondString) \(day).\(monthString).\(year)
"""
    }
    
    private func addZeroIfNeeded(to date: Int) -> String {
        var dateString = "\(date)"
        if date < 10 {
            dateString = "0" + "\(date)"
        }
        return dateString
    }
}


