NEXT_MAP = "d3_citadel_05"

TRIGGER_DELAYMAPLOAD = { Vector( -1281, -8577, 6015 ), Vector( -1151, -7743, 6200 ) }

SUPER_GRAVITY_GUN = true

CITADEL_ELEVATOR_CHECKPOINT1 = false
CITADEL_ELEVATOR_CHECKPOINT2 = true


-- Player spawns
function hl2cPlayerSpawn( ply )

	ply:Give( "weapon_physcannon" )

end
hook.Add( "PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn )


-- Initialize entities
function hl2cInitPostEntity()

	game.ConsoleCommand( "physcannon_tracelength 850\n" )
	game.ConsoleCommand( "physcannon_maxmass 850\n" )
	game.ConsoleCommand( "physcannon_pullforce 8000\n" )

	ents.FindByName( "global_newgame_template_ammo" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_base_items" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_local_items" )[ 1 ]:Remove()

end
hook.Add( "InitPostEntity", "hl2cInitPostEntity", hl2cInitPostEntity )


-- Accept input
function hl2cAcceptInput( ent, input )

	if ( !game.SinglePlayer() && !CITADEL_ELEVATOR_CHECKPOINT1 && ( ent:GetName() == "citadel_brush_elevcage1_1" ) && ( string.lower( input ) == "enable" ) ) then
	
		CITADEL_ELEVATOR_CHECKPOINT1 = true
		CITADEL_ELEVATOR_CHECKPOINT2 = false
		for _, ply in pairs( player.GetAll() ) do
		
			ply:SetVelocity( Vector( 0, 0, 0 ) )
			ply:SetPos( Vector( 256, 832, 2320 ) )
			ply:SetEyeAngles( Angle( 0, -90, 0 ) )
		
		end
	
	end

	if ( !game.SinglePlayer() && !CITADEL_ELEVATOR_CHECKPOINT2 && ( ent:GetName() == "citadel_path_lift01_1" ) && ( string.lower( input ) == "inpass" ) ) then
	
		CITADEL_ELEVATOR_CHECKPOINT2 = true
		for _, ply in pairs( player.GetAll() ) do
		
			ply:SetVelocity( Vector( 0, 0, 0 ) )
			ply:SetPos( Vector( 256, 832, 6420 ) )
			ply:SetEyeAngles( Angle( 0, -90, 0 ) )
		
		end
		GAMEMODE:CreateSpawnPoint( Vector( 256, 832, 6420 ), -90 )
	
	end

end
hook.Add( "AcceptInput", "hl2cAcceptInput", hl2cAcceptInput )


-- Every frame or tick
function hl2cThink()

	if ( SUPER_GRAVITY_GUN ) then
	
		for _, ent in pairs( ents.FindByClass( "weapon_*" ) ) do
		
			if ( IsValid( ent ) && ent:IsWeapon() && ( ent:GetClass() != "weapon_physcannon" ) && ( !IsValid( ent:GetOwner() ) || ( IsValid( ent:GetOwner() ) && ent:GetOwner():IsPlayer() ) ) ) then
			
				ent:Remove()
			
			end
		
		end
	
		for _, ent in pairs( ents.FindByClass( "weapon_physcannon" ) ) do
		
			if ( IsValid( ent ) && ent:IsWeapon() ) then
			
				if ( ent:GetSkin() != 1 ) then ent:SetSkin( 1 ) end
			
			end
		
		end
	
		for _, ply in pairs( team.GetPlayers( TEAM_ALIVE ) ) do
		
			if ( IsValid( ply ) && ply:Alive() && IsValid( ply:GetActiveWeapon() ) && ( ply:GetActiveWeapon():GetClass() == "weapon_physcannon" ) ) then
			
				if ( ply:GetViewModel():GetModel() != "models/weapons/c_superphyscannon.mdl" ) then ply:GetViewModel():SetModel( "models/weapons/c_superphyscannon.mdl" ) end
			
			end
		
		end
	
	end

end
hook.Add( "Think", "hl2cThink", hl2cThink )
