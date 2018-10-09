local PLUGIN = PLUGIN
PLUGIN.name = "Admin Announce"
PLUGIN.author = "Stan"
PLUGIN.desc = "Announce command for admins."

if CLIENT then
    
    local AdminAnnounce = function() end

    net.Receive("adminSayAll", function( len, pl ) 
        timer.Remove("AdminAnnounce")
        local netMessage = net.ReadString()
    
        AdminAnnounce = function()
            draw.RoundedBox(4, 10, 10, ScrW() - 20, 110, Color(0,0,0,100))
            draw.SimpleText("Listen up!", "GModToolName", ScrW() / 2 + 10, 10, Color(255,30,30), 1)
            draw.SimpleText(netMessage, "nutSmallFont", ScrW() / 2 + 10, 90, Color(255,255,255), 1)
        end

        timer.Create("AdminAnnounce", 10, 1, function()
            AdminAnnounce = function() end
        end)

    end)


    function PLUGIN:HUDPaint()
        AdminAnnounce()
    end
    
end

if SERVER then
    util.AddNetworkString( "adminSayAll" )
end
    nut.command.add("adminsay", {
		adminOnly = true,
		syntax = "<string message>",
		onRun = function(client, text)
            net.Start("adminSayAll")
                net.WriteString(text[1])
            net.Broadcast()
		end,
		prefix = {"/adminsay"},
	})
