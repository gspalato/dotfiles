import { App, Astal, Gtk, Gdk, Widget } from 'astal/gtk3';
import { Variable } from 'astal';

import { Workspaces } from '../widget/HyprlandWorkspaces';
import { HyprlandWindow } from '../widget/HyprlandWindow';
import { Time } from '../widget/Time';
import { BatteryLevel } from '../widget/Battery';
import { Network } from '../widget/Network';
import { Volume } from '../widget/Volume';
import { Info } from '../widget/Info';
import { Media } from '../widget/Media';

import { APP_NAME } from '../config/data';

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

    const leftWidgets = new Widget.Box({
        className: 'area',
        hexpand: true,
        halign: Gtk.Align.START,
        valign: Gtk.Align.CENTER,
        children: [
            Workspaces(0),
            //HyprlandWorkspaces({ currentIcon: "●", icons: { '*': '●' } }),
            Media()
        ]
    });

    const centerWidgets = new Widget.Box({
        className: 'area',
        hexpand: true,
        halign: Gtk.Align.CENTER,
        valign: Gtk.Align.CENTER,
        children: [
            HyprlandWindow({ maxLength: 30 })
        ]
    })

    const rightWidgets = new Widget.Box({
        className: 'area',
        hexpand: true,
        halign: Gtk.Align.END,
        valign: Gtk.Align.CENTER,
        children: [
            Info(),
            //Volume({}),
            //Network(),
            //BatteryLevel({}),
            Time({}),
        ]
    })

    return new Widget.Window({
        visible: true,
        className: 'bar',
        exclusivity: Astal.Exclusivity.EXCLUSIVE,
        anchor: TOP | LEFT | RIGHT,
        namespace: APP_NAME,
        child: new Widget.CenterBox({
            startWidget: leftWidgets,
            centerWidget: centerWidgets,
            endWidget: rightWidgets,
        })
    });
}
