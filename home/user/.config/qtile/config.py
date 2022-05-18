from libqtile import bar, layout, widget, hook
from libqtile.config import (
    Group,
    Key,
    Match,
    Screen,
    Drag,
    Click,
)
from libqtile.lazy import lazy
import os
import subprocess

mod = "mod4"
terminal = "alacritty"
marginSize = 8

# defines color pallete
pallete = {
    "black1": "#1A1826",
    "black2": "#1E1E2E",
    "black3": "#302D41",
    "gray": "#C3BAC6",
    "blue": "#96CDFB",
    "transparent": "#1A182600",
}

# define hooks
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.call([home])


keys = [
    # Move windows.
    Key(
        [mod, "shift"],
        "Left",
        lazy.layout.shuffle_left(),
    ),
    Key(
        [mod, "shift"],
        "Right",
        lazy.layout.shuffle_right(),
    ),
    Key(
        [mod, "shift"],
        "Down",
        lazy.layout.shuffle_down(),
    ),
    Key(
        [mod, "shift"],
        "Up",
        lazy.layout.shuffle_up(),
    ),
    # Grow windows.
    Key(
        [mod, "control"],
        "Left",
        lazy.layout.grow_left(),
    ),
    Key(
        [mod, "control"],
        "Right",
        lazy.layout.grow_right(),
    ),
    Key(
        [mod, "control"],
        "Down",
        lazy.layout.grow_down(),
    ),
    Key(
        [mod, "control"],
        "Up",
        lazy.layout.grow_up(),
    ),
    # Miscellaneous.
    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod], "w", lazy.window.kill()),
    Key([mod, "control"], "r", lazy.restart()),
    Key(
        [mod],
        "s",
        lazy.spawn("rofi -drun-display-format {name} -show drun"),
    ),
    # Brightness.
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn("brightnessctl -s set 2%+"),
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn("brightnessctl -s set 2%-"),
    ),
    # Volume.
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
    ),
    # PrintScreen
    Key(
        [],
        "Print",
        lazy.spawn("xfce4-screenshooter"),
    ),
]

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod],
        "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click(
        [mod],
        "Button2",
        lazy.window.toggle_floating(),
    ),
]

# Generate custom group icons
keyGroups = {
    1: Group("一"),
    2: Group("二"),
    3: Group("三"),
    4: Group("四"),
    5: Group("五"),
    6: Group("六"),
}
groups = [keyGroups[i] for i in keyGroups]


def getGroupKey(name):
    return [k for k, g in keyGroups.items() if g.name == name][0]


# Group settings
for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                str(getGroupKey(i.name)),
                lazy.group[i.name].toscreen(),
            ),
            # mod + shift + letter of group = switch to
            # & move to group
            Key(
                [mod, "shift"],
                str(getGroupKey(i.name)),
                lazy.window.togroup(i.name),
            ),
        ]
    )

# Layout settings
layouts = [
    layout.Columns(
        border_width=0,
        margin=marginSize,
        margin_on_single=marginSize,
        fair=True,
    )
]

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm
        # class and name.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
        Match(wm_class="zoom"),
    ],
    border_width=0,
)

# Bar widget defaults
widget_defaults = dict(
    font="DejaVu",
    fontsize=12,
    background=pallete["black1"],
    foreground=pallete["gray"],
)
extension_defaults = widget_defaults.copy()


# Bar settings
screens = [
    Screen(
        bottom=bar.Gap(marginSize),
        left=bar.Gap(marginSize),
        right=bar.Gap(marginSize),
        top=bar.Bar(
            [
                # left
                widget.GroupBox(
                    margin_y=2,
                    margin_x=4,
                    padding_y=5,
                    padding_x=6,
                    borderwidth=3,
                    rounded=False,
                    disable_drag=True,
                    hide_unused=True,
                    highlight_method="text",
                    active=pallete["gray"],
                    this_current_screen_border=pallete["blue"],
                ),
                widget.TextBox(
                    text="\ue0b0",
                    background=pallete["transparent"],
                    foreground=pallete["black1"],
                    padding=0,
                    fontsize=43,
                ),
                widget.Spacer(
                    lenght=bar.STRETCH,
                    background=pallete["transparent"],
                ),
                # right
                widget.WidgetBox(
                    widgets=[
                        widget.Systray(
                            padding=6,
                            icon_size=16,
                            background=pallete["transparent"],
                        ),
                        widget.Sep(
                            linewidth=0,
                            background=pallete["transparent"],
                            padding=6,
                        ),
                    ],
                    close_button_location="right",
                    fontsize=43,
                    text_closed="\ue0b2",
                    text_open="\ue0b2",
                    foreground=pallete["black3"],
                    background=pallete["transparent"],
                ),
                widget.WidgetBox(
                    widgets=[
                        widget.TextBox(
                            text="バッテリー",
                            background=pallete["black2"],
                        ),
                        widget.Battery(
                            format="{percent:2.0%}",
                            show_short_text=False,
                            full_char="100%",
                            background=pallete["black2"],
                        ),
                    ],
                    close_button_location="left",
                    text_closed="\ue0b2",
                    text_open="\ue0b2",
                    fontsize=43,
                    foreground=pallete["black2"],
                    background=pallete["black3"],
                ),
                widget.TextBox(
                    text="\ue0b2",
                    background=pallete["black2"],
                    foreground=pallete["black1"],
                    padding=0,
                    fontsize=43,
                ),
                widget.Clock(
                    format="%m月%d日 %I:%M",
                    padding=10,
                ),
            ],
            24,
            margin=[0, 0, marginSize, 0],
            background=pallete["transparent"],
        ),
    )
]

follow_mouse_focus = False
focus_on_window_activation = "never"
wmname = "Qtile"
