import { App, Astal, Gtk, Gdk } from 'astal/gtk3';
import { Variable } from 'astal';

import { HyprlandWorkspaces } from './HyprlandWorkspaces';
import { HyprlandWindow } from './HyprlandWindow';
import { Time } from './Time';
import { BatteryLevel } from './Battery';
import { Wifi } from './Wifi';
import { Volume } from './Volume';
import { Media } from './Media';

import { APP_NAME } from '../config/data';
import { Avatar } from './Avatar';

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

    return (
        <window
            visible
            className="bar"
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={TOP | LEFT | RIGHT}
            namespace={APP_NAME}
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
                    <></>
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
