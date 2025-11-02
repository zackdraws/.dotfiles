-- Load WezTerm API
local wezterm = require 'wezterm'

-- Check if the module and required functions are available
if not wezterm then
    error("Unable to load WezTerm API")
end

-- Create configuration object
local config = {
    default_prog = { 'C://msys64//usr//bin//fish.exe',}, 

    color_scheme = 'Flexoki-light',
    enable_tab_bar = false,
    hide_tab_bar_if_only_one_tab = true,  -- Set to true or false
    window_decorations = "RESIZE|TITLE",
    
    window_frame = {
        font = wezterm.font { family = 'Meslo LG L DZ', weight = 'Bold' },  -- Adjust font family if needed
        font_size = 13.0,
        active_titlebar_bg = '#333333',
        inactive_titlebar_bg = '#333333',
    },
    colors = {
        tab_bar = {
            inactive_tab_edge = '#575757',  -- Color of inactive tab bar edge/divider
        },
    },
    window_background_image = "c:/S/EM/O/Ani_0/Ani-LAY/", 
    window_background_image_hsb = {
        brightness = 0.045,  -- Darken the background image to 1/3rd
        hue = 1.0,          -- Keep the hue unchanged
        saturation = 1.0,   -- Keep the saturation unchanged
    },
    window_background_opacity = 1,
    enable_kitty_graphics = true,
    enable_wayland = true,
}

-- Return the configuration to WezTerm
return config
