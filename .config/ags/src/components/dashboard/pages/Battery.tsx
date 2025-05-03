import { bind, Variable } from 'astal';
import { App, Astal, Gdk, Gtk, Widget } from 'astal/gtk4';
import Mpris from 'gi://AstalMpris';
import { toggleWindow } from '../../../utils/window';

import { APP_NAME } from '../../../config/data';
import Pango from 'gi://Pango?version=1.0';
import AstalBattery from 'gi://AstalBattery?version=0.1';
import { BatteryIcon } from '../../bar/modules/Battery';
import { toHumanReadableTime } from '../../../../utils';

const battery = AstalBattery.get_default();

const BatteryContainer = () => {
    const infoEntries = [
        {
            name: 'Status',
            value: bind(battery, 'charging').as((c) =>
                c ? 'Charging' : 'Discharging'
            ),
        },
        {
            name: 'Health',
            value: bind(battery, 'energyFull').as((e) => `${e.toFixed(2)}Wh`),
        },
        //{ name: 'Voltage', value: bind(battery, 'voltage').as(v => `${v.toFixed(2)}V`) }
    ];

    const timeLeft = Variable.derive(
        [
            bind(battery, 'percentage'),
            bind(battery, 'energyFull'),
            bind(battery, 'energyRate'),
        ],
        (percentage, full, currentNow) =>
            ((percentage * full) / currentNow) * 60
    );

    const Header = Widget.Box({
        cssClasses: ['battery-header space-between-lg-ltr'],
        hexpand: true,
        children: [
            BatteryIcon(),
            Widget.Box({
                cssClasses: ['battery-header-content'],
                valign: Gtk.Align.CENTER,
                vertical: true,
                children: [
                    Widget.Label({
                        cssClasses: ['battery-percentage'],
                        label: bind(battery, 'percentage').as(
                            (p) => `${Math.round(p * 100)}%`
                        ),
                        halign: Gtk.Align.START,
                    }),
                    Widget.Label({
                        cssClasses: ['battery-time-left'],
                        label: bind(timeLeft).as(
                            (t) => `Time left: ${toHumanReadableTime(t)}`
                        ),
                        halign: Gtk.Align.START,
                    }),
                ],
            }),
        ],
    });

    const Info = Widget.Box({
        cssClasses: ['battery-info'],
        hexpand: true,
        vertical: true,
        children: infoEntries.map((e) =>
            Widget.CenterBox({
                cssClasses: ['info-entry'],
                startWidget: Widget.Label({
                    cssClasses: ['info-title'],
                    label: `${e.name}:`,
                    halign: Gtk.Align.START,
                }),
                endWidget: Widget.Label({
                    cssClasses: ['info-value'],
                    label: e.value,
                    halign: Gtk.Align.END,
                }),
            })
        ),
    });

    return Widget.Box({
        vertical: true,
        vexpand: true,
        cssClasses: ['battery-menu-container'],
        children: [Header, Info],
    });
};

export const BatteryWindow = () => {
    /*
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
    */

    return Widget.Window({
        name: 'battery-menu',
        anchor: Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT,
        visible: false,
        application: App,
        namespace: APP_NAME,
        child: BatteryContainer(),
    });
};

export default BatteryContainer;
