ARC & Memory
1.What is ARC?
ARC (Automatic Reference Counting) is Apple's memory management system that automatically tracks and manages your app's memory usage by keeping count of references to objects
Every time if object is assigned to a variables or property or constant, ARC increases its reference count and when that reference goes away or set to nil then ARC decreases the reference count,once its set to zero ARC automatically deallocates that object and frees up the memory.
ARC doesnt solve retain cycle or strong reference cyles, we have to manage it by using weak or unowned.


Why was ARC introduced?
Before ARC, developers has to maintain memory themselves they needs to track of object's retain, release or autorelease this could leads to 
-memory leaks if developers forgot to release etc
-time consuming for doing it manually
so to avoid above complexity Apple introduced ARC which automatically manage the memory management by keeping track of reference count



How does ARC differ from Garbage Collection?
ARC manages memory at compile time by inserting retain/release calls based on reference counts
Garbage collection manages memory at run time by periodically scanning for and cleaning unreachable objects

In ARC strong reference cycles need to handle manually using weak or unowned way but in GC it handles automatically because it traces reachability not the reference count


What is a strong reference?
It is the default type of reference in swift.
when object hold strong then its reference count is increased by 1, keeping it alive in memory
ex
class Person {
    var name : String
    init(name:String) {self.name = name }
}
var person_obj :Person? = Person(name:"Amit")


What is a weak reference?
A weak reference lets to refer to an object without increasing it reference count so it does not keep alive that object in the memory, and it automatically becomes nil when the object is deallocated.

class Person {
    var name : String
    var apartment : Apartment? // strong
    init(name:String) {self.name = name }
}
Class Apartment {
    var flatnumber : String
    weak var tenant : Person? // weak
    init(flatnumber:String){self.flatnumber = flatnumber}
}
var person_obj :Person? = Person(name:"Amit")
var appartment_obj : Appartment? = Appartment(flatnumber:"1B")
person_obj.apartment = appartment_obj
appartment_obj.tenant = person_obj
person_obj = nil // immedietly deallocated
appartment_obj = nil // immedietly deallocated

What is an unowned reference?
An unowned reference count is like a weak reference it does not increase the reference count and helps to break the retatin cycle but unlike weak, its non-optional and assumes that the reference object will always exist for as long as the unowned reference itself exist.


What is a retain cycle?
A retain cycle occures when two or more objects strongly refernce each other preventing ARC to deallocate them.
To avoid it use weak or unowned references
class Person {
    var name : String
    var apartment : Apartment? // strong
    init(name:String) {self.name = name }
}
Class Apartment {
    var flatnumber : String
    var tenant : Person? // weak
    init(flatnumber:String){self.flatnumber = flatnumber}
}
var person_obj :Person? = Person(name:"Amit")
var appartment_obj : Appartment? = Appartment
person_obj.apartment = appartment_obj
appartment_obj.tenant = person_obj



How do you identify a retain cycle?
1.check strong/weak/unowned refernces
2.add deinit method
3.xcode memory graph to check object in memory and its count
4.Instruments leaks for runtime detection

Why must weak references be optional?
weak references should be otpional because ARC will set them to nil automatically

Give a real-world retain cycle example from UIKit or SwiftUI.
A retain cycle occures when two or more references strongly references each other and ARC can not release them so memory leaks occures.



Value vs Reference
A value type get copied when assigned or passed around each copy is independant
ex ; struct or enum
A reference type get shared assigning its just copies a pointer to the same instance in the memory
ex : class


Difference between Struct and Class?
Feature	-           Struct	            - Class
Type -	            Value type	        - Reference type
Memory -	        Stack (usually)	    - Heap
On assignment-	    Copied	            - Shared (reference)
Inheritance-	    ❌ Not supported    -	✅ Supported
ARC (retain/release)?-	❌ No           -	✅ Yes
Mutability-	         Need mutating keyword for methods that change properties-               No such requirement
Deinitializers (deinit)-	❌ Not available	 - ✅ Available
Identity check (===)-	    ❌ Not applicable -	✅ Can check if two vars point to same instance
Thread safety -	    Safer : copies are independent - Riskier : shared mutable state needs care
Performance-	    Generally faster (no heap allocation, no ARC overhead) -	    Slightly more overhead due to heap + ARC


When do you use a Struct?
Use struct when
-independant copied data with no shared state
-if you want copy on assignement behaviour and no mutation 
-if you dont need inheritance
-when thread safty matters
ex : data models

When do you use a Class?
Use class when
-you need shared state to access multiple part of code
-when inheritance needed
-when identtiy needed to cross check pointing to same class instance using ===
-when deinit needed
ex- network manager, session manager etc


Explain Copy-on-Write.
copy-on-write is an optimization where values types like array, dictionary etc dont actually coopy their data when the assigned to new variable, they share the same storage untill one of them is mutating.
for ex
var a = {1,2,3,4}
var b= a  // here a and b are pointing to same storage
b.append(6) // here b is mutated now new copy is assigned to b
print(a) // {1,2,3,4}
print(b) // {1,2,3,4,6}

Why is Array a struct?
Array is a struct so it behaves like value type giving us independance copies with no shared mutable state

Closures
What is a closure?
A closure is a self-contained block of functionality that can be passed around and used in your code — like a function without a name, that can also capture and store references to variables from its surrounding context.
For ex
let add : (int,int) -> int

What is an escaping closure?
Why does URLSession use @escaping?
What is a capture list?
How do closures create retain cycles?