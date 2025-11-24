local AceConfig = LibStub("AceConfig-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDB = LibStub("AceDB-3.0")

local defaults_global = {
    global = {
        Scale = 1,
        RankPriority = {
            [1] = 10,
            [2] = 9,
            [3] = 8,
            [4] = 7,
            [5] = 6,
            [6] = 5,
            [7] = 4,
            [8] = 3,
            [9] = 2,
            [10] = 1,
            [11] = 0,
        }
    }
}

local defaults = {
    global = { },
    profile = {
        RR_Track_Unannounced_Rolls = false,
        RR_RollCheckBox_Auto_Announce = false,
        RR_Accept_All_Rolls = false,
        RR_RollCheckBox_Auto_Close = false,
        RR_AllowExtraRolls = false,
        RR_RollCheckBox_No_countdown = false,
        RR_RollCheckBox_GuildAnnounce = false,
        RR_RollCheckBox_GuildAnnounce_Officer = false,
        RR_RollCheckBox_Multi_Rollers = false,
        RR_Show_Ranks = false,
        RR_ShowClassColors = false,
        RR_ShowGroupNumber = false,
        Scale = 1,
        RR_ExtraWidth = 0,
        Time_Offset = 60,
        RR_EPGP_Enabled = false,
        RR_EPGP_Priority = false,
        RR_RollCheckBox_Enable_Alt_Mode = false,
        RR_RankPriority = false,
        Raid_Roll_SetMsg1_EditBox = "Roll [Item] Main Spec",
        Raid_Roll_SetMsg2_EditBox = "Roll [Item] Off Spec",
        Raid_Roll_SetMsg3_EditBox = "Roll [Item] Off Spec",
        RR_AutoOpenLootWindow = true,
        RR_ReceiveGuildMessages = false,
        RR_Enable3Messages = false,
        RR_Frame_WotLK_Dung_Only = false
    },
}

-- Initialization of configuration options
function RaidRoll:OnInitialize()

    self.globalDB = LibStub("AceDB-3.0"):New("RaidRoll_DB", defaults_global)
    self.db = AceDB:New("RaidRoll_DBPC", defaults, true)
    
    if self.globalDB["Rank Priority"] ~= nil and self.globalDB["RankPriority"] == nil then
        self.globalDB["RankPriority"] = self.globalDB["Rank Priority"]
        self.globalDB["Rank Priority"] = nil
    end

    local options_general = {
        name = "Raid Roll",
        handler = self,
        type = "group",
        args = {
            row1 = {
                type = "group",
                inline = true,
                name = RAIDROLL_LOCALE["General_Settings"],
                order = 10,
                args = {
                    trackUnannouncedRolls = {
                        name = RAIDROLL_LOCALE["Catch_Unannounced_Rolls"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_Unannounced_panel"],
                        type = "toggle",
                        get = function() return self.db.profile.RR_Track_Unannounced_Rolls end,
                        set = function(_, value)
                            self.db.profile.RR_Track_Unannounced_Rolls = value
                            self:UpdateDisplay() 
                        end,
                        order = 1,
                    },
                    rollCheckBoxAutoAnnounce = {
                        name = RAIDROLL_LOCALE["Auto_Announce_Count"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_Auto_Announce"],
                        type = "toggle",
                        get = function() return self.db.profile.RR_RollCheckBox_Auto_Announce end,
                        set = function(_, value)
                            self.db.profile.RR_RollCheckBox_Auto_Announce = value
                            self:UpdateDisplay() 
                        end,
                        order = 2,
                    },
                    acceptAllRolls = {
                        name = RAIDROLL_LOCALE["Allow_all_rolls"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_AllRolls_panel"],
                        type = "toggle",
                        get = function() return self.db.profile.RR_Accept_All_Rolls end,
                        set = function(_, value)
                            self.db.profile.RR_Accept_All_Rolls = value
                            self:UpdateDisplay() 
                        end,
                        order = 3,
                    },
                    rollCheckBoxAutoClose = {
                        name = RAIDROLL_LOCALE["Auto_Close_Window"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_Auto_Close"],
                        type = "toggle",
                        get = function() return self.db.profile.RR_RollCheckBox_Auto_Close end,
                        set = function(_, value)
                            self.db.profile.RR_RollCheckBox_Auto_Close = value
                            self:UpdateDisplay() 
                        end,
                        order = 4,
                    },
                    allowExtraRolls = {
                        name = RAIDROLL_LOCALE["Allow_Extra_Rolls"],
                        desc = RAIDROLL_LOCALE["RaidRollCheckBox_ExtraRolls_panel"],
                        type = "toggle",
                        get = function() return self.db.profile.RR_AllowExtraRolls end,
                        set = function(_, value)
                            self.db.profile.RR_AllowExtraRolls = value
                            self:UpdateDisplay() 
                        end,
                        order = 5,
                    },
                    rollCheckBoxNoCountdown = {
                        name = RAIDROLL_LOCALE["No_countdown"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_No_countdown"],
                        type = "toggle",
                        get = function() return self.db.profile.RR_RollCheckBox_No_countdown end,
                        set = function(_, value)
                            self.db.profile.RR_RollCheckBox_No_countdown = value
                            self:UpdateDisplay() 
                        end,
                        order = 6,
                    },
                    rollCheckBoxGuildAnnounce = {
                        name = RAIDROLL_LOCALE["Announce_winner_to_guild"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_GuildAnnounce"],
                        type = "toggle",
                        get = function() return self.db.profile.RR_RollCheckBox_GuildAnnounce end,
                        set = function(_, value)
                            self.db.profile.RR_RollCheckBox_GuildAnnounce = value
                            if value == false then
                                self.db.profile.RR_RollCheckBox_GuildAnnounce_Officer = false
                            end
                            self:UpdateDisplay() 
                        end,
                        order = 7,
                    },
                    rollCheckBoxGuildAnnounceOfficer = {
                        name = RAIDROLL_LOCALE["Use_officer_channel"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_GuildAnnounce_Officer"],
                        type = "toggle",
                        disabled = function(info)
                            return not self.db.profile.RR_RollCheckBox_GuildAnnounce
                        end,
                        get = function() return self.db.profile.RR_RollCheckBox_GuildAnnounce_Officer end,
                        set = function(_, value)
                            self.db.profile.RR_RollCheckBox_GuildAnnounce_Officer = value
                            self:UpdateDisplay() 
                        end,
                        order = 8,
                    },
                    rollCheckBoxMultiRollers = {
                        name = RAIDROLL_LOCALE["Multi_Rollers"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_Multi_Rollers"],
                        type = "toggle",
                        get = function() return self.db.profile.RR_RollCheckBox_Multi_Rollers end,
                        set = function(_, value)
                            self.db.profile.RR_RollCheckBox_Multi_Rollers = value
                            self:UpdateDisplay() 
                        end,
                        order = 9,
                    },
                },
            },
            row2 = {
                type = "group",
                inline = true,
                name = RAIDROLL_LOCALE["Raid_Roll_Display_Settings"],
                order = 20,
                args = {
                    showRanks = {
                        name = RAIDROLL_LOCALE["Show_Rank_Beside_Name"],
                        desc = RAIDROLL_LOCALE["RaidRollCheckBox_ShowRanks_panel"],
                        type = "toggle",
                        get = function() return self.db.profile.RR_Show_Ranks end,
                        set = function(_, value)
                            self.db.profile.RR_Show_Ranks = value
                            self:UpdateDisplay() 
                        end,
                        order = 1,
                    },
                    showClassColors = {
                        name = RAIDROLL_LOCALE["Show_Class_Colors"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_ShowClassColors_panel"],
                        type = "toggle",
                        get = function() return self.db.profile.RR_ShowClassColors end,
                        set = function(_, value)
                            self.db.profile.RR_ShowClassColors = value
                            self:UpdateDisplay() 
                        end,
                        order = 2,
                    },
                    showGroupNumber = {
                        name = RAIDROLL_LOCALE["Show_Group_Beside_Name"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_ShowGroupNumber_panel"],
                        type = "toggle",
                        get = function() return self.db.profile.RR_ShowGroupNumber end,
                        set = function(_, value)
                            self.db.profile.RR_ShowGroupNumber = value
                            self:UpdateDisplay() 
                        end,
                        order = 3,
                    },
                    rankScaleSlider = {
                        name = RAIDROLL_LOCALE["Set_Scale"],
                        desc = nil,
                        type = "range",
                        min = 0.01,
                        max = 2,
                        step = 0.01,
                        get = function()
                            return self.globalDB.global.Scale or 1
                        end,
                        set = function(_, value)
                            self.globalDB.global.Scale = value
                            self:UpdateDisplay()
                        end,
                        isPercent = true,
                        order = 4,
                    },
                    rankWidthSlider = {
                        name = RAIDROLL_LOCALE["Set_Extra_Rank_Width"],
                        desc = nil,
                        type = "range",
                        min = 0,
                        max = 200,
                        step = 1,
                        get = function()
                            return self.db.profile.RR_ExtraWidth or 0
                        end,
                        set = function(_, value)
                            self.db.profile.RR_ExtraWidth = value
                            self:UpdateDisplay()
                        end,
                        order = 5,
                    },
                    rollingTimeSlider = {
                        name = RAIDROLL_LOCALE["Set_Rolling_Time"],
                        desc = nil,
                        type = "range",
                        min = 5,
                        max = 120,
                        step = 1,
                        get = function()
                            return self.db.profile.Time_Offset or 0
                        end,
                        set = function(_, value)
                            self.db.profile.Time_Offset = value
                            self:UpdateDisplay()
                        end,
                        order = 7,
                    },
                },
            },
            row3 = {
                type = "group",
                inline = true,
                name = RAIDROLL_LOCALE["Raid_Roll_EPGP_Settings"],
                order = 30,
                args = {
                    ePGPEnabled = {
                        name = RAIDROLL_LOCALE["Enable_EPGP_mode"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_EPGPMode_panel"],
                        type = "toggle",
                        get = function() return self.db.profile.RR_EPGP_Enabled end,
                        set = function(_, value)
                            self.db.profile.RR_EPGP_Enabled = value
                            if value == false then
                                self.db.profile.RR_EPGP_Priority = false
                                self.db.profile.RR_RollCheckBox_Enable_Alt_Mode = false
                            end
                            self:UpdateDisplay() 
                        end,
                        order = 1,
                    },
                    ePGPPriority = {
                        name = RAIDROLL_LOCALE["Enable_threshold_levels"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_EPGPThreshold_panel"],
                        type = "toggle",
                        disabled = function(info)
                            return not self.db.profile.RR_EPGP_Enabled
                        end,
                        get = function() return self.db.profile.RR_EPGP_Priority end,
                        set = function(_, value)
                            self.db.profile.RR_EPGP_Priority = value
                            self:UpdateDisplay() 
                        end,
                        order = 2,
                    },
                    rollCheckBoxEnableAltMode = {
                        name = RAIDROLL_LOCALE["Enable_Alt_Mode"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_Enable_Alt_Mode"],
                        type = "toggle",
                        disabled = function(info)
                            return not self.db.profile.RR_EPGP_Enabled
                        end,
                        get = function() return self.db.profile.RR_RollCheckBox_Enable_Alt_Mode end,
                        set = function(_, value)
                            self.db.profile.RR_RollCheckBox_Enable_Alt_Mode = value
                            self:UpdateDisplay() 
                        end,
                        order = 3,
                    },
                },
            },
            row4 = {
                type = "group",
                inline = true,
                name = RAIDROLL_LOCALE["Raid_Roll_Misc_Settings"],
                order = 40,
                args = {
                    rollCheckBoxTrackBids = {
                        name = RAIDROLL_LOCALE["Track_Bids"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_Track_Bids"],
                        type = "toggle",
                        get = function() return self.db.profile.RR_RollCheckBox_Track_Bids end,
                        set = function(_, value)
                            self.db.profile.RR_RollCheckBox_Track_Bids = value
                            if value == false then
                                self.db.profile.RR_RollCheckBox_Num_Not_Req = false
                            end
                            self:UpdateDisplay() 
                        end,
                        order = 1,
                    },
                    rollCheckBoxNumNotReq = {
                        name = RAIDROLL_LOCALE["Number not required"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_Num_Not_Req"],
                        type = "toggle",
                        disabled = function(info)
                            return not self.db.profile.RR_RollCheckBox_Track_Bids
                        end,
                        get = function() return self.db.profile.RR_RollCheckBox_Num_Not_Req end,
                        set = function(_, value)
                            self.db.profile.RR_RollCheckBox_Num_Not_Req = value
                            self:UpdateDisplay() 
                        end,
                        order = 2,
                    },
                    rollCheckBoxTrackEPGPSays = {
                        name = RAIDROLL_LOCALE["Track_EPGPSays"],
                        desc = RAIDROLL_LOCALE["RR_RollCheckBox_Track_EPGPSays"],
                        type = "toggle",
                        get = function() return self.db.profile.RR_RollCheckBox_Track_EPGPSays end,
                        set = function(_, value)
                            self.db.profile.RR_RollCheckBox_Track_EPGPSays = value
                            self:UpdateDisplay() 
                        end,
                        order = 3,
                    },
                },
            },
        },
    }

    AceConfig:RegisterOptionsTable("RaidRoll", options_general, 'raidroll')
    self:BuildPriorityOptions()
    self:BuildLootOptions()

    AceConfigDialog:AddToBlizOptions("RaidRoll", "Raid Roll")
	AceConfigDialog:AddToBlizOptions("Priority", RAIDROLL_LOCALE["OPTIONSTITLE_MENU1"], "Raid Roll")
    AceConfigDialog:AddToBlizOptions("LootWindow", RAIDROLL_LOCALE["OPTIONSTITLE_MENU2"], "Raid Roll")

    self:UpdateDisplay()

end

-- Update the different interface components
function RaidRoll:UpdateDisplay()

    -- Initialize variables
    local profile = self.db.profile
    local extraWidth = profile.RR_ExtraWidth or 0
    local scaleValue = self.globalDB.global.Scale or 1.0
    local showRanks = profile.RR_Show_Ranks
    local showGroupNumber = profile.RR_ShowGroupNumber
    local baseFrameWidth
    local baseRolledX
    local baseGroup0X
    local groupWidthAdjustment = 0

    -- Synchronization of legacy checkboxes
    local trackRolls = profile.RR_Track_Unannounced_Rolls or false
    local allowAll = profile.RR_Accept_All_Rolls or false
    local extraRolls = profile.RR_AllowExtraRolls or false

    if RaidRoll_Catch_All then
        RaidRoll_Catch_All:SetChecked(trackRolls)
    end
    
    if RaidRoll_Allow_All then
        RaidRoll_Allow_All:SetChecked(allowAll)
    end
    
    if RR_RollCheckBox_ExtraRolls then
        RR_RollCheckBox_ExtraRolls:SetChecked(extraRolls)
    end

    -- Apply the global scale
    RR_RollFrame:SetScale(scaleValue);

    -- Rank Visibility
    if showRanks then
        baseFrameWidth = 265
        baseRolledX    = 170
        baseGroup0X    = 220
        for i = 0, 5 do
            local rankString = _G["Raid_Roll_Rank_String" .. i]
            if rankString then
                rankString:Show()
            end
        end
    else
        baseFrameWidth = 215
        baseRolledX    = 120
        baseGroup0X    = 170
        for i = 0, 5 do
            local rankString = _G["Raid_Roll_Rank_String" .. i]
            if rankString then
                rankString:Hide()
            end
        end
    end

    -- Group Visibility
    if showGroupNumber then
        for i = 0, 5 do
            local groupFrame = _G["RR_Group" .. i]
            if groupFrame then
                groupFrame:Show()
            end
        end
    else
        for i = 0, 5 do 
            local groupFrame = _G["RR_Group" .. i]
            if groupFrame then
                groupFrame:Hide()
            end
        end
        groupWidthAdjustment = -30
    end
    
    RR_RollFrame:SetWidth(baseFrameWidth + extraWidth + groupWidthAdjustment)
    _G["RR_Rolled"]:ClearAllPoints()
    _G["RR_Rolled"]:SetPoint("TOPLEFT", RR_RollFrame, "TOPLEFT", baseRolledX + extraWidth, -30)
    
    _G["RR_Group0"]:ClearAllPoints()
    _G["RR_Group0"]:SetPoint("TOPLEFT", RR_RollFrame, "TOPLEFT", baseGroup0X + extraWidth, -30)
    
    for i = 1, 5 do
        local rankString = _G["Raid_Roll_Rank_String" .. i]
        if rankString then
            rankString:SetWidth(65 + extraWidth) 
        end
    end
    
    if RaidRoll_LootTrackerLoaded == true then
        if self.db.profile.RR_Enable3Messages == true then
            for i = 1,4 do
				_G["RR_Loot_Announce_1_Button_"..i]:SetWidth(33)
				_G["RR_Loot_Announce_2_Button_"..i]:SetWidth(33)
				_G["RR_Loot_Announce_3_Button_"..i]:Show()
                RR_Loot_Display_Refresh()
			end
        else
            for i = 1,4 do
				_G["RR_Loot_Announce_1_Button_"..i]:SetWidth(50)
				_G["RR_Loot_Announce_2_Button_"..i]:SetWidth(50)
				_G["RR_Loot_Announce_3_Button_"..i]:Hide()
                RR_Loot_Display_Refresh()
			end
        end
    end

    rr_RollSort(rr_CurrentRollID) 
    
    if RR_HasDisplayedAlready ~= nil then
        RR_Display(rr_CurrentRollID)
    end
    
end

-- Build priority configuration options
function RaidRoll:BuildPriorityOptions()
    local rankLabels = {}
    if IsInGuild() then
        for i = 1, 10 do
            rankLabels[i] = "#"..i.." : " .. (GuildControlGetRankName(i) or (RAIDROLL_LOCALE["Tooltip_LabelPriorityHigherRanks"]..i))
        end
    else
        for i = 1, 10 do
            rankLabels[i] = "#"..i
        end
    end
    rankLabels[11] = RAIDROLL_LOCALE["Not_in_Guild"]

    local options_priority = {
        name = "Raid Roll",
        handler = self,
        type = "group",
        args = {
            rankPriorityToggle = {
                name = RAIDROLL_LOCALE["Option_PriorityHigherRanks"],
                desc = RAIDROLL_LOCALE["Tooltip_PriorityHigherRanks"],
                type = "toggle",
                order = 1,
                get = function() return self.db.profile.RR_RankPriority or false end,
                set = function(_, val)
                    self.db.profile.RR_RankPriority = val
                    self:UpdateDisplay() 
                end,
            },
            spacer = {
                type = "header",
                name = RAIDROLL_LOCALE["Header_PriorityHigherRanks"],
                order = 2,
            },
        }
    }

    for i = 1, 11 do
        options_priority.args["rankprio_"..i] = {
            name = rankLabels[i],
            desc = RAIDROLL_LOCALE["Tooltip_OpPriorityHigherRanks"],
            type = "range",
            min = 0,
            max = 10,
            step = 1,
            order = 10 + i,
            disabled = function(info)
                return not self.db.profile.RR_RankPriority
            end,
            get = function(info) 
                self.globalDB.global.RankPriority = self.globalDB.global.RankPriority or {}
                return self.globalDB.global.RankPriority[i] or (12 - i)
            end,
            set = function(info, value)
                self.globalDB.global.RankPriority = self.globalDB.global.RankPriority or {}
                self.globalDB.global.RankPriority[i] = value
            end,
            width = "full",
        }
    end

    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Priority", options_priority)
end

-- Build loot configuration options
function RaidRoll:BuildLootOptions()
    local options_loot = {
        name = "Raid Roll",
        handler = self,
        type = "group",
        args = {
            info = {
                type = "description",
                name = function()
                    return (not RaidRoll_LootTrackerLoaded and RAIDROLL_LOCALE["Msg_ModuleLookTracker"]) or ""
                end,
                order = 1,
            },
            row1 = {
                type = "group",
                name = RAIDROLL_LOCALE["Header_LookWindows_Messages"],
                inline = true,
                order = 10,
                hidden = function() return not RaidRoll_LootTrackerLoaded end,
                args = {
                    msg1 = {
                        type = "input",
                        name = RAIDROLL_LOCALE["Set_Msg1"],
                        desc =RAIDROLL_LOCALE["Tooptip_LookWindows_Msg1"],
                        width = "full",
                        order = 1,
                        get = function() return self.db.profile.Raid_Roll_SetMsg1_EditBox or "Roll [Item] Main Spec" end,
                        set = function(_, val)
                            self.db.profile.Raid_Roll_SetMsg1_EditBox = val
                            self:UpdateDisplay() 
                        end,
                    },
                    msg2 = {
                        type = "input",
                        name = RAIDROLL_LOCALE["Set_Msg2"],
                        desc = RAIDROLL_LOCALE["Tooptip_LookWindows_Msg2"],
                        width = "full",
                        order = 2,
                        get = function() return self.db.profile.Raid_Roll_SetMsg2_EditBox or "Roll [Item] Off Spec" end,
                        set = function(_, val)
                                self.db.profile.Raid_Roll_SetMsg2_EditBox = val
                                self:UpdateDisplay() 
                            end,
                    },
                    msg3 = {
                        type = "input",
                        name = RAIDROLL_LOCALE["Set_Msg3"],
                        desc = RAIDROLL_LOCALE["Tooptip_LookWindows_Msg3"],
                        width = "full",
                        order = 3,
                        disabled = function(info)
                            return not self.db.profile.RR_Enable3Messages
                        end,
                        get = function() return self.db.profile.Raid_Roll_SetMsg3_EditBox or "Roll [Item] Off Spec" end,
                        set = function(_, val)
                            self.db.profile.Raid_Roll_SetMsg3_EditBox = val
                            self:UpdateDisplay() 
                        end,
                    },
                    bracket_info = {
                        type = "description",
                        name = RAIDROLL_LOCALE["Use_Item_Brackets"],
                        order = 4,
                        width = "full",
                    },
                },
            },
            row2 = {
                type = "group",
                name = RAIDROLL_LOCALE["General_Settings"],
                inline = true,
                order = 20,
                hidden = function() return not RaidRoll_LootTrackerLoaded end,
                args = {
                    autoOpenLoot = {
                        type = "toggle",
                        name = RAIDROLL_LOCALE["Automatically_open_window_when_new_loot_is_found"],
                        desc = nil,
                        order = 1,
                        width = "full",
                        get = function() return self.db.profile.RR_AutoOpenLootWindow or false end,
                        set = function(_, val)
                            self.db.profile.RR_AutoOpenLootWindow = val
                            self:UpdateDisplay() 
                        end,
                    },
                    receiveGuildMsgs = {
                        type = "toggle",
                        name = RAIDROLL_LOCALE["Receive_loot_messages_from_guild"],
                        desc = nil,
                        order = 2,
                        width = "full",
                        get = function() return self.db.profile.RR_ReceiveGuildMessages or false end,
                        set = function(_, val)
                            self.db.profile.RR_ReceiveGuildMessages = val
                            self:UpdateDisplay() 
                        end,
                    },
                    enable3Messages = {
                        type = "toggle",
                        name = RAIDROLL_LOCALE["RR_Enable3Messages"],
                        desc = nil,
                        order = 3,
                        width = "full",
                        get = function() return self.db.profile.RR_Enable3Messages or false end,
                        set = function(_, val) 
                            self.db.profile.RR_Enable3Messages = val 
                            self:UpdateDisplay() 
                        end,
                    },
                    wotlkOnly = {
                        type = "toggle",
                        name = RAIDROLL_LOCALE["RR_WotLK_Dung_Only"],
                        desc = RAIDROLL_LOCALE["RR_Frame_WotLK_Dung_Only"],
                        order = 4,
                        width = "full",
                        get = function() return self.db.profile.RR_Frame_WotLK_Dung_Only or false end,
                        set = function(_, val)
                            self.db.profile.RR_Frame_WotLK_Dung_Only = val
                            self:UpdateDisplay() 
                        end,
                    },
                },
            },
        },
    }
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("LootWindow", options_loot)
end
