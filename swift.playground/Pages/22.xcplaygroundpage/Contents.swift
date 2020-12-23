import Foundation

let example = [[9,2,6,3,1], [5,8,4,7,10]]
let input = [ [30,42,25,7,29,1,16,50,11,40,4,41,3,12,8,20,32,38,31,2,44,28,33,18,10],[36,13,46,15,27,45,5,19,39,24,14,9,17,22,37,47,43,21,6,35,23,48,34,26,49]]

// part 1
//var playstate = input
//repeat {
//    let p0 = playstate[0].removeFirst()
//    let p1 = playstate[1].removeFirst()
//    if p1 > p0 {
//        playstate[1].append(contentsOf: [p1, p0])
//    } else {
//        playstate[0].append(contentsOf: [p0, p1])
//    }
//} while playstate[0].count > 0 && playstate[1].count > 0
//
//let winner = playstate.first { $0.count > 0 }!
//let score = winner.enumerated().reduce(0) { $0 + (winner.count - $1.offset) * $1.element }
//
//print(score)
// 35818

// part 2

let memoizedPlayerOneWinsRecursiveCombat = memoize(playerOneWinsRecursiveCombat)

func playerOneWinsRecursiveCombat(_ playstate: [[Int]]) -> Bool {
    var playedPlaystates = Set<Int>()
    var playstate = playstate
    repeat {
        let stateHash = playstate.hashValue
        if playedPlaystates.contains(stateHash) {
            print("player 1 won")
            return true
        }
        playedPlaystates.insert(stateHash)

        let p0 = playstate[0].removeFirst()
        let p1 = playstate[1].removeFirst()
        let playerOneWon: Bool
        if playstate[0].count < p0 || playstate[1].count < p1 {
            playerOneWon = p0 > p1
        } else {
            let subgamePlaystate: [[Int]] = [Array(playstate[0][0..<p0]), Array(playstate[1][0..<p1])]
            playerOneWon = memoizedPlayerOneWinsRecursiveCombat(subgamePlaystate)
        }
        if playerOneWon {
            playstate[0].append(contentsOf: [p0, p1])
        } else {
            playstate[1].append(contentsOf: [p1, p0])
        }
    } while playstate[0].count > 0 && playstate[1].count > 0
    let playerOneWon = playstate[0].count > 0
    let winner = playerOneWon ? playstate[0] : playstate[1]
    print(winner.enumerated().reduce(0) { $0 + (winner.count - $1.offset) * $1.element })
    print("The winner of this game is player \(playerOneWon ? "1" : "2")")
    return playerOneWon
}

memoizedPlayerOneWinsRecursiveCombat(input)
// 34771
