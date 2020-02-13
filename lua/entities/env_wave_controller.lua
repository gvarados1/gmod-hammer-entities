AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "point"

function ENT:KeyValue( key, value )
	if key == "water_overlayenable" then water_overlayenable = value
	elseif key == "water_fogenable" then water_fogenable = value
	elseif key == "water_fogcolor" then water_fogcolor = value
	elseif key == "water_fogstart" then water_fogstart = value
	elseif key == "water_fogend" then water_fogend = value
	elseif key == "water_fogmaxdensity" then water_fogmaxdensity = value 
	elseif key == "water_defaultspawn" then water_defaultspawn = value 
	elseif key == "wave_length" then wave_length = value 
	
	elseif key == "spawner_small" then spawner_small = value 
	elseif key == "spawner_med" then spawner_med = value 
	elseif key == "spawner_large" then spawner_large = value 
	elseif key == "spawner_mega" then spawner_mega = value 
	
	end
	
end

if(SERVER) then

function ENT:Initialize()
print("Loading waves!")

waves_maxspeed = 1024
CreateConVar("waves_spawntype", 0, FCVAR_NONE, "0 RANDOM, 1 SMALL, 2 MEDIUM, 3 LARGE, 4 MEGA", 0, 4)
timer.Simple(.1, function() CreateConVar("waves_spawntype", 0, FCVAR_NONE, "0 RANDOM, 1 SMALL, 2 MEDIUM, 3 LARGE, 4 MEGA", 0, 4) end)
CreateConVar("waves_movespeed", 120, FCVAR_NONE, "Set wave speed. Default: 120", 10, waves_maxspeed)
CreateConVar("waves_lagcomp", .99999, FCVAR_NONE, "Lag compensation. Default: .99999", .99, 1)

spawner_small = (ents.FindByName(spawner_small))[1]
spawner_med = (ents.FindByName(spawner_med))[1]
spawner_large = (ents.FindByName(spawner_large))[1]
spawner_mega = (ents.FindByName(spawner_mega))[1]

table_random = {spawner_small, spawner_med, spawner_large, spawner_mega, spawner_small, spawner_med, spawner_large}

wave_speed = GetConVar("waves_movespeed"):GetInt() // default: 120
wave_interval = wave_length / wave_speed
wave_lagcomp = GetConVar("waves_lagcomp"):GetFloat() // default: .99999

spawner_small:Fire("forcespawn")
openWaves()

timer.Create( "master_timer", wave_interval * wave_lagcomp, 0, spawnMaster)
end


function spawnMaster()
	local spawn_type = GetConVar("waves_spawntype"):GetInt()
	wave_speed = GetConVar("waves_movespeed"):GetInt() // default: 120
	wave_lagcomp = GetConVar("waves_lagcomp"):GetFloat() - wave_speed/waves_maxspeed/200 // default: .99999
	wave_interval = wave_length / wave_speed
	timer.Adjust( "master_timer", wave_interval * wave_lagcomp, 0, spawnMaster)

	if spawn_type == 0 then spawnRandom()
	elseif spawn_type == 1 then spawnSmall()
	elseif spawn_type == 2 then spawnMed()
	elseif spawn_type == 3 then spawnLarge()
	elseif spawn_type == 4 then spawnMega() end
	
	wave_next:Fire("forcespawn")
	openWaves()
end

// spawn types
function spawnRandom()
	wave_next = table.Random(table_random)
end

function spawnSmall()
	wave_next = spawner_small
end

function spawnMed()
	wave_next = spawner_med
end

function spawnLarge()
	wave_next = spawner_large
end

function spawnMega()
	wave_next = spawner_mega
end

// open waves
function openWaves()
	timer.Simple(.1, function()
		local waves = ents.FindByName("wave_*")

		for k,v in pairs(waves) do
			v:Fire("open")
			v:Fire("setspeed", wave_speed)
		end
					//print(wave_speed)
					//print(wave_lagcomp)
	end)
end

end


if(CLIENT) then
	// better water effects (fix for waves)
	
	if water_overlayenable == 1 then // if overlay enabled
		hook.Add("RenderScreenspaceEffects", "psw_wateroverlay", function()
			local ply = LocalPlayer()
			if(ply:Alive()) then
				if(ply:WaterLevel() == 3) then
					DrawMaterialOverlay("effects/water_warp01",-.1)
				end
			end
		end)
	end // end overlay enabled
	
	
	if water_fogenable == 1 then // if fog enabled
		function GAMEMODE:SetupWorldFog()
			local ply = LocalPlayer()
			if(ply:Alive()) then
				if(ply:WaterLevel() == 3) then
					render.FogMaxDensity(water_fogmaxdensity)
					render.FogColor( water_fogcolor )
					render.FogStart( water_fogstart )
					render.FogEnd( water_fogend )
					render.FogMode( MATERIAL_FOG_LINEAR )
					return true	
				end	
			end
		end
		
		function GAMEMODE:SetupSkyboxFog( skyboxscale )
			local ply = LocalPlayer()
			if(ply:Alive()) then
				if(ply:WaterLevel() == 3) then
					render.FogMaxDensity(water_fogmaxdensity)
					render.FogColor( water_fogcolor )
					render.FogStart( water_fogstart * skyboxscale)
					render.FogEnd( water_fogend * skyboxscale)
					render.FogMode( MATERIAL_FOG_LINEAR )
					return true	
				end	
			end
		end 
	end // end fog enabled
	
end

function ENT:AcceptInput(name, activator, caller, data)
	if name == "SetWaveType" then
		RunConsoleCommand( "waves_spawntype", data )
		return true
	elseif name == "SetWaveSpeed" then
		RunConsoleCommand( "waves_movespeed", data )
		return true
	elseif name == "SetLagComp" then
		RunConsoleCommand( "waves_lagcomp", data )
		return true
   end
end