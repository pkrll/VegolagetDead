//
//  StatusCode.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
/**
 *  HTTP Status Code Enumeration.
 *  - Author: Richard Hodgkins.
 *  - Note: Small, very small changes by Ardalan Samimi.
 *  - SeeAlso: [Github.com: HTTPStatusCodes.swift](https://github.com/rhodgkins/SwiftHTTPStatusCodes/blob/master/HTTPStatusCodes.swift)
 */
enum StatusCode: Int {
  // Informational
  case `continue` = 100
  case switchingProtocols = 101
  case processing = 102
  // Success
  case ok = 200
  case created = 201
  case accepted = 202
  case nonAuthoritativeInformation = 203
  case noContent = 204
  case resetContent = 205
  case partialContent = 206
  case multiStatus = 207
  case alreadyReported = 208
  case imUsed = 226
  // Redirections
  case multipleChoices = 300
  case movedPermanently = 301
  case found = 302
  case seeOther = 303
  case notModified = 304
  case useProxy = 305
  case switchProxy = 306
  case temporaryRedirect = 307
  case permanentRedirect = 308
  // Client Errors
  case badRequest = 400
  case unauthorized = 401
  case paymentRequired = 402
  case forbidden = 403
  case notFound = 404
  case methodNotAllowed = 405
  case notAcceptable = 406
  case proxyAuthenticationRequired = 407
  case requestTimeout = 408
  case conflict = 409
  case gone = 410
  case lengthRequired = 411
  case preconditionFailed = 412
  case requestEntityTooLarge = 413
  case requestURITooLong = 414
  case unsupportedMediaType = 415
  case requestedRangeNotSatisfiable = 416
  case expectationFailed = 417
  case imATeapot = 418
  case authenticationTimeout = 419
  case unprocessableEntity = 422
  case locked = 423
  case failedDependency = 424
  case upgradeRequired = 426
  case preconditionRequired = 428
  case tooManyRequests = 429
  case requestHeaderFieldsTooLarge = 431
  case loginTimeout = 440
  case noResponse = 444
  case retryWith = 449
  case unavailableForLegalReasons = 451
  case requestHeaderTooLarge = 494
  case certError = 495
  case noCert = 496
  case httpToHTTPS = 497
  case tokenExpired = 498
  case clientClosedRequest = 499
  // Server Errors
  case internalServerError = 500
  case notImplemented = 501
  case badGateway = 502
  case serviceUnavailable = 503
  case gatewayTimeout = 504
  case httpVersionNotSupported = 505
  case variantAlsoNegotiates = 506
  case insufficientStorage = 507
  case loopDetected = 508
  case bandwidthLimitExceeded = 509
  case notExtended = 510
  case networkAuthenticationRequired = 511
  case networkTimeoutError = 599
  
  var description: String {
    return HTTPURLResponse.localizedString(forStatusCode: rawValue).capitalized
  }
  
  var isSuccess: Bool {
    return Range(200...299).contains(rawValue)
  }
  
  var isRedirection: Bool {
    return Range(300...399).contains(rawValue)
  }
  
  var isClientError: Bool {
    return Range(400...499).contains(rawValue)
  }
  
  var isServerError: Bool {
    return Range(500...599).contains(rawValue)
  }
  
}
