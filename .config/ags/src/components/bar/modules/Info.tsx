import { Widget } from "astal/gtk4";

import { Volume } from "./Volume";
import { BatteryLevel } from "./Battery";
import { Network } from "./Network";

export const Info = () => {
    return Widget.Box({
        cssClasses: ['module', 'space-between-rtl'],
        spacing: 15,
        children: [
            Volume(),
            Network(),
            BatteryLevel(),
        ]
    });
}