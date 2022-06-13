module LaborTrackerSpreadsheet
    // module declaration

type LaborTracker = 
    {   Department: string     
        // ie 142270 
        Project: string         
        Description: string
        // ie N150547-02
        Network: string   
        // ie 2050      
        Task: int              
        Employee_No:int
        Employee_Name: string
        // sequence repeated 24 times
        MM_YYYY_Actual:string 
        // sequence repeated 24 times
        MM_YYYY_Planned:string 
        // sequence repeated 24 times
        MM_YYYY_Difference:string  }


type FwdHoursForecast = 
    {   Project: array<string>
        Month1:  array<int>
        Month2:  array<int>
        Month3:  array<int>
        Month4:  array<int>
        Month5:  array<int>
        Month6:  array<int>
        Month7:  array<int>
        Month8:  array<int>
        Month9:  array<int>
        Month10: array<int>
        Month11: array<int>
        Month12: array<int>
        Month13: array<int>
        Month14: array<int>
        Month15: array<int>
        Month16: array<int>
        Month17: array<int>
        Month18: array<int>
        Month19: array<int>
        Month20: array<int>
        Month21: array<int>
        Month22: array<int>
        Month23: array<int>
        Month24: array<int>
        
        
    }

type RevHoursForecast = {

    Project: array<string>
    Month1:  array<int>
    Month2:  array<int>
    Month3:  array<int>
    Month4:  array<int>
    Month5:  array<int>
    Month6:  array<int>
    Month7:  array<int>
    Month8:  array<int>
    Month9:  array<int>
    Month10: array<int>
    Month11: array<int>
    Month12: array<int>
    Month13: array<int>
    Month14: array<int>
    Month15: array<int>
    Month16: array<int>
    Month17: array<int>
    Month18: array<int>
    Month19: array<int>
    Month20: array<int>
    Month21: array<int>
    Month22: array<int>
    Month23: array<int>
    Month24: array<int>
}


type RevActualHours = {

    Project: array<string>
    Month1:  array<int>
    Month2:  array<int>
    Month3:  array<int>
    Month4:  array<int>
    Month5:  array<int>
    Month6:  array<int>
    Month7:  array<int>
    Month8:  array<int>
    Month9:  array<int>
    Month10: array<int>
    Month11: array<int>
    Month12: array<int>
    Month13: array<int>
    Month14: array<int>
    Month15: array<int>
    Month16: array<int>
    Month17: array<int>
    Month18: array<int>
    Month19: array<int>
    Month20: array<int>
    Month21: array<int>
    Month22: array<int>
    Month23: array<int>
    Month24: array<int>
}



type DisciplineLabor = 
    {   FwdHoursAvailable: array<float>
        FwdHoursForecast: FwdHoursForecast
        RevHoursForecast: RevHoursForecast
        RevHoursAvailable: array<float>
        FwdCostsForecast: array<float>
        RevCostsForecast: array<float>
        RevActualHours: RevActualHours
        RevActualCostHours: array<float>
        Dept: string
        Name: string
        Projects: array<string>

    }





