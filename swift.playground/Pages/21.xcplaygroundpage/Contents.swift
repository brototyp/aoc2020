import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let lines = (try! String(contentsOf: file)).components(separatedBy: "\n")

let mappedLines = lines.compactMap { line -> ([String], [String])? in
    let c = line.components(separatedBy: " (contains ")
    guard c.count == 2 else { return nil }
    let ingredients = c[0].components(separatedBy: " ")
    let allergenes = c[1].prefix(c[1].count - 1).components(separatedBy: ", ")
    return (ingredients, allergenes)
}

let allergenesToPossibleIngredients: [String: Set<String>] = mappedLines.reduce(into: [String: Set<String>]()) {
    for allergene in $1.1 {
        if let ingredientSet = $0[allergene] {
            $0[allergene] = ingredientSet.intersection($1.0)
        } else {
            $0[allergene] = Set($1.0)
        }
    }
}

let allergenicIngredients = Set(allergenesToPossibleIngredients.values.flatMap { $0 })

var exactAllergenesToIngredients = allergenesToPossibleIngredients
repeat {
    let matchedIngredients = Set(exactAllergenesToIngredients.values.filter { $0.count == 1}.flatMap { $0 })
    exactAllergenesToIngredients = exactAllergenesToIngredients.mapValues { ingredients -> Set<String> in
        guard ingredients.count > 1 else { return ingredients }
        return ingredients.subtracting(matchedIngredients)
    }
    exactAllergenesToIngredients.values.filter { $0.count == 1}.count
} while exactAllergenesToIngredients.values.filter { $0.count == 1}.count < allergenicIngredients.count

let allergenesToIngredient = exactAllergenesToIngredients.mapValues { $0.first! }

// part 1
let allergeneFreeIngredientsAppearance = mappedLines.flatMap { $0.0 }.filter { !allergenesToIngredient.values.contains($0) }
print(allergeneFreeIngredientsAppearance.count)
// 1945

// part 2
let ingredientsSortedByAllergenes = allergenesToIngredient.map { ($0.value, $0.key) }.sorted { $0.1 < $1.1 }.map { $0.0 }
print(ingredientsSortedByAllergenes.joined(separator: ","))
// pgnpx,srmsh,ksdgk,dskjpq,nvbrx,khqsk,zbkbgp,xzb

