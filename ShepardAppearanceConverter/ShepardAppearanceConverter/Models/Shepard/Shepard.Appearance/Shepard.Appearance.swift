//
//  Shepard.Appearance.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/19/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import Foundation

extension Shepard {

    public struct Appearance {
        
        static let SampleAppearance = "XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.X "
    
        public enum Attributes {
            case
            //face
            FacialStructure, SkinTone, Complexion, Scar,
            //head
            NeckThickness, FaceSize, CheekWidth, CheekBones, CheekGaunt, EarsSize, EarsOrientation,
            //eyes
            EyeShape, EyeHeight, EyeWidth, EyeDepth, BrowDepth, BrowHeight, IrisColor,
            //jaw
            ChinHeight, ChinDepth, ChinWidth, JawWidth,
            //mouth
            MouthShape, MouthDepth, MouthWidth, MouthLipSize, MouthHeight,
            //nose
            NoseShape, NoseHeight, NoseDepth,
            //hair
            HairColor, Hair, Brow, BrowColor, Beard, FacialHairColor,
            //makeup
            BlushColor, LipColor, EyeShadowColor
            
            var title: String {
                switch self {
                    case .FacialStructure : return "Facial Structure"
                    case .SkinTone : return "Skin Tone"
                    case .Complexion : return "Complexion"
                    case .Scar : return "Scar"
                    case .NeckThickness : return "Neck Thickness"
                    case .FaceSize : return "Face Size"
                    case .CheekWidth : return "Cheek Width"
                    case .CheekBones : return "Cheek Bones"
                    case .CheekGaunt : return "Cheek Gaunt"
                    case .EarsSize : return "Ears Size"
                    case .EarsOrientation : return "Ears Orientation"
                    case .EyeShape : return "Eye Shape"
                    case .EyeHeight : return "Eye Height"
                    case .EyeWidth : return "Eye Width"
                    case .EyeDepth : return "Eye Depth"
                    case .BrowDepth : return "Brow Depth"
                    case .BrowHeight : return "Brow Height"
                    case .IrisColor : return "Iris Color"
                    case .ChinHeight : return "Chin Height"
                    case .ChinDepth : return "Chin Depth"
                    case .ChinWidth : return "Chin Width"
                    case .JawWidth : return "Jaw Width"
                    case .MouthShape : return "Mouth Shape"
                    case .MouthDepth : return "Mouth Depth"
                    case .MouthWidth : return "Mouth Width"
                    case .MouthLipSize : return "Mouth Lip Size"
                    case .MouthHeight : return "Mouth Height"
                    case .NoseShape : return "Nose Shape"
                    case .NoseHeight : return "Nose Height"
                    case .NoseDepth : return "Nose Depth"
                    case .HairColor : return "Hair Color"
                    case .Hair : return "Hair"
                    case .Brow : return "Brow"
                    case .BrowColor : return "Brow Color"
                    case .Beard : return "Beard"
                    case .FacialHairColor : return "Facial Hair Color"
                    case .BlushColor : return "Blush Color"
                    case .LipColor : return "Lip Color"
                    case .EyeShadowColor : return "Eye Shadow Color"
                }
            }
        }
        
        public enum AttributeGroups {
            case FacialStructure, Head, Eyes, Jaw, Mouth, Nose, Hair, Makeup
            var title: String {
                switch self {
                case .FacialStructure: return "Facial Structure"
                case .Head: return "Head"
                case .Eyes: return "Eyes"
                case .Jaw: return "Jaw"
                case .Mouth: return "Mouth"
                case .Nose: return "Nose"
                case .Hair: return "Hair"
                case .Makeup: return "Makeup"
                }
            }
        }
        
        public static let sortedAttributeGroups: [AttributeGroups] = [
            .FacialStructure, .Head, .Eyes, .Jaw, .Mouth, .Nose, .Hair, .Makeup
        ]
        
        public static let attributes: [Gender: [Game: [Attributes]]] = [
            .Female: [
                .Game1: [
                .FacialStructure, .SkinTone, .Complexion, .Scar,
                .NeckThickness, .FaceSize, .CheekWidth, .CheekBones, .CheekGaunt, .EarsSize, .EarsOrientation,
                .EyeShape, .EyeHeight, .EyeWidth, .EyeDepth, .BrowDepth, .BrowHeight, .IrisColor,
                .ChinHeight, .ChinDepth, .ChinWidth, .JawWidth,
                .MouthShape, .MouthDepth, .MouthWidth, .MouthLipSize, .MouthHeight,
                .NoseShape, .NoseHeight, .NoseDepth,
                .HairColor, .Hair, .Brow, .BrowColor,
                .BlushColor, .LipColor, .EyeShadowColor,
                ],
                .Game2: [
                .FacialStructure, .SkinTone, .Complexion,
                .NeckThickness, .FaceSize, .CheekWidth, .CheekBones, .CheekGaunt, .EarsSize, .EarsOrientation,
                .EyeShape, .EyeHeight, .EyeWidth, .EyeDepth, .BrowDepth, .BrowHeight, .IrisColor,
                .ChinHeight, .ChinDepth, .ChinWidth, .JawWidth,
                .MouthShape, .MouthDepth, .MouthWidth, .MouthLipSize, .MouthHeight,
                .NoseShape, .NoseHeight, .NoseDepth,
                .HairColor, .Hair, .Brow, .BrowColor,
                .BlushColor, .LipColor, .EyeShadowColor,
                ],
                .Game3: [
                .FacialStructure, .SkinTone, .Complexion,
                .NeckThickness, .FaceSize, .CheekWidth, .CheekBones, .CheekGaunt, .EarsSize, .EarsOrientation,
                .EyeShape, .EyeHeight, .EyeWidth, .EyeDepth, .BrowDepth, .BrowHeight, .IrisColor,
                .ChinHeight, .ChinDepth, .ChinWidth, .JawWidth,
                .MouthShape, .MouthDepth, .MouthWidth, .MouthLipSize, .MouthHeight,
                .NoseShape, .NoseHeight, .NoseDepth,
                .HairColor, .Hair, .Brow, .BrowColor,
                .BlushColor, .LipColor, .EyeShadowColor,
                ],
            ],
            .Male: [
                .Game1: [
                .FacialStructure, .SkinTone, .Complexion, .Scar,
                .NeckThickness, .FaceSize, .CheekWidth, .CheekBones, .CheekGaunt, .EarsSize, .EarsOrientation,
                .EyeShape, .EyeHeight, .EyeWidth, .EyeDepth, .BrowDepth, .BrowHeight, .IrisColor,
                .ChinHeight, .ChinDepth, .ChinWidth, .JawWidth,
                .MouthShape, .MouthDepth, .MouthWidth, .MouthLipSize, .MouthHeight,
                .NoseShape, .NoseHeight, .NoseDepth,
                .Beard, .Brow, .Hair, .HairColor, .FacialHairColor,
                ],
                .Game2: [
                .FacialStructure, .SkinTone, .Complexion,
                .NeckThickness, .FaceSize, .CheekWidth, .CheekBones, .CheekGaunt, .EarsSize, .EarsOrientation,
                .EyeShape, .EyeHeight, .EyeWidth, .EyeDepth, .BrowDepth, .BrowHeight, .IrisColor,
                .ChinHeight, .ChinDepth, .ChinWidth, .JawWidth,
                .MouthShape, .MouthDepth, .MouthWidth, .MouthLipSize, .MouthHeight,
                .NoseShape, .NoseHeight, .NoseDepth,
                .Hair, .Beard, .Brow, .HairColor, .FacialHairColor,

                ],
                .Game3: [
                .FacialStructure, .SkinTone, .Complexion,
                .NeckThickness, .FaceSize, .CheekWidth, .CheekBones, .CheekGaunt, .EarsSize, .EarsOrientation,
                .EyeShape, .EyeHeight, .EyeWidth, .EyeDepth, .BrowDepth, .BrowHeight, .IrisColor,
                .ChinHeight, .ChinDepth, .ChinWidth, .JawWidth,
                .MouthShape, .MouthDepth, .MouthWidth, .MouthLipSize, .MouthHeight,
                .NoseShape, .NoseHeight, .NoseDepth,
                .Hair, .Beard, .Brow, .HairColor, .FacialHairColor,
                ],
            ]
        ]
        
        public static let slidersMax : [Gender: [Attributes: [Game: Int]]] = {
            func sliderMaxValues(value1: Int, _ value2: Int, _ value3: Int) -> [Game: Int] {
                return [.Game1: value1, .Game2: value2, .Game3: value3]
            }
            return [
                .Female: [
                    .FacialStructure: sliderMaxValues(9,9,9),
                    .SkinTone: sliderMaxValues(6,6,6),
                    .Complexion: sliderMaxValues(3,3,3),
                    .Scar: sliderMaxValues(6,0,0),
                    .NeckThickness: sliderMaxValues(31,31,31),
                    .FaceSize: sliderMaxValues(31,31,31),
                    .CheekWidth: sliderMaxValues(31,31,31),
                    .CheekBones: sliderMaxValues(31,31,31),
                    .CheekGaunt: sliderMaxValues(31,31,31),
                    .EarsSize: sliderMaxValues(31,31,31),
                    .EarsOrientation: sliderMaxValues(31,31,31),
                    .EyeShape: sliderMaxValues(9,9,9),
                    .EyeHeight: sliderMaxValues(31,31,31),
                    .EyeWidth: sliderMaxValues(31,31,31),
                    .EyeDepth: sliderMaxValues(31,31,31),
                    .BrowDepth: sliderMaxValues(31,31,31),
                    .BrowHeight: sliderMaxValues(31,31,31),
                    .IrisColor: sliderMaxValues(13,13,13),
                    .ChinHeight: sliderMaxValues(31,31,31),
                    .ChinDepth: sliderMaxValues(31,31,31),
                    .ChinWidth: sliderMaxValues(31,31,31),
                    .JawWidth: sliderMaxValues(31,31,31),
                    .MouthShape: sliderMaxValues(10,10,10),
                    .MouthDepth: sliderMaxValues(31,31,31),
                    .MouthWidth: sliderMaxValues(31,31,31),
                    .MouthLipSize: sliderMaxValues(31,31,31),
                    .MouthHeight: sliderMaxValues(31,31,31),
                    .NoseShape: sliderMaxValues(9,9,12),
                    .NoseHeight: sliderMaxValues(31,31,31),
                    .NoseDepth: sliderMaxValues(31,31,31),
                    .HairColor: sliderMaxValues(7,7,16),
                    .Hair: sliderMaxValues(10,10,13),
                    .Brow: sliderMaxValues(16,16,16),
                    .BrowColor: sliderMaxValues(6,6,16),
                    .BlushColor: sliderMaxValues(6,6,10),
                    .LipColor: sliderMaxValues(7,7,7),
                    .EyeShadowColor: sliderMaxValues(7,11,11),
                ],
                .Male: [
                    .FacialStructure: sliderMaxValues(6,6,6),
                    .SkinTone: sliderMaxValues(6,6,6),
                    .Complexion: sliderMaxValues(3,3,3),
                    .Scar: sliderMaxValues(6,0,0),
                    .NeckThickness: sliderMaxValues(31,31,31),
                    .FaceSize: sliderMaxValues(31,31,31),
                    .CheekWidth: sliderMaxValues(31,31,31),
                    .CheekBones: sliderMaxValues(31,31,31),
                    .CheekGaunt: sliderMaxValues(31,31,31),
                    .EarsSize: sliderMaxValues(31,31,31),
                    .EarsOrientation: sliderMaxValues(31,31,31),
                    .EyeShape: sliderMaxValues(8,8,8),
                    .EyeHeight: sliderMaxValues(31,31,31),
                    .EyeWidth: sliderMaxValues(31,31,31),
                    .EyeDepth: sliderMaxValues(31,31,31),
                    .BrowDepth: sliderMaxValues(31,31,31),
                    .BrowHeight: sliderMaxValues(31,31,31),
                    .IrisColor: sliderMaxValues(13,13,16),
                    .ChinHeight: sliderMaxValues(31,31,31),
                    .ChinDepth: sliderMaxValues(31,31,31),
                    .ChinWidth: sliderMaxValues(31,31,31),
                    .JawWidth: sliderMaxValues(31,31,31),
                    .MouthShape: sliderMaxValues(9,9,9),
                    .MouthDepth: sliderMaxValues(31,31,31),
                    .MouthWidth: sliderMaxValues(31,31,31),
                    .MouthLipSize: sliderMaxValues(31,31,31),
                    .MouthHeight: sliderMaxValues(31,31,31),
                    .NoseShape: sliderMaxValues(12,12,12),
                    .NoseHeight: sliderMaxValues(31,31,31),
                    .NoseDepth: sliderMaxValues(31,31,31),
                    .Beard: sliderMaxValues(14,14,14),
                    .Brow: sliderMaxValues(7,7,7),
                    .Hair: sliderMaxValues(8,8,16),
                    .HairColor: sliderMaxValues(7,7,13),
                    .FacialHairColor: sliderMaxValues(6,6,13),
                ]
            ]
        }()
        public static let attributeGroups: [Gender: [AttributeGroups: [Attributes]]] = [
            .Female: [
                .FacialStructure: [.FacialStructure, .SkinTone, .Complexion, .Scar],
                .Head: [.NeckThickness, .FaceSize, .CheekWidth, .CheekBones, .CheekGaunt, .EarsSize, .EarsOrientation],
                .Eyes: [.EyeShape, .EyeHeight, .EyeWidth, .EyeDepth, .BrowDepth, .BrowHeight, .IrisColor],
                .Jaw: [.ChinHeight, .ChinDepth, .ChinWidth, .JawWidth],
                .Mouth: [.MouthShape, .MouthDepth, .MouthWidth, .MouthLipSize, .MouthHeight],
                .Nose: [.NoseShape, .NoseHeight, .NoseDepth],
                .Hair: [.HairColor, .Hair, .Brow, .BrowColor],
                .Makeup: [.BlushColor, .LipColor, .EyeShadowColor],
            ],
            .Male: [
                .FacialStructure: [.FacialStructure, .SkinTone, .Complexion, .Scar],
                .Head: [.NeckThickness, .FaceSize, .CheekWidth, .CheekBones, .CheekGaunt, .EarsSize, .EarsOrientation],
                .Eyes: [.EyeShape, .EyeHeight, .EyeWidth, .EyeDepth, .BrowDepth, .BrowHeight, .IrisColor],
                .Jaw: [.ChinHeight, .ChinDepth, .ChinWidth, .JawWidth],
                .Mouth: [.MouthShape, .MouthDepth, .MouthWidth, .MouthLipSize, .MouthHeight],
                .Nose: [.NoseShape, .NoseHeight, .NoseDepth],
                .Hair: [.Beard, .Brow, .Hair, .HairColor, .FacialHairColor],
            ],
        ]
        
        public static let expectedCodeLength: [Gender: [Game: Int]] = [
            .Male: [.Game1: 35, .Game2: 34, .Game3: 34],
            .Female: [.Game1: 37, .Game2: 36, .Game3: 36]
        ]
        
        public var contents: [Attributes: Int] = [:]
        public var gender: Gender = .Male
        public var game: Game = .Game1
        public var initError: String?
        public static let CodeLengthIncorrect = "Warning: code length (%d) does not match game selected (expected %d)"

        public init(game: Game) {
            self.game = game
        }
        public init(_ appearance: String, fromGame: Game = .Game1, withGender: Shepard.Gender = .Male) {
            //ME1 format?
            contents = [Attributes: Int]()
            self.game = fromGame
            let oldAppearanceCode = Formatting.unformatCode(appearance)
            if !oldAppearanceCode.isEmpty && oldAppearanceCode.characters.count != Appearance.expectedCodeLength[gender]?[game] {
                let reportLength = Appearance.expectedCodeLength[gender]?[game] ?? 0
                initError = String(format: Appearance.CodeLengthIncorrect, oldAppearanceCode.characters.count, reportLength)
            }
            for element in oldAppearanceCode.characters {
                if let attributeList = Appearance.attributes[gender]?[game] where attributeList.count > contents.count {
                    let attribute = attributeList[contents.count]
                    contents[attribute] = Formatting.unformatAttribute(element)
                }
            }
            print(appearance)
            print(oldAppearanceCode)
        }
        
        /// Converts attribute values between games.
        public mutating func convert(toGame toGame: Game) {
            alerts = [:]
            notices = [:]
            var newAppearance = [Attributes: Int]()
            if let sourceAttributes = Appearance.attributes[gender]?[game] {
                for attribute in sourceAttributes {
                    var attributeValue = contents[attribute]
                    if attributeValue == nil { // not set, skip
                        continue
                    }
                    // game 1 limited on makeup colors
                    if attribute == .EyeShadowColor && toGame == .Game1 {
                        if attributeValue == 8 { // purple ~= pink/purple
                            notices[attribute] = Appearance.EyeShadowColorConverted
                            attributeValue = 2
                        } else if attributeValue == 9 { // fuschia ~= pink
                            notices[attribute] = Appearance.EyeShadowColorConverted
                            attributeValue = 3
                        } else if attributeValue == 10 { // marigold ~= coral
                            notices[attribute] = Appearance.EyeShadowColorConverted
                            attributeValue = 4
                        } else if attributeValue == 11 { // green
                            alerts[attribute] = Appearance.EyeShadowColorNotFound
                            attributeValue = 0
                        }
                    }
                    if attribute == .BlushColor && toGame == .Game1 {
                        notices[attribute] = Appearance.BlushColorConverted
                        if attributeValue > 5 {
                            attributeValue = 5
                        }
                    }
                    // game 3 has extra hair colors
                    if (attribute == .HairColor || attribute == .BrowColor || attribute == .FacialHairColor) && game == .Game3 {
                        if attributeValue == 15 { // purple
                            alerts[attribute] = Appearance.HairColorNotFound
                            attributeValue = 0
                        } else if attributeValue > 10 { // reds -> red
                            notices[attribute] = Appearance.HairColorConverted
                            attributeValue = 3
                        } else if attributeValue > 6 { // grays
                            alerts[attribute] = Appearance.HairColorNotFound
                            attributeValue = 0
                        }
                    }
                    // game 3 sorted hair color differently
                    if attribute == .HairColor && toGame == .Game3 {
                        if attributeValue == 3 { // red
                            notices[attribute] = Appearance.HairColorConverted
                            attributeValue = 12
                        }
                    }
                    // game 3 has extra hair styles
                    if attribute == .Hair && game == .Game3 {
                        if gender == .Male && (attributeValue == 7 || attributeValue > 10) { // mohawk, other new styles
                            alerts[attribute] = Appearance.HairNotFound
                            attributeValue = 0
                        }
                        if gender == .Male && (attributeValue == 8 || attributeValue == 9) { // mohawk moved things out of place
                            attributeValue = attributeValue! - 1
                        }
                        if gender == .Female && attributeValue > 9 { // rachel, knot, 60s
                            alerts[attribute] = Appearance.HairNotFound
                            attributeValue = 0
                        }
                    }
                    newAppearance[attribute] = attributeValue
                }
            }
            contents = newAppearance
            game = toGame
        }
        
        /// Alert/Notice messages on conversion failures
        public var alerts = [Attributes: String]()
        public var notices: [Attributes: String] = [:]
        public static var defaultNotices: [Attributes: String] = [.Scar: "Scar has no equivalent in Game 2 or 3"]
        internal static let HairColorNotFound = "Hair color has no equivalent"
        internal static let HairColorConverted = "Hair color was changed to an approximate equivalent"
        internal static let EyeShadowColorNotFound = "Eyeshadow color has no equivalent"
        internal static let EyeShadowColorConverted = "Eyeshadow color was changed to an approximate equivalent"
        internal static let HairNotFound = "Hair style not found"
        internal static let BlushColorConverted = "Blush colors are too subtle to determine comparison"
        
        /// Returns a formatted code, of the typical XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.X format.
        public func format() -> String {
            var newAppearance = String()
            if let sourceAttributes = Appearance.attributes[gender]?[game] {
                newAppearance = sourceAttributes.reduce("") { $0 + Formatting.formatAttribute(contents[$1]) }
            }
            return Formatting.formatCode(newAppearance)
        }
        
    
        public struct Formatting {
        
            public static let AvailableAlphabet = "123456789ABCDEFGHIJKLMNPQRSTUVW"
            
            public static func formatAttribute(attributeValue: Int?) -> String {
                if attributeValue > 0 {
                    return AvailableAlphabet[attributeValue! - 1] // starts at 1, not 0
                }
                return "X"
            }
            
            public static func unformatAttribute(attributeString: Character?) -> Int {
                return (AvailableAlphabet.intIndexOf(attributeString ?? "X") ?? -1) + 1
            }
            
            /// Unformats a string from XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.X into allowed characters
            public static func unformatCode(code: String) -> String {
                return code.uppercaseString.onlyCharacters(AvailableAlphabet + "X")
            }
            
            /// Formats an alphanumeric string into the XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.X format
            public static func formatCode(code: String!, lastCode: String! = nil) -> String {
                //strip to valid characters
                var unformattedCode: String! = unformatCode(code)
                if unformattedCode.isEmpty {
                    return ""
                }
                if lastCode != nil {
                    //if characters removed by user, change to remove valid characters instead of other formatting
                    let lastUnformattedCode = unformatCode(lastCode)
                    let requestedSubtractChars = lastCode.length - code.length
                    let actualSubtractChars = max(0, lastUnformattedCode.length - unformattedCode.length)
                    if requestedSubtractChars > 0 && actualSubtractChars < requestedSubtractChars {
                        let subtractChars = requestedSubtractChars - actualSubtractChars
                        unformattedCode = subtractChars >= unformattedCode.length  ? "" : unformattedCode.stringFrom(0, to: -1 * subtractChars)
                    }
                }
                //add formatting
                var formattedCode = unformattedCode.stringByReplacingOccurrencesOfString("([^\\.]{3})", withString: "$1.", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                if formattedCode.stringFrom(-1) == "." {
                    formattedCode = formattedCode.stringFrom(0, to: -1)
                }
                return formattedCode
            }
            
            public static func isEmpty(code: String) -> Bool {
                return code.uppercaseString.onlyCharacters(AvailableAlphabet).isEmpty
            }
        }
    }

// Notes on conversions
// FEMALE
// Lip: Matte plain, Pale pink, Vivid pink, Gold, Bright coral, Black, Gloss plain
// Eyeshadow
// ME2: Plain, Pink w/Purple liner, Pink w/Pink liner, Coral, Red, Black, Brown, Purple/Violet, Fuschia, Marigold, Leaf
// ME1: plain, purple, pink, orange, red, black, brown, plain with liner
// Haircolor:
// ME1: Blond, Dark Blond, Red, Light Brown, Brown, Dark Brown, Black
// ME3: Blond, Dark Blond, Light Brown, Brown, Dark Brown, Black, Dark Gray, Gray, Light Gray, Silver, Dark Red, Red, Bright Red, Fuschia, Purple, Dark Purple Red
// Hair:
// ME1: Shaved, Shoulder-length, Pixie, Bob, Knot (nape), Ragged Bob, French Twist, Bun (back), Bun (top), Pony tail
// ME3: Shaved, Shoulder-length, Pixie, Bob, Pulled back (hidden), Ragged Bob, French Twist, Bun (back), Bun (top), Pony tail, Short "Rachel", Bun (nape), 60s bob
// MALE
// Eye color
// ME3: Light blue, blue, Green light green, Gray, blue, dark blue, vivid blue, light brown, yellow/brown, brown, orange/brown, brown, black, red, silver
// Hair
// TODO verify the caesars - I think they were switched
// ME1: Shaved, Short styled up, Caesar, Buzz, Short slicked caesar, shaved sides, short with front styled up, bald
// ME3: Shaved, Short styled up, Caesar, Buzz, Short slicked caesar, shaved sides, mohawk, short with front styled up, bald, shaved 2, messy caesar, bald top, short with spiky front, slicked to right, slicked down messy, receding
// Haircolor:
// ME1: Blond, Dark Blond, Red, Light Brown, Brown, Dark Brown, Black
// ME3: Blond, Dark Blond, Light Brown, Brown, Dark Brown, Black, Dark Gray, Gray, Light Gray, Silver, Dark Red, Red, Bright Red
}