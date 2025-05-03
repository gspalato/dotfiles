import { App, Astal, Gtk, Gdk, Widget } from 'astal/gtk4';
import { Variable } from 'astal';

import { Workspaces } from './modules/HyprlandWorkspaces';
import { HyprlandWindow } from './modules/HyprlandWindow';
import { Time } from './modules/Time';
import { BatteryLevel } from './modules/Battery';
import { Network } from './modules/Network';
import { Volume } from './modules/Volume';
import { Info } from './modules/Info';
import { Media } from './modules/Media';

import { APP_NAME } from '@config/data';

export default function Bar(display: Gdk.Display) {
    const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

    const leftWidgets = Widget.Box({
        spacing: 5,
        cssClasses: ['area'],
        halign: Gtk.Align.START,
        valign: Gtk.Align.CENTER,
        children: [
            Workspaces(0),
            Media()
        ]
    });

    const centerWidgets = Widget.Box({
        spacing: 5,
        cssClasses: ['area'],
        halign: Gtk.Align.CENTER,
        valign: Gtk.Align.CENTER,
        children: [
            HyprlandWindow({ maxLength: 30 })
        ]
    })

    const rightWidgets = Widget.Box({
        spacing: 5,
        cssClasses: ['area'],
        halign: Gtk.Align.END,
        valign: Gtk.Align.CENTER,
        children: [
            Info(),
            //Volume(),
            //Network(),
            //BatteryLevel(),
            Time({}),
        ]
    })

    return Widget.Window({
        visible: true,
        cssClasses: ['bar'],
        exclusivity: Astal.Exclusivity.EXCLUSIVE,
        anchor: TOP | LEFT | RIGHT,
        namespace: APP_NAME,
        display,
        monitor: 0,
        child: Widget.CenterBox({
            cssClasses: ['centerbox'],
            startWidget: leftWidgets,
            centerWidget: centerWidgets,
            endWidget: rightWidgets,
        })
    });
}
