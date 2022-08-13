//
//  main.swift
//  TestStaticServer
//
//  Created by Paul Wiseman on 13/08/2022.
//

import Foundation
import Vapor

func main() throws {
	
	let environment = try Environment.detect()
	let app = Application(environment)
	defer { app.shutdown() }
	
	StaticServer.shared.setup(withApp: app)
	
	try app.run()
	
}

try main()
