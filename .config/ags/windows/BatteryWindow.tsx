import { bind } from 'astal';
import { App, Astal, Gdk, Gtk, Widget } from 'astal/gtk3';
import Mpris from 'gi://AstalMpris';
import { toggleWindow } from '../utils/window';

import { APP_NAME } from '../config/data';
import Pango from 'gi://Pango?version=1.0';
import AstalBattery from 'gi://AstalBattery?version=0.1';
import { BatteryIcon } from '../widget/Battery';

const battery = AstalBattery.get_default();

const BatteryContainer = () => {
    return (
        <box className="battery-menu-container" vertical={true} vexpand>
            <box className="battery-header space-between-sm-ltr" hexpand vertical={false}>
                <BatteryIcon />
                <label label={bind(battery, 'percentage').as(p => `${Math.round(p * 100)}%`)} className="battery-percentage" />
            </box>
            <box className="battery-info" hexpand vertical>
                <centerbox className="info-entry" hexpand>
                    <label className="info-title" label="Status:" halign={Gtk.Align.START} />
                    <label />
                    <label className="info-value" label={bind(battery, 'charging').as(c => c ? 'Charging' : 'Discharging')} halign={Gtk.Align.END} />
                </centerbox>
                <centerbox className="info-entry" hexpand>
                    <label className="info-title" label="Health:" halign={Gtk.Align.START} />
                    <label />
                    <label className="info-value" label={bind(battery, 'energyFull').as(e => `${e}Wh`)} halign={Gtk.Align.END} />
                </centerbox>
                <centerbox className="info-entry" hexpand>
                    <label className="info-title" label="Voltage:" halign={Gtk.Align.START} />
                    <label />
                    <label className="info-value" label={bind(battery, 'voltage').as(v => `${v}V`)} halign={Gtk.Align.END} />
                </centerbox>
            </box>
        </box>
    )
}

export const BatteryWindow = () => {
    const handleHoverLost = (
        widget: Widget.EventBox,
        event: Astal.HoverEvent
    ) => {
        const x = Math.round(event.x);
        const y = Math.round(event.y);
        const w = widget.get_allocation().width - 15;
        const h = widget.get_allocation().height - 15;
        if (x <= 15 || x >= w || y <= 0 || y >= h) {
            toggleWindow('battery-menu');
        }
    };

    return (
        <window
            name="battery-menu"
            anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
            visible={false}
            application={App}
            namespace={APP_NAME}
        >
            <revealer
                revealChild={false}
                transitionType={Gtk.RevealerTransitionType.CROSSFADE}
            >
                <eventbox onHoverLost={handleHoverLost}>
                    {BatteryContainer()}
                </eventbox>
            </revealer>
        </window>
    );
};
