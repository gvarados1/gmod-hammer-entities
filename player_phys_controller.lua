AddCSLuaFile()

if(CLIENT) then
	// better water effects (fix for waves)
	// idk why I need to check if the player is underwater for each event. It doesn't work if I only check once
	hook.Add("RenderScreenspaceEffects", "psw_wateroverlay", function()
		local ply = LocalPlayer()
		if(ply:Alive()) then
			if(ply:WaterLevel() == 3) then
				DrawMaterialOverlay("effects/water_warp01",-.1)
			end
		end
	end)
	
	function GAMEMODE:SetupWorldFog()
		local ply = LocalPlayer()
		if(ply:Alive()) then
			if(ply:WaterLevel() == 3) then
				render.FogMaxDensity(1)
				render.FogColor( 24, 64, 62)
				render.FogStart( -800 )
				render.FogEnd( 6500 )
				render.FogMode( MATERIAL_FOG_LINEAR )
				return true	
			end	
		end
	end
	
	function GAMEMODE:SetupSkyboxFog( skyboxscale )
		local ply = LocalPlayer()
		if(ply:Alive()) then
			if(ply:WaterLevel() == 3) then
				render.FogMaxDensity(1)
				render.FogColor( 24, 64, 62)
				render.FogStart( -600 * skyboxscale)
				render.FogEnd( 6500 * skyboxscale)
				render.FogMode( MATERIAL_FOG_LINEAR )
				return true	
			end	
		end
	end
	
end