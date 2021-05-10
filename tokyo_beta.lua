-- Tokyo.lua Made by Tokyo#4000 --

-- UI --
-- Misc -- 
local switch_w = menu.SwitchColor("Tokyo Misc.", "Watermark", false, Color.new(1, 1, 1, 1), "Enables Custom Tokyo Watermark")
local indic = menu.SwitchColor("Tokyo Misc.", "Indicators", false, Color.new(1, 1, 1, 1), "Enables Custom Tokyo Indicators")
local switch_c = menu.Switch("Tokyo Misc.", "Clantag", false, "Enables Custom Tokyo Clantag") -- Needs Fixing --
-- Rage --
local sliderint_dt = menu.SliderInt("Tokyo Rage", "DT Shift", 14, 0, 16, "Adjusts the amount of DT Shift, on a fully charged shot.")
local combo_d = menu.Combo("Tokyo Rage", "Recharge Methods", {"Aggressive", "Passive",}, 0, "Double-tap Recharge Modes") -- Doesn't Work --
-- AA --
local combo_p = menu.Combo("Tokyo Anti-Aim", "Anti-Aim", {"Bubble", "Angel", "Random", "Low Delta", "NeoTokyo", "Custom"}, 0, "Anti-Aim Preset Modes")
local desync = menu.SliderInt("Tokyo Anti-Aim", "Custom Desync", 30, 0, 60, "Adjusts the desync value for the custom preset")
local combo_d = menu.Combo("Tokyo Anti-Aim", "Desync on Shot", {"Dodge Left", "Dodge Right", "Invert",}, 0, "Anti-Aim Defensive Modes")
-- Visuals -- 
local disco_bt = menu.Switch("Tokyo Visuals", "RGB Backtrack", false, "Enables RGB Backtrack") -- Check NL Ticket --
local disco_ashot = menu.Switch("Tokyo Visuals", "RGB After Shot", false, "Enables RGB After Shot")
local disco_fog = menu.Switch("Tokyo Visuals", "RGB Fog (Disco Fog)", false, "Enables RGB Fog")
local disco_alpha = menu.SliderFloat("Tokyo Visuals", "RGB Alpha", 0.5, 0, 1, "Adjusts the transparency of RGB (Disco) Features")
-- Fun --
local hud = menu.Switch("Tokyo Fun", "Killsay", false, "Tells chat after every kill!")
local chicken_visuals = menu.Switch("Tokyo Fun", "Chicken Visuals", false, "Decks out everyones' favorite CSGO animal in RGB bling")
local killsay = menu.Switch("Tokyo Fun", "Killsay", false, "Tells chat after every kill!")
-- Information --
local button_d = menu.Button("Tokyo Information", "-> Discord [Vacant]")
local button_w = menu.Button("Tokyo Information", "-> Website [Vacant]")
local button_s = menu.Button("Tokyo Information", "-> Shoppy [Vacant]")

-- Draw --
cheat.RegisterCallback("draw", function()
    
    -- Global Variables --
    
    -- RGB Logic --
    local r, g, b
    gametime = g_GlobalVars.realtime
    r = (math.floor(math.sin(g_GlobalVars.realtime * 1) * 127 + 128)) / 1000 * 3.92
    g = (math.floor(math.sin(g_GlobalVars.realtime * 1 + 2) * 127 + 128)) / 1000 * 3.92
    b = (math.floor(math.sin(g_GlobalVars.realtime * 1 + 4) * 127 + 128)) / 1000 * 3.92
    local clr = Color.new(r, g, b, 100)

    --Indicators --
    local dt_text     = ""
    local script_name = "[Tokyo.lua]"
    local color1 = indic:GetColor()
    local color2 = indic:GetColor()
    local screen = g_EngineClient:GetScreenSize()
    local dt_text_size = g_Render:CalcTextSize(dt_text, 12)
    local script_name_text_size = g_Render:CalcTextSize(script_name, 12)
    local pos_mid = Vector2.new((screen.x/2)-(dt_text_size.x/2),screen.y/2+(dt_text_size.y/2)+20)
    local pos_name = Vector2.new((screen.x/2)-(script_name_text_size.x/2),screen.y/2+(script_name_text_size.y/2))
    local real_rotation = antiaim.GetCurrentRealRotation()
    local desync_rotation = antiaim.GetFakeRotation()
    local max_desync_delta = antiaim.GetMaxDesyncDelta()
    local min_desync_delta = antiaim.GetMinDesyncDelta()
    local desync_delta = real_rotation - desync_rotation
    if (desync_delta > max_desync_delta) then
        desync_delta = max_desync_delta
    elseif (desync_delta < min_desync_delta) then
        desync_delta = min_desync_delta
    end
    if indic:GetBool() then
        g_Render:Text(script_name, pos_name, Color.new(0, 0, 0, 1), 12)
        g_Render:Text(script_name, pos_name, color1, 12)
        g_Render:GradientBoxFilled(Vector2.new(screen.x/2, screen.y/2+21), Vector2.new(screen.x/2+(math.abs(desync_delta*58/100)), screen.y/2+23), color1, Color.new(1, 1, 1, 0), color1, Color.new(1, 1, 1, 0))
        g_Render:GradientBoxFilled(Vector2.new(screen.x/2, screen.y/2+21), Vector2.new(screen.x/2+(-math.abs(desync_delta*58/100)), screen.y/2+23), color1, Color.new(1, 1, 1, 0), color1, Color.new(1, 1, 1, 0))
    end

    -- Watermark Logic --
    if switch_w:GetBool() then
        -- g_Render:GradientBoxFilled(Vector2.new(0, 30), Vector2.new(175, 25), Color.new(0.5, 0.5, 0.5, 0), clr, clr, Color.new(0.5, 0.5, 0.5, 0))
        g_Render:Text(string.format("Tokyo.Lua v1 | %s", cheat.GetCheatUserName()), Vector2.new(11, 29), Color.new(189 / 255, 188 / 255, 233 / 255, 255 / 255), 15)
        g_Render:Text(string.format("Tokyo.Lua v1 | %s", cheat.GetCheatUserName()), Vector2.new(9, 31), Color.new(239 / 255, 177 / 255, 234 / 255, 130 / 255), 15)
        g_Render:Text(string.format("Tokyo.Lua v1 | %s", cheat.GetCheatUserName()), Vector2.new(10, 30), Color.new(1, 1, 1, 1), 15)
    end

    -- Disco Visuals --
    local disco_clr = Color.new(r, g, b, disco_alpha:GetFloat())
    local entity = g_EntityList:GetEntitiesByName("CChicken")
    local fog_var = g_Config:FindVar('Visuals', 'World', 'Fog', 'Enable Fog')
    local aftershot_var = g_Config:FindVar('Visuals', 'Players', 'Chams', 'On Shot')
    local backtrack_var = g_Config:FindVar('Visuals', 'Players', 'Chams', 'Backtrack')

    if disco_fog:GetBool() then -- Fog --
        fog_var:SetColor(disco_clr)
    end
    if disco_ashot:GetBool() then -- After Shot --
        aftershot_var:SetColor(disco_clr)
    end
    if disco_bt:GetBool() then -- Backtrack --
        backtrack_var:SetColor(disco_clr)
    end
    
    -- Chicken Chams --
    if chicken_visuals:GetBool() then
        for i = 1, #entity do
            local position = entity[i]:GetProp("DT_BaseEntity", "m_vecOrigin")
            g_Render:Circle3D(position, 58, 10.0, disco_clr)
            g_Render:Circle3D(position + s1, 58, 10.0, disco_clr)
            g_Render:Box(Vector2.new(0.0, 0.0), Vector2.new(4.0, 5.0), Color.new(1.0, 1.0, 1.0, 1.0))
        end
    end
end)

-- Create Move --
cheat.RegisterCallback("createmove", function()
    
    -- Global Variables --

    -- DT Shift logic --
    if sliderint_dt:GetInt() then
        exploits.OverrideDoubleTapSpeed(sliderint_dt:GetInt())
    end

    -- Recharge Methods --
    if combo_d:GetInt() == 0 then   -- Aggressive --
        
    end
    if combo_d:GetInt() == 1 then   -- Passive --
        
    end

end)

-- Prediction --
cheat.RegisterCallback("prediction", function()

    -- Global Variables --

    -- Anti-Aim Dropdown --
    if combo_p:GetInt() == 0 then   -- Bubble --
        antiaim.OverrideLimit(27)
    end
    if combo_p:GetInt() == 1 then   -- Angel --
        antiaim.OverrideLimit(34)
    end
    if combo_p:GetInt() == 2 then   -- Random --
        antiaim.OverrideLimit(math.random(15,30))
    end
    if combo_p:GetInt() == 3 then   -- Low Delta --
        antiaim.OverrideLimit(16)
    end
    if combo_p:GetInt() == 4 then   -- NeoTokyo --
        antiaim.OverrideLimit(10)
    end
    if combo_p:GetInt() == 5 then   -- Custom --
        antiaim.OverrideLimit(desync:GetInt())
    end

    -- Desync on Shot Dropdown --
    if combo_d:GetInt() == 0 then   -- Dodge Left --
        antiaim.OverrideDesyncOnShot(1)
    end
    if combo_d:GetInt() == 1 then   -- Dodge Right --
        antiaim.OverrideDesyncOnShot(2)
    end
    if combo_d:GetInt() == 2 then   -- Invert --
        antiaim.OverrideDesyncOnShot(4)
    end
end)

-- Events --
local phrases = {
    "Destroyed by Tokyo.lua!",   
    "1",
    "Seems like you need tokyo.lua @ shoppy.gg/@TheTokyo"
}
local function get_phrase()
    return phrases[utils.RandomInt(1, #phrases)]:gsub('\"', '')
end
cheat.RegisterCallback("events", function(event)
    if killsay:GetBool() then
        if event:GetName() ~= "player_death" then return end
        local me = g_EngineClient:GetLocalPlayer()
        local victim = g_EngineClient:GetPlayerForUserId(event:GetInt("userid"))
        local attacker = g_EngineClient:GetPlayerForUserId(event:GetInt("attacker"))
        if victim == attacker or attacker ~= me then return end
        g_EngineClient:ExecuteClientCmd('say "' .. get_phrase() .. '"')
    end
end)

-- Material Modification --
local function onAnimatedWireFrameLoaded(mat)
    g_MatSystem:OverrideMaterial("Enemies", mat)
  end
  g_MatSystem:CreateMaterial("testing_material",  [[
    "VertexLitGeneric"
    {
      "$basetexture" "nature/urban_puddle01a_ssbump"
      "$additive" "1"
      "$selfillum" "1"
      "$nocull" "1"
      "$wireframe" "1"
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$BasetextureTransform"
                      "texturescrollrate" "2"
                      "texturescrollangle" "90"
              }
      }
    }  
  ]], onAnimatedWireFrameLoaded)
