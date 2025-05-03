import { exec } from 'astal';
import { Gtk, Widget } from 'astal/gtk4';
import { Picture } from './Picture';
import Gio from 'gi://Gio?version=2.0';
import { createScaledTexture } from '../../utils/images';

type Props = {
    cssClasses?: string[];
    size?: number;
};

export const Avatar = (props: Props) => {
    const { cssClasses = [], size = 45 } = props;

    const home = exec("bash -c 'echo $HOME'");
    const path = `${home}/.face.icon`;

    const texture = createScaledTexture(size, size, path);

    return Picture({
        cssClasses: ['avatar', 'module'].concat(cssClasses),
        canShrink: true,
        heightRequest: 45,
        widthRequest: 45,
        paintable: texture,
        contentFit: Gtk.ContentFit.COVER,
    });
};
