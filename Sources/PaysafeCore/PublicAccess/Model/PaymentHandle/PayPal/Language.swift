//
//  Language.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

// swiftlint:disable identifier_name
/// Language
public enum Language: Encodable {
    /// AT
    case AT
    /// AU
    case AU
    /// BE
    case BE
    /// BR
    case BR
    /// CA
    case CA
    /// CH
    case CH
    /// CN
    case CN
    /// DE
    case DE
    /// ES
    case ES
    /// FR
    case FR
    /// GB
    case GB
    /// IT
    case IT
    /// NL
    case NL
    /// PL
    case PL
    /// PT
    case PT
    /// RU
    case RU
    /// US
    case US
    /// da_DK
    case da_DK
    /// he_IL
    case he_IL
    /// id_ID
    case id_ID
    /// ja_JP
    case ja_JP
    /// no_NO
    case no_NO
    /// pt_BR
    case pt_BR
    /// ru_RU
    case ru_RU
    /// sv_SE
    case sv_SE
    /// th_TH
    case th_TH
    /// zh_CN
    case zh_CN
    /// zh_HK
    case zh_HK
    /// zh_TW
    case zh_TW

    /// LanguageRequest
    var request: LanguageRequest {
        switch self {
        case .AT:
            return .AT
        case .AU:
            return .AU
        case .BE:
            return .BE
        case .BR:
            return .BR
        case .CA:
            return .CA
        case .CH:
            return .CH
        case .CN:
            return .CN
        case .DE:
            return .DE
        case .ES:
            return .ES
        case .FR:
            return .FR
        case .GB:
            return .GB
        case .IT:
            return .IT
        case .NL:
            return .NL
        case .PL:
            return .PL
        case .PT:
            return .PT
        case .RU:
            return .RU
        case .US:
            return .US
        case .da_DK:
            return .da_DK
        case .he_IL:
            return .he_IL
        case .id_ID:
            return .id_ID
        case .ja_JP:
            return .ja_JP
        case .no_NO:
            return .no_NO
        case .pt_BR:
            return .pt_BR
        case .ru_RU:
            return .ru_RU
        case .sv_SE:
            return .sv_SE
        case .th_TH:
            return .th_TH
        case .zh_CN:
            return .zh_CN
        case .zh_HK:
            return .zh_HK
        case .zh_TW:
            return .zh_TW
        }
    }
}
// swiftlint:enable identifier_name
