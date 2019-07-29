import UIKit

struct Match {
    let slug: String
    let date: Date
    let homeTeamName: String
    let awayTeamName: String
}
// Return the closest match index to [dateTapped], return 0 otherwise,
// [matchList] is sorted by date.
// Runs in at worst logarithmic time, making O(log n) comparisons
// I wouldn't use 0 as a return value for the nil case as it could be a valid index
func findClosestMatch(dateTapped: Date, matchList: [Match]) -> Int {
    return matchList.binarySearchIndexOfClosest(to: dateTapped) ?? 0
}

extension Array where Element == Match {

    func binarySearchIndexOfClosest(to date: Date,
                                    range: Range<Int>? = nil) -> Int? {
        let initialRange: Range<Int>
        if let range = range {
            initialRange = range
        } else {
            initialRange = 0..<count - 1
        }
        guard self.isEmpty == false else { return nil }

        if initialRange.upperBound == initialRange.lowerBound {
            return initialRange.lowerBound
        }
        let center = count / 2
        let lhsPatition = Array(self[0..<center])
        let rhsPartition = Array(self[center..<count])

        let lhsInterval = (lhsPatition.last?.date).absTimeIntervalSince(date,
                                                                        or: Double.greatestFiniteMagnitude)

        let rhsInterval = (rhsPartition.first?.date).absTimeIntervalSince(date,
                                                                          or: Double.greatestFiniteMagnitude)
        if lhsInterval < rhsInterval {
            return lhsPatition.binarySearchIndexOfClosest(to: date,
                                                          range: initialRange.dropLast(count - lhsPatition.count))
        } else {
            return rhsPartition.binarySearchIndexOfClosest(to: date,
                                                           range: initialRange.dropFirst(count - rhsPartition.count))
        }
    }
}

extension Optional where Wrapped == Date {
    func absTimeIntervalSince(_ other: Date?, or defaultInterval: TimeInterval) -> TimeInterval {
        guard let date = self, let other = other else {
            return defaultInterval
        }
        return abs(date.timeIntervalSince(other))
    }
}

extension String {
    var date: Date? {
        return ISO8601DateFormatter().date(from: "\(self)T00:00:00Z")
    }
}

import XCTest

class SearchTestCase: XCTestCase {

    func testSearchReturnsIndexesForAllDates() {
        let matchList = [
            Match(slug: "1", date: "2019-12-1".date!, homeTeamName: "H4", awayTeamName: "A4"),
            Match(slug: "2", date: "2019-12-10".date!, homeTeamName: "H1", awayTeamName: "A2"),
            Match(slug: "3", date: "2019-12-11".date!, homeTeamName: "H4", awayTeamName: "A4"),
            Match(slug: "4", date: "2019-12-20".date!, homeTeamName: "H4", awayTeamName: "A4"),
            Match(slug: "5", date: "2019-12-30".date!, homeTeamName: "H5", awayTeamName: "A5")
        ]

        XCTAssertEqual(findClosestMatch(dateTapped: "2019-11-30".date!, matchList: matchList), 0)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-01".date!, matchList: matchList), 0)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-02".date!, matchList: matchList), 0)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-03".date!, matchList: matchList), 0)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-04".date!, matchList: matchList), 0)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-05".date!, matchList: matchList), 0)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-06".date!, matchList: matchList), 1)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-07".date!, matchList: matchList), 1)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-08".date!, matchList: matchList), 1)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-09".date!, matchList: matchList), 1)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-10".date!, matchList: matchList), 1)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-11".date!, matchList: matchList), 2)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-12".date!, matchList: matchList), 2)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-13".date!, matchList: matchList), 2)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-14".date!, matchList: matchList), 2)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-15".date!, matchList: matchList), 2)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-16".date!, matchList: matchList), 3)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-17".date!, matchList: matchList), 3)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-18".date!, matchList: matchList), 3)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-19".date!, matchList: matchList), 3)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-20".date!, matchList: matchList), 3)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-21".date!, matchList: matchList), 3)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-22".date!, matchList: matchList), 3)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-23".date!, matchList: matchList), 3)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-24".date!, matchList: matchList), 3)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-25".date!, matchList: matchList), 4)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-26".date!, matchList: matchList), 4)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-27".date!, matchList: matchList), 4)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-28".date!, matchList: matchList), 4)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-29".date!, matchList: matchList), 4)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-30".date!, matchList: matchList), 4)
        XCTAssertEqual(findClosestMatch(dateTapped: "2019-12-31".date!, matchList: matchList), 4)
        XCTAssertEqual(findClosestMatch(dateTapped: "2020-01-01".date!, matchList: matchList), 4)
    }
}

SearchTestCase.defaultTestSuite.run()

