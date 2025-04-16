import { App, Astal, Gtk, Gdk } from 'astal/gtk3';
import { Variable } from 'astal';

import { HyprlandWorkspaces } from '../widget/HyprlandWorkspaces';
import { HyprlandWindow } from '../widget/HyprlandWindow';
import { Time } from '../widget/Time';
import { BatteryLevel } from '../widget/Battery';
import { Wifi } from '../widget/Wifi';
import { Volume } from '../widget/Volume';
import { Media } from '../widget/Media';

import { APP_NAME } from '../config/data';

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
