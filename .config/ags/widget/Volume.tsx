import { App, Widget } from 'astal/gtk3';
import { Variable, GLib, bind, exec, Binding } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk3';

import Wp from 'gi://AstalWp';

const audio = Wp.get_default()?.get_audio();

const VolumeIcon = () => {
    const volumeThresholds = [67, 34, 1, 0];
    const volumeIcons = []

    const volumeMap = {
        0: "custom-audio-volume-muted-symbolic",
        1: "custom-audio-volume-low-symbolic",
        34: "custom-audio-volume-medium-symbolic",
        67: "custom-audio-volume-high-symbolic"
    }

    const setupStack = (stack: Widget.Stack) => {
        if (!audio) return;
        audio.get_default_speaker()?.connect('notify', (speaker) => {
            if (speaker.get_mute()) {
                stack.shown = '0';
                return;
            }

            stack.shown = Object.keys(volumeMap)
                .map(v => Number(v))
                .find((threshold) => threshold <= speaker.volume * 100)!
                .toString();
        });
    };

    return new Widget.Box({
        className: '',
        children: [
            new Widget.Stack({
                setup: (stack: Widget.Stack) => {
                    if (!audio) return;
                    audio.get_default_speaker()?.connect('notify', (speaker) => {
                        if (speaker.get_mute()) {
                            stack.shown = '0';
                            return;
                        }

                        stack.shown = volumeThresholds
                            .find((threshold) => threshold <= speaker.volume * 100)!
                            .toString();
                    });
                },
                children: Object.entries(volumeMap).map((v) => new Widget.Icon({ name: v[0], icon: v[1] }))
            })
        ]
    })
};

export function VolumePercentLabel(props: { reveal: Variable<boolean> }) {
    const { reveal } = props;

    return new Widget.Revealer({
        transition_type: Gtk.RevealerTransitionType.SLIDE_RIGHT,
        setup: (revealer: Widget.Revealer) => {
            reveal.subscribe((show) => {
                revealer.revealChild = show;
            });
        },
        child: new Widget.Label({
            className: 'volume-percentage',
            label: bind(audio?.defaultSpeaker!, 'volume').as(
                (p) => `${Math.round(p * 100)}%`
            )
        })
    })
}

type Props = {
    icons?: string[];
    muteIcon?: string;
    showIcon?: boolean;
    showPercentage?: boolean;
    css?: Binding<string> | string;
};

export const Volume = (props: Props) => {
    const {
        css
    } = props;

    const wp = Wp.get_default();
    if (!wp) {
        return <></>;
    }

    const isHovering = Variable(false);

    const onHover = () => {
        isHovering.set(true);
    };

    const onHoverLost = () => {
        isHovering.set(false);
    };

    const speaker = Wp.get_default()?.audio.defaultSpeaker!;

    const onScroll = (_: any, e: Astal.ScrollEvent) => {
        if (e.direction === Gdk.ScrollDirection.UP || e.delta_y < 0) {
            speaker.set_volume(
                Math.max(0, Math.min(1, speaker.get_volume() + 0.05))
            );
        } else if (e.direction === Gdk.ScrollDirection.DOWN || e.delta_y > 0) {
            speaker.set_volume(
                Math.max(0, Math.min(1, speaker.get_volume() - 0.05))
            );
        }
    };

    return new Widget.EventBox({
        className: "module-event",
        onHover,
        onHoverLost,
        onScroll,
        css,
        child: new Widget.Box({
            visible: !!speaker,
            className: 'module volume space-between-sm-rtl',
            children: [
                VolumeIcon(),
                VolumePercentLabel({ reveal: isHovering })
            ]
        })
    })
};
