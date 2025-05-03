import { bind } from 'astal';
import Mpris from 'gi://AstalMpris';
import { Widget, Gtk, App, Gdk } from 'astal/gtk4';

const media = Mpris.get_default();

type Props = {
    player: Mpris.Player;
    symbolic?: boolean;
    playerIcons?: { [player: string]: string };
    showOnIconlessPlayer?: boolean;
    [key: string]: any;
};

export const PlayerIcon = (props: Props) => {
    const {
        player,
        playerIcons,
        showOnIconlessPlayer = false,
        symbolic = false,
        ...rest
    } = props;

    const defaultIconName = 'emblem-music-symbolic';

    const iconName = bind(player, 'entry').as((entry) => {
        let name = `${entry}${symbolic ? '-symbolic' : ''}`;
        name = Gtk.IconTheme.get_for_display(Gdk.Display.get_default()!).has_icon(name) ? name : defaultIconName;
        return name;
    });

    return Widget.Image({
        cssClasses: ['player-icon'],
        iconName: iconName,
        ...rest
    });
};
