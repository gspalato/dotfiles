import { App, Gdk } from "astal/gtk3"

import Bar from "./widget/Bar"

import style from "./style.scss"

App.start({
    instanceName: 'sbar',
    css: style,
    main() {
        Bar(0 as any)
    },
})
