import { App, Gdk } from 'astal/gtk3';

import Bar from './widget/Bar';
import { MediaWindow } from './widget/MediaWindow';

import style from './styles/style.scss';

App.start({
    instanceName: 'nsh',
    css: style,
    main() {
        Bar(0 as any);
        MediaWindow();
    },
});
