//
//  AcmeMapTests.swift
//  AcmeMapTests
//

@testable import AcmeMap
import Cuckoo
import Nimble
import OHHTTPStubs
import Quick

class AcmeMapSpec: QuickSpec {
    override func spec() {
        afterEach {
            HTTPStubs.removeAllStubs()
        }

        describe("public interface") {
            context("when something happens") {
                it("expected behavior / value") {
                    // This is an example of a behavior-driven development test case.
                }
            }
        }
    }
}
