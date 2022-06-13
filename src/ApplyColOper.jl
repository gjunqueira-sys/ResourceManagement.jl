#generic high order function to apply any function to a vector column of a df
function ApplyColOper(df, colName::String, f)
    return df[!, colName] |> (f);
end