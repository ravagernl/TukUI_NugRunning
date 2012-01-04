local ElvUI = ElvUI
local TukUI = TukUI
local NugRunning = NugRunning
local TimerBar = NugRunning and NugRunning.TimerBar
local addonName, addon = ...
local config = addon.config

local function pr(msg)
	print('|cffff0099'..addonName..'|r : ', msg)
end

local function debug(...)
	print('|cffff0099'..addonName..'|r(debug) : ', ...)
end

if not NugRunning then 
	pr('NugRunning could not be found.')
	return
elseif not (TimerBar and NugRunning.ConstructTimerBar) then
	pr('You have an out of date version of NugRunning.')
end

local E, L, DF, T, C
if ElvUI then
	E, L, DF = unpack(ElvUI) --Engine
elseif TukUI then
	T, C, L = unpack(TukUI)
else
	pr('Neither ElvUI or TukUI was found.')
	return
end

--[[==========================================================================
	Creates the timerbar. ==================================================]]
do
	local _ConstructTimerBar = NugRunning.ConstructTimerBar
	function NugRunning.ConstructTimerBar(w, h)
		local f = _ConstructTimerBar(w, h)

		f:SetBackdrop(nil)

		local ic = f.icon:GetParent()
		ic:CreateBackdrop()

		f.bar.bg:Hide()
		f.bar:CreateBackdrop'Transparent'

		f.bar:SetStatusBarTexture(ElvUI and E.media.normTex or C.media.normTex);
		f.bar:GetStatusBarTexture():SetDrawLayer'ARTWORK'

		-- Fonts
		do
			local p, h, s = unpack(config.fontflags)
			if ElvUI then
				f.timeText:FontTemplate(p, h, s)
				f.spellText:FontTemplate(p, h, s)
				f.stacktext:FontTemplate(p, h, s)
			else 
				p = p or C.media.uffont
				f.timeText:SetFont(p, h, s)
				f.spellText:SetFont(p, h, s)
				f.stacktext:SetFont(p, h, s)
			end
		end

		-- Force correct position of bar/icon
		TimerBar.Resize(f, w, h)

		return f
	end
end

--[[==========================================================================
	Resizes the timerbar and applies the correct anchoring. ================]]
do
	local _Resize = TimerBar.Resize
	function TimerBar.Resize(f, w, h)
		_Resize(f, w, h)

		-- Icon auto scales width :D
		local ic = f.icon:GetParent()
		ic:ClearAllPoints()
		ic:Point('TOPLEFT', f, 1, -1)
		ic:Point('BOTTOMLEFT', f, 1, 0)

		f.bar:ClearAllPoints()
		f.bar:Point('TOPRIGHT', f, -1, -1)
		f.bar:Point('BOTTOMRIGHT', f, -1, 0)
		f.bar:Point('LEFT', ic, 'RIGHT', 5, 0)

		-- Time on left
		if config.timeonleft then
			f.timeText:SetJustifyH'LEFT'
			f.timeText:ClearAllPoints()
			f.timeText:Point('LEFT', 5, 0)

			f.spellText:ClearAllPoints()
			f.spellText:Point('LEFT', f.bar)
			f.spellText:Point('RIGHT', f.bar)
			f.spellText:SetWidth(f.bar:GetWidth())
		end

		-- visual stacks
		if f.visualstacks then
			for k, tex in pairs(f.visualstacks) do
				debug(k, tex)
			end
		end
	end
end

--[[==========================================================================
	OnUpdate function, for better time formatting. =========================]]
do
	local day, hour, minute = 86400, 3600, 60
	local color = config.color
	local decimals = config.decimals or 5

	local floor = math.floor
	local function round(num, idp)
		local mult = 10^(idp or 0)
		return floor(num * mult + 0.5) / mult
	end

	function TimerBar.Update(f, s)
		f.bar:SetValue(s + f.startTime)
		local time = f.timeText
		if s >= day then
			time:SetFormattedText('%d%sd|r', round(s / day), color)
		elseif s >= hour then
			time:SetFormattedText('%d%sh|r', round(s / hour), color)
		elseif s >= minute * 1 then
			time:SetFormattedText('%d%sm|r', round(s / minute), color)
		elseif s >= decimals then
			time:SetFormattedText('%d', s)
		elseif s >= 0 then
			time:SetFormattedText('%.1f', s)
		else
			time:SetText(0)
		end
	end
end

--[[==========================================================================
	Aura stacks (for example lifebloom or deadly poison ====================]]
if config.visualstacks then do
	local defaultColor = {1, 1, 0}
	function TimerBar.SetCount(self,amount)
	if not amount then return end -- attempt to compare number with nil :/
		local stacks = self.visualstacks
		if not stacks then
			stacks = CreateFrame('FRAME', nil, self.bar)
			stacks:SetTemplate()
			stacks:Point(config.timeonleft and 'RIGHT' or 'LEFT', config.timeonleft and -2 or 2, 0)
			stacks:Point('TOP', 0, -2)
			stacks:Point('BOTTOM', 0, 2)
			stacks.tex = {}
			self.visualstacks = stacks
		end
		if amount > 1 and amount <= config.visualstacksmax then
			local width = (config.visualstackwidth*amount)+(amount-1)+4
			stacks:Width(width)
			stacks:Show()
			for i = 1, amount do
				if not stacks.tex[i] then
					local tex = stacks:CreateTexture(nil, 'ARTWORK')
					tex:SetTexture(ElvUI and E.media.normTex or C.media.normTex)
					tex:Point('TOP', 0, -2)
					tex:Point('BOTTOM', 0, 2)
					if i == 1 then
						tex:Point('RIGHT', -2, 0)
					else
						tex:Point('RIGHT', stacks.tex[i-1], 'LEFT', -1, 0)
					end
					tex:SetWidth(config.visualstackwidth)
					stacks.tex[i] = tex
				end
				local r,g,b = unpack(self.opts.stackcolor and self.opts.stackcolor[i] or defaultColor)
				stacks.tex[i]:SetVertexColor(r,g,b)
				stacks.tex[i]:Show()
			end
			-- Hide stack textures that are not needed
			for i = amount+1, config.visualstacksmax do
				if not stacks.tex[i] then break end
				stacks.tex[i]:Hide()
			end
		else
			stacks:Hide()
		end
		-- Handle text
		if amount < 1 or amount < config.visualstacksmax then
			self.stacktext:Hide()
		else
			self.stacktext:SetText(amount)
			self.stacktext:Show()
		end
	end
end end

pr('Loaded.')