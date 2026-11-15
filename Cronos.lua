-- Cronos
-- ShaguTweaks' "MiniMap Tweaks" module hides GameTimeFrame (the sun/moon
-- button on the minimap, which the server's calendar hangs off) and adds an
-- OnShow script that hides it again every time something shows it.
-- This addon puts the original OnShow back and shows the button again,
-- while leaving the rest of MiniMap Tweaks (mousewheel zoom etc.) alone.
--
-- Extras: Shift + drag the button to move it (saved per character).
-- /cronos reset   - put the button back in its default spot
-- /cronos show    - force the button to show again

if not GameTimeFrame then return end

-- ShaguTweaks only applies its modules on VARIABLES_LOADED, which happens
-- after every addon file has been read. So right now the button still has
-- its untouched scripts; remember them.
local original = {
  OnShow = GameTimeFrame:GetScript("OnShow"),
}

local defaultPoint = {}
do
  local point, relativeTo, relativePoint, x, y = GameTimeFrame:GetPoint()
  defaultPoint = { point, relativeTo, relativePoint, x, y }
end

local function Print(msg)
  DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Cronos:|r " .. msg)
end

local function ApplyPosition()
  GameTimeFrame:ClearAllPoints()
  local p = CronosDB and CronosDB.point
  if p then
    GameTimeFrame:SetPoint(p[1], UIParent, p[2], p[3], p[4])
  elseif defaultPoint[1] then
    GameTimeFrame:SetPoint(defaultPoint[1], defaultPoint[2], defaultPoint[3], defaultPoint[4], defaultPoint[5])
  else
    GameTimeFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", -12, -12)
  end
end

local function Restore()
  -- undo ShaguTweaks' "always hide" script
  GameTimeFrame:SetScript("OnShow", original.OnShow)

  -- Shift + drag to move, normal clicks still go to the button
  GameTimeFrame:SetMovable(true)
  GameTimeFrame:RegisterForDrag("LeftButton")
  GameTimeFrame:SetScript("OnDragStart", function()
    if IsShiftKeyDown() then
      this.crMoving = true
      this:StartMoving()
    end
  end)
  GameTimeFrame:SetScript("OnDragStop", function()
    if not this.crMoving then return end
    this.crMoving = nil
    this:StopMovingOrSizing()
    -- store relative to UIParent so it survives reloads
    local x, y = this:GetCenter()
    local scale = this:GetEffectiveScale() / UIParent:GetEffectiveScale()
    CronosDB.point = { "CENTER", "BOTTOMLEFT", x * scale, y * scale }
    ApplyPosition()
  end)

  ApplyPosition()
  GameTimeFrame:Show()
end

local f = CreateFrame("Frame")
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
  if not CronosDB then CronosDB = {} end
  Restore()

  -- run once more a moment later, in case anything hides it after us
  this.wait = GetTime() + 2
  this:SetScript("OnUpdate", function()
    if GetTime() < this.wait then return end
    this:SetScript("OnUpdate", nil)
    Restore()
  end)
end)

SLASH_CRONOS1 = "/cronos"
SlashCmdList["CRONOS"] = function(msg)
  msg = string.lower(msg or "")
  if msg == "reset" then
    CronosDB.point = nil
    ApplyPosition()
    Print("button moved back to its default spot.")
  elseif msg == "show" then
    Restore()
    Print("button shown.")
  else
    Print("Shift + drag the button to move it.")
    Print("/cronos reset - default position")
    Print("/cronos show - force it to show")
  end
end
