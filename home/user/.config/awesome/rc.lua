-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err) })
        in_error = false
    end)
end


-- Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/daniel/.config/awesome/theme.lua")

-- Default terminal 
terminal = "alacritty"
rofi = "rofi -drun-display-format {name} -show drun"

-- Default modkey.
modkey = "Mod4"

local screenRotation = "normal"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.top
}


-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
beautiful.useless_gap = 5
beautiful.gap_single_client = true
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)

screen.connect_signal("property::geometry", set_wallpaper)

-- Topbar and widgets


awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "一", "二", "三", "四", "五"}, s, awful.layout.layouts[1])

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        style = {
            shape = function(cr, width, height)
              gears.shape.squircle(cr, width, height, 1.3, 0)
            end,
          },
        widget_template = {
        {
            {
            id = "text_role",
            widget = wibox.widget.textbox,
            },
            left = 7,
            right = 7,
            widget = wibox.container.margin,
        },
        id = "background_role",
        widget = wibox.container.background,
        create_callback = function(self, c3, index, objects) --luacheck: no unused args
            self:connect_signal("mouse::enter", function()
            if #c3:clients() > 0 then
                awesome.emit_signal("bling::tag_preview::update", c3)
                awesome.emit_signal("bling::tag_preview::visibility", s, true)
            end
            end)
            self:connect_signal("mouse::leave", function()
            awesome.emit_signal("bling::tag_preview::visibility", s, false)
    
            if self.has_backup then
                self.bg = self.backup
            end
            end)
        end,
        }       
    }


    awful.popup({
        bg = beautiful.none,
        screen = s,
        placement = function(c)
          (awful.placement.top + awful.placement.maximize_horizontally)(
            c,
            { margins = { top = 10, left = 10, right = 10 } }
          )
        end,
        shape = gears.shape.rect,
        widget = {
            layout = wibox.layout.align.horizontal,
            forced_height = 20,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                -- mytaglist,
                {
                    {
                      {
                        widget = s.mytaglist,
                      },
                      widget = wibox.container.margin,
                      left = 10,
                      right = 10
                    },
                    widget = wibox.container.background,
                    bg = beautiful.bg_normal,
                    shape = function(cr, width, height)
                      gears.shape.rounded_rect(cr, width, height, 180)
                    end,
                }
                
            },
            nil,
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                spacing = 10,
                -- wibox.widget.systray(),
                -- wibox.widget.textclock(),
                {
                    bg = beautiful.bg_normal,
                    shape = function(cr, width, height)
                      gears.shape.rounded_rect(cr, width, height, 180)
                    end,
                    widget = wibox.container.background,
                    {
                        {
                          widget = wibox.widget.systray(),
                        },
                        widget = wibox.container.margin,
                        left = 10,
                        right = 10
                      },
                },
                {
                    bg = beautiful.bg_normal,
                    shape = function(cr, width, height)
                      gears.shape.rounded_rect(cr, width, height, 180)
                    end,
                    widget = wibox.container.background,
                    {
                        {
                          widget = awful.widget.watch("dash -c \"echo $(cat /sys/class/power_supply/BAT1/capacity) パーセント\"", 60),
                        },
                        widget = wibox.container.margin,
                        left = 10,
                        right = 10
                      },
                },
                {
                    bg = beautiful.bg_normal,
                    shape = function(cr, width, height)
                      gears.shape.rounded_rect(cr, width, height, 180)
                    end,
                    widget = wibox.container.background,
                    {
                        {
                          widget = wibox.widget.textclock("%-d日 %-m月 %-I時 %-M分"),
                        },
                        widget = wibox.container.margin,
                        left = 10,
                        right = 10
                      },
                }
            },
        },
    }):struts { top = 30 }

end)



-- Key bindings

globalkeys = gears.table.join(

    awful.key({ modkey }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),

    awful.key({ modkey }, "s", function() awful.spawn(rofi) end,
        { description = "open rofi", group = "launcher" }),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),

    awful.key({}, "XF86MonBrightnessDown", function() awful.spawn("xbacklight -dec 15") end,
        { description = "decrease brightness", group = "launcher" }),

    awful.key({}, "XF86MonBrightnessUp", function() awful.spawn("xbacklight -inc 15") end,
        { description = "increase brightness", group = "launcher" }),

    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn("amixer -q sset Master 3%-") end,
        { description = "decrease volume", group = "launcher" }),

    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn("amixer -q sset Master 3%+") end,
        { description = "increase volume", group = "launcher" }),

    awful.key({}, "Print", function() awful.spawn("xfce4-screenshooter") end,
        { description = "screenshot menu", group = "launcher" })
)

clientkeys = gears.table.join(

    awful.key({ modkey }, "w", function(c) c:kill() end,
        { description = "close", group = "client" }),

    awful.key({ modkey }, "a", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),

    awful.key({ modkey }, "Tab", function(c) c:move_to_screen() end,
        { description = "move to other screen", group = "client" })

)

-- Bind all key numbers to tags.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys

root.keys(globalkeys)


-- Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = {},
        properties = { border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            maximized_vertical   = false,
            maximized_horizontal = false,
            floating = false,
            maximized = false

        }
    },

    -- Floating clients.
    { rule_any = {
        type = {"utility", "notification", "toolbar", "splash", "dialog"},
        is_fixed = {true},
        instance = {
            "DTA", -- Firefox addon DownThemAll.
            "copyq", -- Includes session name in class.
            "pinentry",
        },
        class = {
            "Arandr",
            "Blueman-manager",
            "Xfce4-screenshooter",
            "Xfce4-clipman",
            "Gpick",
            "Kruler",
            "MessageWin", -- kalarm.
            "Sxiv",
            "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
            "Wpa_gui",
            "veromix",
            "xtightvncviewer" },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
            "Event Tester", -- xev.
        },
        role = {
            "AlarmWindow", -- Thunderbird's calendar.
            "ConfigManager", -- Thunderbird's about:config.
            "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
        }
    }, properties = { floating = true, placement = awful.placement.centered } },



}


-- Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)


-- Signal function to keep floating windoes allways on top
client.connect_signal("property::floating", function(c)
    if c.floating then
        c.ontop = true
    else
        c.ontop = false
    end
end)



-- Enable sloppy focus, so that focus follows mouse.

client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


-- Autostart applications

awful.spawn.with_shell("picom &")
awful.spawn.with_shell("/usr/bin/gnome-keyring-daemon --start --components=pkcs11 &")
awful.spawn.with_shell("nm-applet &")
awful.spawn.with_shell("xfce4-clipman &")
awful.spawn.with_shell("xfce4-power-manager &")
awful.spawn.with_shell("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &")
awful.spawn.with_shell("prime-offload &")
awful.spawn.with_shell("optimus-manager-qt &")


