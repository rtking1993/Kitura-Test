/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import CouchDB
import Foundation
import Kitura
import LoggerAPI

public class App {

  var client: CouchDBClient?
  var database: Database?
  
  let router = Router()
  
  private func postInit() {
    let connectionProperties = ConnectionProperties(host: "localhost", port: 5984, secured: false)
    client = CouchDBClient(connectionProperties: connectionProperties)
    client!.dbExists("acronyms") { exists, _ in
      guard exists else {
        self.createNewDatabase()
        return
      }
      Log.info("Acronyms database located - loading...")
      self.finalizeRoutes(with: Database(connProperties: connectionProperties, dbName: "acronyms"))
    }
  }
  
  private func createNewDatabase() {
    Log.info("Database does not exist - creating new database")
    client?.createDB("acronyms") { database, error in
      guard let database = database else {
        let errorReason = String(describing: error?.localizedDescription)
        Log.error("Could not create new database: (\(errorReason)) - acronym routes not created")
        return
      }
      self.finalizeRoutes(with: database)
    }
  }
  
  private func finalizeRoutes(with database: Database) {
    self.database = database
    initializeAcronymRoutes(app: self)
    Log.info("Acronym routes created")
  }
  
  public func run() {
    postInit()
    Kitura.addHTTPServer(onPort: 8080, with: router)
    Kitura.run()
  }
}
