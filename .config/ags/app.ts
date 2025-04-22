import { App, Gdk } from 'astal/gtk3';

import Bar from './windows/Bar';
import { BatteryWindow } from './windows/BatteryWindow';
import { MediaWindow } from './windows/MediaWindow';

import style from './styles/style.scss';

App.start({
    instanceName: 'nsh',
    css: style,
    icons: './assets/icons',
    main() {
        Bar(0 as any);
        MediaWindow();
        BatteryWindow();
    },
});
