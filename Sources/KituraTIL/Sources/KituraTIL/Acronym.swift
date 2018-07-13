// MARK: Acronym

struct Acronym: Codable {

    // MARK: Variables

    var id: String?
    var short: String
    var long: String

    // MARK: Init Methods

    init?(id: String?, short: String, long: String) {
        if short.isEmpty || long.isEmpty {
            return nil
        }
        self.id = id
        self.short = short
        self.long = long
    }
}

// MARK: Equatable Methods

extension Acronym: Equatable {

    public static func ==(lhs: Acronym, rhs: Acronym) -> Bool {
        return lhs.short == rhs.short && lhs.long == rhs.long
    }
}
