import { App, Widget } from 'astal/gtk4';
import { Variable, GLib, bind, exec, Binding } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk4';

import Wp from 'gi://AstalWp';

import { VolumeIcon } from '../../shared/VolumeIcon';

const audio = Wp.get_default()?.get_audio();

export function VolumePercentLabel(props: { reveal: Variable<boolean> }) {
    const { reveal } = props;

    return Widget.Revealer({
        transition_type: Gtk.RevealerTransitionType.SLIDE_RIGHT,
        setup: (revealer: Gtk.Revealer) => {
            reveal.subscribe((show) => {
                revealer.revealChild = show;
            });
        },
        child: Widget.Label({
            cssClasses: ['volume-percentage'],
            label: bind(audio?.defaultSpeaker!, 'volume').as(
                (p) => `${Math.round(p * 100)}%`
            )
        })
    })
}

export const Volume = () => {
    const wp = Wp.get_default();
    if (!wp) {
        return Widget.Box();
    }

    const isHovering = Variable(false);

    const onHoverEnter = () => {
        isHovering.set(true);
    };

    const onHoverLeave = () => {
        isHovering.set(false);
    };

    const speaker = Wp.get_default()?.audio.defaultSpeaker!;

    const onScroll = (self: Astal.Box, dx: number, dy: number) => {
        if (dy < 0) {
            speaker.set_volume(
                Math.max(0, Math.min(1, speaker.get_volume() + 0.05))
            );
        } else if (dy > 0) {
            speaker.set_volume(
                Math.max(0, Math.min(1, speaker.get_volume() - 0.05))
            );
        }
    };

    return Widget.Box({
        onHoverEnter,
        onHoverLeave,
        onScroll,
        visible: !!speaker,
        cssClasses: ['module', 'volume', 'space-between-sm-rtl'],
        children: [
            VolumeIcon(),
            VolumePercentLabel({ reveal: isHovering })
        ]
    })
};
