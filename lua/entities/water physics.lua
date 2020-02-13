if(SERVER) then
	hook.Add( "SetupMove", "psw_movement", function( ply, mv, cmd )
		ply:SetRunSpeed(260)
		ply:SetWalkSpeed(150)
		
		// better swimming in waves (awkward in regular water)
		if(ply:WaterLevel() == 2) then
			ply:SetVelocity(Vector(0, 0, 3))
			mv:SetUpSpeed(10)
		elseif(ply:WaterLevel() == 3) then
			mv:SetUpSpeed(-10)
		end
		
		// fix jumpping on moving props
		if( mv:KeyPressed(IN_JUMP)) then
			if(ply:IsOnGround()) then
				local trground = util.TraceLine( util.GetPlayerTrace( ply, Vector( 0, 0, -1 ) ) )
				if IsValid( trground.Entity ) then 
					ply:SetPos(ply:GetPos() + Vector(0,0,4))
				end
			end
		end
	end )

end	