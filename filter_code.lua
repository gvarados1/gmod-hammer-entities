ENT.Base = "base_entity"
ENT.Type = "filter"

function ENT:KeyValue( key, value )
	if key == "code" then
		CompileString( value, "codeFunction")
	end	
end

function ENT:PassesFilter( trigger, ent )
	codeFunction()
end