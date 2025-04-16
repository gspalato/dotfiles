import { App } from 'astal/gtk3';
import { Variable, GLib, bind } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk3';
import Network from 'gi://AstalNetwork';

type Props = {
    wifiIcons?: string[];
};

export const Wifi = (props: Props) => {
    const { icons = ['󰤟', '󰤢', '󰤥', '󰤨'] } = props;

    const network = Network.get_default();
    const wifi = bind(network, 'wifi');

    const enumMap = new Map<number, string>([
        [Network.Primary.UNKNOWN, 'disconnected'],
        [Network.Primary.WIFI, 'wifi'],
        [Network.Primary.WIRED, 'wired'],
    ]);

    /*
    const strength = bind(wifi, 'strength').as(Number);
    const totalIcons = props.icons?.length || 5;
    const icon = strength.as((s) => {
        const index = Math.floor((s / 100) * (totalIcons - 1));
        return icons[index] || icons[icons.length - 1];
    });
    */

    return (
        <box visible={wifi.as(Boolean)} className="wifi module">
            <stack
                className="barIcon"
                shown={bind(network, 'primary').as(
                    (p) => enumMap.get(p) ?? 'disconnected'
                )}
            >
                <label name="wifi" label="󰤨" />
                <icon name="wired" icon="custom-network-wired-symbolic" />
                <label name="disconnected" label="󰤭" />
            </stack>
            {/*wifi.as((wifi) => wifi && <label label={icon} />)*/}
        </box>
    );
};
