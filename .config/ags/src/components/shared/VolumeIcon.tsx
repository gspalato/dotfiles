import { Gtk, Widget } from "astal/gtk4";

import Wp from "gi://AstalWp";

const audio = Wp.get_default()?.get_audio();

export const VolumeIcon = () => {
    const volumeThresholds = [67, 34, 1, 0];

    const volumeMap = {
        0: "custom-audio-volume-muted-symbolic",
        1: "custom-audio-volume-low-symbolic",
        34: "custom-audio-volume-medium-symbolic",
        67: "custom-audio-volume-high-symbolic"
    }

    return Widget.Box({
        child: Widget.Stack({
            setup: (self) => {
                if (!audio) return;
                audio.get_default_speaker()?.connect('notify', (speaker) => {
                    if (speaker.get_mute()) {
                        self.visibleChildName = '0';
                        return;
                    }

                    self.visibleChildName = volumeThresholds
                        .find((threshold) => threshold <= speaker.volume * 100)!
                        .toString();
                });
            },
            // @ts-ignore
            children: Object.entries(volumeMap)
                .map((v) => Widget.Image({ name: v[0], iconName: v[1] }))
        })
    })
};