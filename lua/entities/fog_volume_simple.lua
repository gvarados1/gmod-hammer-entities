// scrapped -  this entity would be too limited comparred to easy to setup triggers.

AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "brush"

function ENT:KeyValue( key, value )
	if key == "isdisabled" then isdisabled = value
	elseif key == "fogcolor" then fogcolor = value
	elseif key == "fogstart" then fogstart = value
	elseif key == "fogend" then fogend = value
	elseif key == "fogmaxdensity" then fogmaxdensity = value 
	
	elseif key == "foglerptime" then foglerptime = value 
	elseif key == "farz" then farz = value 
	print ("reee")
	end
	
end

function ENT:Touch( ent )
	print ("dwadwa")
	
		if(ent:IsPlayer()) then
			ply = ent
		end
		print( ply )
		ply:SendLua("print( 'jimbo sucks') ")
		if isdisabled == 0 then // if fog enabled
			function GAMEMODE:SetupWorldFog()
				render.FogMaxDensity(water_fogmaxdensity)
				render.FogColor( water_fogcolor )
				render.FogStart( water_fogstart )
				render.FogEnd( water_fogend )
				render.FogMode( MATERIAL_FOG_LINEAR )
				return true	
			end
			
			function GAMEMODE:SetupSkyboxFog( skyboxscale )
				render.FogMaxDensity(water_fogmaxdensity)
				render.FogColor( water_fogcolor )
				render.FogStart( water_fogstart * skyboxscale)
				render.FogEnd( water_fogend * skyboxscale)
				render.FogMode( MATERIAL_FOG_LINEAR )
				return true	
			end 
		end
end
