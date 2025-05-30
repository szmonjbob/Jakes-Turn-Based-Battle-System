/// @description Update Conditions

//Run through all conditions and apply their effects.
for (i = 0; i < array_length(conditions); i++)
{
	conditions[i](stats, effective_stats);
}