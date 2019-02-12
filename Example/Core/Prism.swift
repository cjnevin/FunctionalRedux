import Foundation

public struct Prism<A, B> {
    public let preview: (A) -> B?
    public let review: (B) -> A
    
    public init(preview: @escaping (A) -> B?,
                review: @escaping (B) -> A) {
        self.preview = preview
        self.review = review
    }
}

extension Prism {
    public func isCase(_ whole: A) -> Bool {
        return preview(whole) != nil
    }
}

extension Optional {
    public static var prism: Prism<Optional, Wrapped> {
        return Prism<Optional, Wrapped>(
            preview: { $0 },
            review: Optional.some)
    }
}
