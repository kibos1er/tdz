-- Animated Solarus logo by Maxs.

-- Usage:
-- local logo = require("menus/solarus_logo")
-- sol.menu.start(logo)
local solarus_logo_menu = {}

-- Main surface of the menu.
--local surface = sol.surface.create(201, 48)

-- Starting the menu.
function solarus_logo_menu:on_started()

    sol.timer.start(solarus_logo_menu, 1, function()
      sol.menu.stop(solarus_logo_menu)
    end)
--    surface:fade_out()
end

-- Return the menu to the caller.
return solarus_logo_menu

