import { Widget } from "astal/gtk3";

import { Volume } from "./Volume";
import { BatteryLevel } from "./Battery";
import { Network } from "./Network";

export const Info = () => {
    return new Widget.Box({
        className: 'module space-between-rtl',
        children: [
            Volume({}),
            Network({ css: 'padding-left: 15px;' }),
            BatteryLevel({ css: 'padding-left: 15px;' }),
        ]
    });
}