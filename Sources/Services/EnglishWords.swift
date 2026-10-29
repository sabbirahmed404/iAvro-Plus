import Foundation

/// Common English words, so a word like "meeting" typed in a Bangla sentence
/// can be committed as typed instead of being transliterated.
@MainActor
final class EnglishWords {
    static let shared = EnglishWords()

    /// Extra words (one per line) merged with the bundled english.txt at launch
    static var userListURL: URL {
        CacheManager.sharedFolderURL.appendingPathComponent("english-words.txt")
    }

    private let words: Set<String>

    private init() {
        var words: Set<String> = []
        for url in [Bundle.main.url(forResource: "english", withExtension: "txt"), Self.userListURL] {
            guard let url, let text = try? String(contentsOf: url, encoding: .utf8) else { continue }
            for line in text.split(whereSeparator: \.isNewline) where !line.hasPrefix("#") {
                let word = line.trimmingCharacters(in: .whitespaces).lowercased()
                if !word.isEmpty { words.insert(word) }
            }
        }
        self.words = words
    }

    func contains(_ word: String) -> Bool {
        words.contains(word.lowercased())
    }
}
