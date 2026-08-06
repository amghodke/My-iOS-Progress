import Foundation

/*
 
 Memory Leak Playground
 Normal deallocation
 retain cycle and
 and a weak fix
 
 */

// MARK: Example 1 : Normal Object that gets deallocated
print("------Example 1 : Normal Object Deallocation ------")
class Person {
    var name: String
    init(name: String) {
        self.name = name
        print("\(name) is initialized")
    }
    deinit {
        print("\(name) is deallocated")	
    }
}

func runExample1(){
    var person : Person? = Person(name: "Amit Ghodke")
    person = nil // ref count == 0 deinit called automatically
}

runExample1()
print("------------------------------------------")

// MARK: Example 2 : Retain cycle
print("------ Example 2 : Retain cycle ------")

class Human {
    var name: String
    var apartment : Apartment?
    init(name: String) {
        self.name = name
        print("\(name) is initialized")
    }
    deinit {
        print("\(name) is deallocated")
    }
}

class Apartment {
    var flat_number : String
    var tenant: Human?
    init(flat_number: String, ){
        self.flat_number = flat_number
        print("flat number \(flat_number) is initialized")
    }
    deinit {
        print("flat number \(flat_number) is deallocated")
    }
}

func runExample2(){
    var person : Human? = Human(name: "Amit")
    var apartment : Apartment? = Apartment(flat_number: "101")
    apartment?.tenant = person
    person?.apartment = apartment
    person = nil
    apartment = nil
    
}

runExample2()
print("Noticed : Human is not deallocated")
print("Noticed : Apartment is not deallocated")

print("------------")


// MARK: Example 3 : fix retain cycle

 class owner {
    var name: String
     var pet: pet?
    init(name: String) {
        self.name = name
        print("\(name) is initialized")
    }
    deinit {
        print("\(name) is deallocated")
    }
}

class pet {
    var name: String
    weak var owner: owner?
    init(name: String) {
        self.name = name
        print("\(name) is initialized")
    }
    deinit {
        print("\(name) is deallocated")
    }
}

func runExample3(){
    var person : owner? = owner(name: "Amit")
    var pet : pet? = pet(name: "Tommy")
    pet?.owner = person
    person?.pet = pet
    person = nil
    pet = nil
}
runExample3()
print("------------------------------------------")

