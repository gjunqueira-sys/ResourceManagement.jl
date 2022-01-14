module MacrosUtils

# create Singleton Types
struct MacrosType{T} end 


MacrosType(s::String) = MacrosType{Symbol(s)}();

MacrosType("All");


export prettyPrint;




function  ProcessMacros(::MacrosType{:All})
    println("""
                    Name: $(eval(args[1]).Name)
                    Dept: $(eval(args[1]).Dept)
                    Project: $(eval(args[1]).Project)
                    =============================
                    Rate: $(eval(args[1]).Rate)
                    =============================
                    FwdHoursForecast: $(eval(args[1]).FwdHoursForecast)
                    FwdCostsForecast: $(eval(args[1]).FwdCostsForecast)
                    =============================
                    RevHoursForecast: $(eval(args[1]).RevHoursForecast)
                    RevCostsForecast: $(eval(args[1]).RevCostsForecast)
                    =============================
                    
                    
                    """)
end



function ProcessMacros(::MacrosType{:Sum})
    fwdsum=sum(eval(args[1]).FwdHoursForecast);
    fwdcostsum=sum(eval(args[1]).FwdCostsForecast);
    revsum=sum(eval(args[1]).RevHoursForecast);
    revcostsum=sum(eval(args[1]).RevCostsForecast);

    println("""
                    Name: $(eval(args[1]).Name)
                    Dept: $(eval(args[1]).Dept)
                    Project: $(eval(args[1]).Project)
                    =============================
                    Rate: $(eval(args[1]).Rate)
                    =============================
                    FwdHoursForecast: $fwdsum
                    FwdCostsForecast: $fwdcostsum
                    =============================
                    RevHoursForecast: $revsum
                    RevCostsForecast: $revcostsum
                    =============================
    """)
end


function ProcessMacros(::MacrosType{:Max})
    fwdmax=maximum(eval(args[1]).FwdHoursForecast);
    fwdcostmax=maximum(eval(args[1]).FwdCostsForecast);
    revmax=maximum(eval(args[1]).RevHoursForecast);
    revcostmax=maximum(eval(args[1]).RevCostsForecast);

    println("""
                    Name: $(eval(args[1]).Name)
                    Dept: $(eval(args[1]).Dept)
                    Project: $(eval(args[1]).Project)
                    =============================
                    Rate: $(eval(args[1]).Rate)
                    =============================
                    FwdHoursForecast: $fwdmax
                    FwdCostsForecast: $fwdcostmax
                    =============================
                    RevHoursForecast: $revmax
                    RevCostsForecast: $revcostmax
                    =============================
    """
    )

end









# macro definition
macro prettyPrint(ex)
    return _prettyPrint(ex);
end





# macro function called
function _prettyPrint(ex)
    args = ex.args;
    if ex.head == :-> && (length(args) == 2)
        if (typeof(eval(args[1])) == DisciplineLabor) || (typeof(eval(args[1])) == TeamLabor)
            if typeof(args[2]) == Expr && length(args[2].args) == 2

                command = args[2].args[2];

                ProcessMacros(command)
                
            end
            
            
        end
    end

            
       
end








end
