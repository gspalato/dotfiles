import { App, Astal, Gdk, Gtk, Widget } from 'astal/gtk4';
import { bind, exec, Variable } from 'astal';

import DashboardMain from './pages/Main';
import BatteryPage from './pages/Battery';

import { APP_NAME } from '../../config/data';

import Wp from 'gi://AstalWp';

const audio = Wp.get_default()?.get_audio();

const DashboardContainer = () => {
    return Widget.Box({
        onHoverLeave(self) {
            //toggleWindow('dashboard-menu');
        },
        cssClasses: ['dashboard-container'],
        vertical: true,
        vexpand: true,
        child: Widget.Stack({
            cssClasses: ['dashboard-stack'],
            visibleChildName: 'dashboard-main',
            // @ts-ignore
            children: [DashboardMain(), BatteryPage()],
        }),
    });
};

export const DashboardWindow = () => {
    return Widget.Window({
        name: 'dashboard-menu',
        anchor:
            Astal.WindowAnchor.TOP |
            Astal.WindowAnchor.RIGHT |
            Astal.WindowAnchor.BOTTOM,
        visible: false,
        application: App,
        namespace: APP_NAME,
        child: Widget.Revealer({
            revealChild: false,
            transitionType: Gtk.RevealerTransitionType.SLIDE_LEFT,
            child: DashboardContainer(),
        }),
        setup(self) {
            self.set_default_size(-1, -1);
        },
    });
};
