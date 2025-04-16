import { Astal, Gdk } from 'astal/gtk3';
import { APP_NAME } from '../config/data';

export default function Dock(gdkmonitor: Gdk.Monitor) {
    const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

    return (
        <window
            visible
            className="bar"
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={BOTTOM}
            namespace={APP_NAME}
        ></window>
    );
}
