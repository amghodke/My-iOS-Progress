

What is a memory leak?
A memory leaks happens an object is no longer needed by the app but it stays in memory because somthing is still holding a refernce of it so ARC never sees its reference count hit to zero and it never gets deallocated.
this leads to :
-app becomes slow
-excess RAM utilization
-even OS may kill the app due to too much memory utilization
Reasons for memory leaks :
-Retain cycles
-strong closures
-Timers schedulers
-not removing of Notification observers
Ways to identify memory leaks :
-deinit print statements
-xcode memory graph debugger
-Instruments leaks and allocation 

What is the difference between a memory leak and a retain cycle?
A retain cycle is one specific cause of a memory leak — where two objects strongly reference each other. A memory leak is the broader result — any situation where memory isn't freed when it should be. In short: every retain cycle causes a memory leak, but not every memory leak is caused by a retain cycle.


Can a memory leak happen without a retain cycle?
Yes — a retain cycle is just one cause. A memory leak simply means an object stays alive longer than it should, and that can happen anytime something holds a strong reference to it that never gets released — even without any cycle involved.
ex
1. Singleton/static holding a strong reference to a short-lived object
class SessionManager {
    static let shared = SessionManager()
    var activeViewController: ViewController?   
    //one-directional, no cycle
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        SessionManager.shared.activeViewController = self
        // Never set back to nil -> VC leaks, even though VC doesn't hold SessionManager
    }
}

2. Un-invalidated Timer
class ViewController: UIViewController {
    var timer: Timer?
    override func viewDidLoad() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateUI()   // Timer keeps firing, VC never deallocates
        }
    }
    // Forgot: timer?.invalidate() in deinit or viewWillDisappear
}
3. Forgotten NotificationCenter observer (older/closure-based pattern)
etc


Can a retain cycle always cause a memory leak?
Yes,This is actually a guarantee, not a possibility — because of how ARC works mechanically:

ARC deallocates an object only when its reference count hits exactly 0.
In a retain cycle, Object A holds a strong reference to Object B, and Object B holds a strong reference back to A.
 so both their counts sit at 1 forever, never reaching 0.
Since neither count reaches 0, deinit never fires, memory is never freed. That is, by definition, a memory leak.

Why doesn't ARC detect retain cycles?
Because ARC only does reference counting — it just tracks "how many things point to me" — it doesn't analyze the object graph to check whether those references are reachable from anywhere else. It has no concept of "is this cycle isolated from the rest of the app," so it can't tell the difference between a valid strong reference and one stuck in a loop.


How do you identify a memory leak?
1. Xcode Memory Graph Debugger (fastest, day-to-day)
2.Instruments leaks
repeatly push/pop a view controller and check memory size
3.add print statement in deinit

Which Xcode tools do you use?
My actual workflow, in order:
deinit prints while writing the feature (cheapest, fastest feedback loop)
Memory Graph Debugger before committing, if anything feels off
Instruments (Leaks + Allocations) for complex/critical flows or before a release, to be thorough

What is the Memory Graph Debugger?
It's Xcode's built-in visual tool that snapshots every live object and its references at a point in time — purple warning icons flag suspected leaks, and I can click into any object to trace exactly what's still holding onto it, which makes it my fastest way to confirm or debug a retain cycle without leaving Xcode.

What is the Leaks Instrument?
The Leaks Instrument continuously monitors the running app and automatically flags objects that are unreachable but still allocated, giving me a timeline view and full allocation stack trace — it's my tool of choice for a broad sweep across a whole user flow, rather than checking one specific object like I would with the Memory Graph Debugger.

What does deinit tell you?
deinit is a special method that Swift automatically calls right before an object is deallocated from memory — so if you put a print statement inside it, seeing (or not seeing) that print tells you whether ARC actually released that object when you expected it to
