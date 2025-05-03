import { App, Widget } from 'astal/gtk4';
import { Variable, GLib, bind, Binding } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk4';

import AstalBattery from 'gi://AstalBattery?version=0.1';
import { toggleWindow } from '../../../utils/window';

const battery = AstalBattery.get_default();

export const BatteryIcon = () => {
    const icons = ['󰂎', '󰁺', '󰁻', '󰁼', '󰁽', '󰁾', '󰁿', '󰂀', '󰂁', '󰂂', '󰁹'];
    const chargingIcons = [
        '󰢟',
        '󰢜',
        '󰂆',
        '󰂇',
        '󰂈',
        '󰢝',
        '󰂉',
        '󰢞',
        '󰂊',
        '󰂋',
        '󰂅',
    ];

    const batteryBind = Variable.derive(
        [bind(battery, 'percentage'), bind(battery, 'charging')],
        (percent, isCharging) => {
            const set = isCharging ? chargingIcons : icons;
            const index = Math.floor(percent * (set.length - 1));
            const icon = set[index] || set[set.length - 1];
            return icon;
        }
    );

    return Widget.Label({
        cssClasses: ['battery-icon'],
        label: batteryBind()
    });
}

export function BatteryPercentLabel(props: { reveal: Variable<boolean> }) {
    const { reveal } = props;

    return Widget.Revealer({
        transition_type: Gtk.RevealerTransitionType.SLIDE_RIGHT,
        setup: (revealer: Gtk.Revealer) => {
            reveal.subscribe((show) => {
                revealer.revealChild = show;
            });
        },
        child: Widget.Label({
            cssClasses: ['battery-percentage'],
            label: bind(battery, 'percentage').as(
                (p) => `${Math.round(p * 100)}%`
            )
        })
    })
}

export const BatteryLevel = () => {
    const isHovering = Variable(false);

    const onHoverEnter = () => {
        isHovering.set(true);
    };

    const onHoverLeave = () => {
        isHovering.set(false);
    };

    const onClicked = () => {
        toggleWindow('battery-menu');
    }

    return Widget.Box({
        onHoverEnter,
        onHoverLeave,
        //onClicked,
        cssClasses: ["battery", "module", "space-between-sm-rtl"],
        visible: bind(battery, 'isPresent'),
        halign: Gtk.Align.CENTER,
        child: Widget.Box({
            children: [
                BatteryIcon(),
                BatteryPercentLabel({ reveal: isHovering })
            ]
        })
    })
};
