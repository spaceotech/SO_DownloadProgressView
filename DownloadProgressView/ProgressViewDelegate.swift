

import Foundation
public protocol ProgressViewDelegate: class {
    func finishedProgress(forCircle circle: ProgressView)
}
