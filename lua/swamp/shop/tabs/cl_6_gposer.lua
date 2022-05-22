﻿SS_Tab({
    name = "GPoser",
    icon = "hand-peace",
    pos = "bottom",
    class = "DSSGPoserMode",
})

vgui.Register('DSSGPoserMode', {
    Init = function(self)
        local mode = self
        self:DockPadding(100, 100, 100, 100)

        -- vgui("Panel", self, function(p)
        --     p:SetTall(32)
        --     p:Dock(TOP)
        --     p:DockMargin(0, 0, 0, 8)
        --     vgui("DLabel", function(p)
        --         p:SetWide(100)
        --         p:Dock(LEFT)
        --         p:SetText("Theme color")
        --     end)
        --     for k, v in pairs(BrandColors) do
        --         vgui("DButton", function(p)
        --             p:DockMargin(4, 4, 4, 4)
        --             p:SetWide(24)
        --             p:Dock(LEFT)
        --             p:SetText("")
        --             function p:Paint(w, h)
        --                 surface.SetDrawColor(GetConVar("ps_themecolor"):GetInt() == k and Color(255, 255, 255) or Color(64, 64, 64))
        --                 surface.DrawRect(2, 2, w - 4, w - 4)
        --                 surface.SetDrawColor(v)
        --                 surface.DrawRect(4, 4, w - 8, w - 8)
        --             end
        --             function p:DoClick()
        --                 GetConVar("ps_themecolor"):SetInt(k)
        --             end
        --         end)
        --     end
        -- end)
        vgui("SLabel", self, function(p)
            p:SetText("GPoser")
            p:SetFont("DermaLarge")
            p:SetContentAlignment(5)
            p:Dock(TOP)
            -- p:SizeToContents()
            p:SetTall(40)
        end)

        vgui("SLabel", self, function(p)
            p:SetText("Control your entire playermodel using just your webcam!")
            p:SetFont(Font.Roboto24)
            p:SetContentAlignment(5)
            p:Dock(TOP)
            -- p:SizeToContents()
            p:SetTall(40)
        end)

        local exists, existstime = false, -100

        vgui("DButton", self, function(p)
            p:SetFont("DermaLarge")
            p:SetContentAlignment(5)
            p:SetTextColor(Color.black)
            p:Dock(TOP)
            p:SetTall(40)

            function p:Think()
                if GPoserVersion == "0.2" then
                    self:SetVisible(false)
                else
                    if mode.FileExists then
                        self:SetText("Start GPoser")

                        function self:DoClick()
                            RunConsoleCommand("gposer")
                        end
                    else
                        function self:DoClick()
                            gui.OpenURL("https://github.com/swampservers/gposer")
                        end

                        self:SetText(GPoserVersion and "Please update!" or "Download Now!")
                    end
                end
            end
        end)

        vgui("SLabel", self, function(p)
            p:SetFont(Font.Roboto32)
            p:SetContentAlignment(5)
            p:Dock(TOP)
            p:SetTall(80)

            function p:Think()
                if GPoserVersion then
                    self:SetText("GPoser v" .. GPoserVersion .. "\n" .. GPoserState)
                else
                    self:SetText("")
                end
            end
        end)

        local pstate = 1
        local qstate = 1
        local estate = -6

        self.b1 = vgui("DButton", self, function(p)
            p:SetText("Toggle Preview")
            p:SetFont(Font.Roboto28)
            p:SetContentAlignment(5)
            p:SetTextColor(Color.black)
            p:Dock(TOP)
            p:SetTall(32)

            function p:DoClick()
                pstate = 1 - pstate
                RunConsoleCommand("gposer", "preview", tostring(pstate))
            end
        end)

        self.b2 = vgui("DButton", self, function(p)
            p:SetText("Toggle Quality")
            p:SetFont(Font.Roboto28)
            p:SetContentAlignment(5)
            p:SetTextColor(Color.black)
            p:Dock(TOP)
            p:SetTall(32)

            function p:DoClick()
                qstate = 1 - qstate
                RunConsoleCommand("gposer", "quality", tostring(qstate))
            end
        end)

        self.b3 = vgui("DButton", self, function(p)
            p:SetText("Increase Exposure Time")
            p:SetFont(Font.Roboto28)
            p:SetContentAlignment(5)
            p:SetTextColor(Color.black)
            p:Dock(TOP)
            p:SetTall(32)

            function p:DoClick()
                estate = math.min(-1, estate + 1)
                RunConsoleCommand("gposer", "exposure", estate)
            end
        end)

        self.b4 = vgui("DButton", self, function(p)
            p:SetText("Decrease Exposure Time")
            p:SetFont(Font.Roboto28)
            p:SetContentAlignment(5)
            p:SetTextColor(Color.black)
            p:Dock(TOP)
            p:SetTall(32)

            function p:DoClick()
                estate = math.min(-1, estate - 1)
                RunConsoleCommand("gposer", "exposure", estate)
            end
        end)
    end,
    Think = function(self)
        if (self.FileExistsTime or -100) > CurTime() - 5 then return end
        self.FileExists = file.Exists("lua/bin/gmcl_gposer_win64.dll", "MOD")
        self.FileExistsTime = CurTime()

        for x = 1, 4 do
            self["b" .. x]:SetVisible(GPoserVersion and true or false)
        end
    end,
    Paint = function(self) end
}, 'DSSMode')
