import Foundation

extension String {
    var upperCasedCharacters:String {
        get {
            var upper = ""
            for character in self.unicodeScalars {
                if (CharacterSet.uppercaseLetters.contains(character)) {
                    upper.append(character.description)
                }
            }
            return upper
        }
    }
}
