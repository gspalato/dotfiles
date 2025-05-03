import { App, Astal, Gdk, Gtk } from 'astal/gtk4';
import { Gio, GLib, GObject } from 'astal';

import Adw from 'gi://Adw';

import Bar from '@components/bar/Bar';
import { BatteryWindow } from '@components/dashboard/pages/Battery';
import { DashboardWindow } from '@components/dashboard/Dashboard';
import { MediaWindow } from '@components/media/MediaWindow';

import style from './src/styles/style.scss';
import { APP_NAME } from '@config/data';

GLib.set_prgname(APP_NAME);

Adw.init();

App.start({
    instanceName: APP_NAME,
    css: style,
    icons: './assets/icons',
    main() {
        const display = Gdk.Display.get_default()!;

        Bar(display);
        MediaWindow();
        BatteryWindow();
        DashboardWindow();
    },
});
