import { App, Astal, Gtk, Gdk } from 'astal/gtk3';
import { Variable } from 'astal';

import { HyprlandWorkspaces } from './HyprlandWorkspaces';
import { HyprlandWindow } from './HyprlandWindow';
import { Time } from './Time';
import { BatteryLevel } from './Battery';
import { Wifi } from './Wifi';
import { Volume } from './Volume';
import { Media } from './Media';

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

    return (
        <window
            visible
            className="bar"
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={TOP | LEFT | RIGHT}
        >
            <centerbox>
                <box
                    className="area"
                    hexpand
                    halign={Gtk.Align.START}
                    valign={Gtk.Align.CENTER}
                >
                    <HyprlandWorkspaces currentIcon="●" icons={{ '*': '●' }} />
                    <Media />
                </box>
                <box className="area">
                    <HyprlandWindow maxLength={30} />
                </box>
                <box
                    className="area"
                    hexpand
                    halign={Gtk.Align.END}
                    valign={Gtk.Align.CENTER}
                >
                    <Volume />
                    <Wifi />
                    <BatteryLevel />
                    <Time />
                </box>
            </centerbox>
        </window>
    );
}
