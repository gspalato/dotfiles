import { App } from 'astal/gtk3';
import { Variable, GLib, bind } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk3';

import Battery from 'gi://AstalBattery?version=0.1';

type Props = {
    icons?: string[];
    chargingIcons?: string[];
    showPercentage?: boolean;
};

export const BatteryLevel = (props: Props) => {
    const {
        showPercentage = true,
        icons = ['󰂎', '󰁺', '󰁻', '󰁼', '󰁽', '󰁾', '󰁿', '󰂀', '󰂁', '󰂂', '󰁹'],
        chargingIcons = ['󰢟', '󰢜', '󰂆', '󰂇', '󰂈', '󰢝', '󰂉', '󰢞', '󰂊', '󰂋', '󰂅'],
    } = props;

    const bat = Battery.get_default();

    const text = bind(bat, 'percentage').as((p) => {
        const set = bat.charging ? chargingIcons : icons;

        const index = Math.floor((p / 100) * (set.length - 1));
        const icon = set[index] || set[set.length - 1];

        return `${icon}${showPercentage ? ` ${Math.round(p * 100)}%` : ''}`;
    });

    return (
        <box className="battery module" visible={bind(bat, 'isPresent')}>
            <label label={text} />
        </box>
    );
};
