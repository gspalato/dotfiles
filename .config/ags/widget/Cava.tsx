import { App } from 'astal/gtk3';
import { Variable, GLib, bind } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk3';

import AstalCava from 'gi://AstalCava';
import AstalWp from 'gi://AstalWp?version=0.1';

type Props = {
    autosens?: boolean;
    framerate?: number;
    source?: string;
    bars?: number;
    input?: AstalCava.Input;
    icons?: string[];
    separator?: string;
};

export const Cava = (props: Props) => {
    const {
        autosens = true,
        framerate = 60,
        source = 'default',
        bars = 10,
        input = AstalCava.Input.PIPEWIRE,
        icons = ['▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'],
        separator = '',
    } = props;

    const cava = AstalCava.get_default();

    cava?.set_bars(bars);
    cava?.set_framerate(framerate);
    cava?.set_source(source);
    cava?.set_autosens(autosens);
    cava?.set_input(input);

    if (!cava) {
        return <></>;
    }

    const text = bind(cava, 'values').as((vs) => {
        const values = vs
            .map((v) => {
                // Each value is between 0 and 1.
                // We need to map it to the icons array.
                const index = Math.floor(v * (icons.length - 1));
                const icon = icons[index] || icons[icons.length - 1];
                return icon;
            })
            .join(separator);

        return values;
    });

    return (
        <box className="cava module" visible={!!cava}>
            <label label={text} />
        </box>
    );
};
