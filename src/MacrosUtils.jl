module MacrosUtils




# create Singleton Types
struct MacrosType{T} end 


MacrosType(s::String) = MacrosType{Symbol(s)}();


MacrosType("All");



















end

