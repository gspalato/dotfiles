import { App } from 'astal/gtk3';
import { Variable, GLib, bind } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk3';
import Network from 'gi://AstalNetwork';

type Props = {
    icons?: string[];
};

export const Wifi = (props: Props) => {
    const { icons = ['󰤟', '󰤢', '󰤥', '󰤨'] } = props;

    const network = Network.get_default();
    const wifi = bind(network, 'wifi');

    const strength = bind(wifi, 'strength').as(Number);
    const totalIcons = props.icons?.length || 5;
    const icon = strength.as((s) => {
        const index = Math.floor((s / 100) * (totalIcons - 1));
        return icons[index] || icons[icons.length - 1];
    });

    return (
        <box visible={wifi.as(Boolean)} className="wifi module">
            {wifi.as((wifi) => wifi && <label label={icon} />)}
        </box>
    );
};
