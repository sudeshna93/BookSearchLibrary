# Dependency Injection

* an object is *dependent* on another object.
        * ViewModel depending on a Networking object (to do networking)

* dependency != responsible for creating the object

* inject: give this object its dependency, externally.
        * provide it to the object within the initializer.


# Dependency Inversion

* "objects should be built with abstractions, not concrete classes"

* ViewModel should work with a Networking object.
        * does the VM care anything about the networking?
        * it doesn't need to know if the networking uses...
                * JSON/REST/HTTPS
                * Protocol Buffers
                * remote database connection
                * etc.
                                
* Instead, it has an abstract idea about what this object can provide it.


# How do they relate?

* Dependency Inversion Principle
    * a principle of design, an idea
    
* Dependency Injection
    * an application of the principle
    * useful for...
            * making objects
            * reducing the complexity of defining objects
            * testing.
