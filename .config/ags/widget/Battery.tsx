import { App, Widget } from 'astal/gtk3';
import { Variable, GLib, bind } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk3';

import AstalBattery from 'gi://AstalBattery?version=0.1';

const battery = AstalBattery.get_default();

function BatteryIcon() {
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

    return <label className="barIcon" label={batteryBind()} />;
}

export function BatteryPercentLabel(props: { reveal: Variable<boolean> }) {
    const { reveal } = props;

    const setup = (revealer: Widget.Revealer) => {
        reveal.subscribe((show) => {
            revealer.revealChild = show;
        });
    };

    return (
        <revealer
            transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
            setup={setup}
        >
            <label
                className="battery-percentage"
                label={bind(battery, 'percentage').as(
                    (p) => `${Math.round(p * 100)}%`
                )}
            />
        </revealer>
    );
}

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

    const percentage = bind(battery, 'percentage');

    const isHovering = Variable(false);

    const onHover = () => {
        isHovering.set(true);
    };

    const onHoverLost = () => {
        isHovering.set(false);
    };

    /*
    const text = bind(bat, 'percentage').as((p) => {
        const set = bat.charging ? chargingIcons : icons;
        const index = Math.floor(p * (set.length - 1));
        const icon = set[index] || set[set.length - 1];

        return `${icon}${showPercentage ? ` ${Math.round(p * 100)}%` : ''}`;
    });
    */

    return (
        <eventbox
            className="module-event"
            onHover={onHover}
            onHoverLost={onHoverLost}
        >
            <box
                className="battery module space-between-sm-rtl"
                visible={bind(battery, 'isPresent')}
                halign={Gtk.Align.CENTER}
            >
                <BatteryIcon />
                <BatteryPercentLabel reveal={isHovering} />
            </box>
        </eventbox>
    );
};
