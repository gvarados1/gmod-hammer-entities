AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "point"

function ENT:KeyValue( key, value )
	if key == "water_overlayenable" then water_overlayenable = value
	elseif key == "water_fogenable" then water_fogenable = value
	
	end
end

function ENT:Initialize()

	mic_range = 500
	speaker_range = 100

end

if(CLIENT) then


function ENT:Think()
	hook.Add( "PlayerCanHearPlayersVoice", "speaker", function( listener, talker )
		if talker:GetPos():Distance( self:GetPos() ) <= mic_range and listener:GetPos():Distance( speaker:GetPos() ) <= speaker_range then
			return true, true 
		end
	end )
end
	
end