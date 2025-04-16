//import Widget from "resource:///com/github/Aylur/ags/widget.js";
//import Variable from "resource:///com/github/Aylur/ags/variable.js";
//import {exec} from "resource:///com/github/Aylur/ags/utils.js";

import Cairo from 'cairo';
import { exec } from 'astal/process';

import { Astal, Gtk, Widget } from 'astal/gtk3';
import { bind, GLib, Variable } from 'astal';
import AstalCava from 'gi://AstalCava?version=0.1';

type Props = {
    autosens?: boolean;
    framerate?: number;
    sampleRate?: number;
    source?: string;
    bars?: number;
    barHeight?: number;
    barWidth?: number;
    padding?: number;
    input?: AstalCava.Input;
    vertical?: boolean;
    align?: 'start' | 'center' | 'end';
    smooth?: boolean;
};

const isCavaAvailable = exec('which cava') != '';

export const Cava = (props: Props) => {
    return (
        <box
            halign={Gtk.Align.CENTER}
            valign={Gtk.Align.CENTER}
            className="cava module"
            visible
        >
            <></>
            <CavaSpectrum {...props} />
        </box>
    );
};

export const CavaSpectrum = (props: Props) => {
    const {
        autosens = true,
        framerate = 60,
        sampleRate = 48000,
        source = 'auto',
        input = AstalCava.Input.PIPEWIRE,
        barHeight = 20,
        barWidth = 3,
        padding = 5,
        bars = 15,
        align = 'center',
        smooth = false,
    } = props;

    const cava = AstalCava.get_default();

    cava?.set_bars(bars);
    cava?.set_framerate(framerate);
    cava?.set_source(source);
    cava?.set_autosens(autosens);
    cava?.set_input(input);
    cava?.set_samplerate(sampleRate);
    cava?.set_stereo(false);

    if (!cava) {
        print('no cava?');
        return <></>;
    }

    let silenceCounter = 0;
    const silenceThreshold = 10;

    return (
        <drawingarea
            hexpand
            vexpand
            setup={(self) => {
                self.set_size_request(
                    bars * barWidth + (bars - 1) * padding,
                    barHeight
                );

                cava.connect('notify::values', () => self.queue_draw());

                self.connect('draw', (_, cr: Cairo.Context) => {
                    const values = cava.get_values();

                    const context = self.get_style_context();
                    const h = self.get_allocated_height();
                    const w = self.get_allocated_width();

                    // Primary color fetched from CSS.
                    const fg = context.get_property(
                        'color',
                        Gtk.StateFlags.NORMAL
                    ) as any;

                    cr.setSourceRGBA(fg.red, fg.green, fg.blue, fg.alpha);

                    // Silence control.
                    if (values[0] > 0) silenceCounter = 0;
                    else silenceCounter++;

                    const spectrum =
                        silenceCounter > silenceThreshold
                            ? new Array(bars).fill(0)
                            : values;

                    const centerY = h / 2;
                    const width = barWidth ?? w / bars - padding;

                    let dx = 0;

                    for (let i = 0; i < spectrum.length; i++) {
                        const value = Math.min(spectrum[i], 1);

                        let height = Math.max(value * barHeight, 1) / 2;
                        height = Math.min(height, barHeight);

                        const radius = width / 2;
                        const yTop = centerY - height;
                        const yBottom = centerY + height;

                        // Bar
                        cr.rectangle(dx, yTop, width, height * 2);

                        // Roundness
                        cr.arc(dx + radius, yTop, radius, 0, 2 * Math.PI);
                        cr.arc(dx + radius, yBottom, radius, 0, 2 * Math.PI);

                        cr.closePath();
                        dx += width + padding;
                    }

                    cr.fill();
                });
            }}
        />
    );
};

let CavaWidget;
if (exec('which cava') != '') CavaWidget = Cava;
else {
    console.warn('cava is not installed. Cava module has been disabled.');
    CavaWidget = () => new Gtk.Box();
}

export default CavaWidget;
