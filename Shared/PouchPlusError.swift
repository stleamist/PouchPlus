import Foundation
import Alamofire
import AuthenticationServices

extension ASWebAuthenticationSessionError: Error, LocalizedError {
    public var errorDescription: String? {
        switch self.code {
        case .canceledLogin: return "The login has been canceled."
        case .presentationContextNotProvided: return "A presentation context wasn’t provided."
        case .presentationContextInvalid: return "The presentation context was invalid."
        @unknown default: return nil
        }
    }
}

enum PouchPlusError: Error, LocalizedError {
    case commonError(CommonReason)
    case userError(UserReason)
    case developerError(DeveloperReason)
    
    enum CommonReason: Error, LocalizedError {
        case networkError(AFError)
        case webAuthenticationSessionError(Error)
        
        var errorDescription: String? {
            switch self {
            case .networkError(let error): return (error.underlyingError ?? error).localizedDescription
            case .webAuthenticationSessionError(let error as ASWebAuthenticationSessionError): return error.errorDescription
            case .webAuthenticationSessionError(let error): return error.localizedDescription
            }
        }
    }
    
    enum UserReason: Error, LocalizedError {
        
    }
    
    enum DeveloperReason: Error, LocalizedError {
        case requestTokenNotSet
        
        var errorDescription: String? {
            switch self {
            case .requestTokenNotSet: return "A request token is not set."
            }
        }
    }
    
    var errorDescription: String? {
        switch self {
        case
            .commonError(let reason as Error),
            .userError(let reason as Error),
            .developerError(let reason as Error):
                return reason.localizedDescription
        }
    }
}
