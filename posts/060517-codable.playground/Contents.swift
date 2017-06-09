import Foundation

// I just wanted to point out one little gotcha with the Swift 4 Codable protocol
// that wasn't so obvious for me at first.

// TLDR: `encode(_:)` and `decode(_:)` can take an Array<Element>.self where Element is Codable

// Let's say we have a model like so:

struct Person: Codable {
    let name: String
    let age: Int
}

// Then we want to encode one instance of this model:

let marly = Person(name: "Marley", age: 33)
let encodedMarlyData = try JSONEncoder().encode(marly)

// We can then write this data to disk:

let docsDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
let marlyURL = docsDir.appendingPathComponent("marly")
try encodedMarlyData.write(to: marlyURL)

// Then we can get the data back out:

let marlyData = try Data(contentsOf: marlyURL)
let decodedMarly = try JSONDecoder().decode(Person.self, from: marlyData)
print(decodedMarly) // prints: `Person(name: "Marley", age: 33)`

// This is super easy and cool!
// But a lot of the time we want to save an Array of our model.
// How do we do that with Codable?
// Like so:

let persons: [Person] = [Person(name: "Marly", age: 33),
                         Person(name: "Steph", age: 31)]

let personsURL = docsDir.appendingPathComponent("persons")

// encode(_:) can take [Person].self
// This was unclear at first
try JSONEncoder().encode(persons.self).write(to: personsURL)
let personsData = try Data(contentsOf: personsURL)

// decode(_:) can also take [Person].self
// This was also unclear at first
let decodedPersons = try JSONDecoder().decode([Person].self, from: personsData)
decodedPersons.forEach({ print($0) }) // prints: `Person(name: "Marly", age: 33)\nPerson(name: "Steph", age: 31)`

// Pretty cool! I hope this explains how to use Swift 4 Codable in at least one useful way.
// Let me know @garricn if you have any questions.
