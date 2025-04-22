import { App, Widget } from 'astal/gtk3';
import { Variable, GLib, bind, Binding } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk3';

import AstalBattery from 'gi://AstalBattery?version=0.1';
import { toggleWindow } from '../utils/window';

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

    return new Widget.Label({
        className: 'battery-icon',
        label: batteryBind()
    });
}

export function BatteryPercentLabel(props: { reveal: Variable<boolean> }) {
    const { reveal } = props;

    return new Widget.Revealer({
        transition_type: Gtk.RevealerTransitionType.SLIDE_RIGHT,
        setup: (revealer: Widget.Revealer) => {
            reveal.subscribe((show) => {
                revealer.revealChild = show;
            });
        },
        child: new Widget.Label({
            className: 'battery-percentage',
            label: bind(battery, 'percentage').as(
                (p) => `${Math.round(p * 100)}%`
            )
        })
    })
}

type Props = {
    icons?: string[];
    chargingIcons?: string[];
    showPercentage?: boolean;
    css?: Binding<string> | string;
};

export const BatteryLevel = (props: Props) => {
    const { css } = props;

    const isHovering = Variable(false);

    const onHover = () => {
        isHovering.set(true);
    };

    const onHoverLost = () => {
        isHovering.set(false);
    };

    const onClick = () => {
        toggleWindow('battery-menu');
    }

    return new Widget.EventBox({
        className: 'module-event',
        onHover,
        onHoverLost,
        onClick,
        child: new Widget.Box({
            className: "battery module space-between-sm-rtl",
            visible: bind(battery, 'isPresent'),
            halign: Gtk.Align.CENTER,
            css,
            children: [
                BatteryIcon(),
                BatteryPercentLabel({ reveal: isHovering })
            ]
        })
    });
};
