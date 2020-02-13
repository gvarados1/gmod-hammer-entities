// very impressive, lots of code
ENT.Base = "base_entity"
ENT.Type = "filter"

function ENT:PassesFilter( trigger, ent )
	if( IsValid(ent) && ent:IsVehicle() )then
		return true
	end
end