//
//  StaticServer.swift
//  TestStaticServer
//
//  Created by Paul Wiseman on 13/08/2022.
//

import Foundation
import Vapor

class StaticServer {
	
	static let shared = StaticServer()
	
	func setup(withApp app: Application) {
		
		app.http.server.configuration.hostname = "0.0.0.0"
		app.http.server.configuration.port = 8080
		let publicDir = Bundle.main.resourcePath ?? "/tmp"
		app.middleware.use(FileMiddleware(publicDirectory: publicDir))
		
	}
	
}
