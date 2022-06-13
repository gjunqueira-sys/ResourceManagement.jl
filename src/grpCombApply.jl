# generic groupby, combine, apply
# grpCombApply(df, grp::String, comb::String, f::Function)
#		Args:
#			`df:: dataframe`
#			`grp:: String`: Column name to group by
# 			`comb:: String`: Column name to combine
#			`f:: Function`: Function to apply to the combined column
function grpCombApply(df, grp::String, comb::String, f::Function)
    dfg = groupby(df, grp);
    combine(dfg, comb => f);
end