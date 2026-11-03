//
//  CASMolocoUtils.swift
//  CASMoloco
//
//  Copyright © 2026 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import MolocoSDK

func CASErrorFromMoloco(_ error: Error?) -> AdError {
    guard let error else {
        return AdError(.internalError)
    }
    
    if let tokenError = error as? MolocoBidTokenError {
         switch tokenError {
         case .noResponse:
             return AdError.noFill
         case .notSupported:
             return AdError(.rejected, error.localizedDescription)
         case .requestError:
             return AdError.noConnection
         case .from(let originalError):
             return CASErrorFromMoloco(originalError)
         case .invalidServerTokenFormat,
              .invalidJwtToken:
             return AdError(.configurationError, error.localizedDescription)
             
         default:
             return AdError(.internalError, error.localizedDescription)
         }
     }
    
    if let nativeError = error as? MolocoNativeAdError {
        switch nativeError {
        case .placementNeedsCustomLayout:
            return AdError(.configurationError, error.localizedDescription)
        default:
            return AdError(.internalError)
        }
    }
    
    if let molocoError = error as? MolocoError {
        switch molocoError {
        case .adLoadFailedSDKNotInit, .sdkInit:
            return AdError(.notInitialized, error.localizedDescription)
        case .sdkInvalidConfiguration:
            return AdError(.configurationError, error.localizedDescription)
        case .adLoadFailed:
            return AdError.noFill
        case .adShowFailedAlreadyDisplaying:
            return AdError(.alreadyDisplayed)
        case .adShowFailedNotLoaded:
            return AdError.notReady
        default:
            return AdError(.internalError, error.localizedDescription)
        }
    }
    
    return AdError(.internalError, error.localizedDescription)
}
