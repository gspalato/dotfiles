import AstalNotifd from 'gi://AstalNotifd?version=0.1';

import { APP_NAME } from '../config/data';
import Astal from 'gi://Astal?version=3.0';

export const NotificationWindow = () => {
    return (
        <window
            name='notifications-window'
            namespace={APP_NAME + '-notifications'}
            className='notifications-window'
            layer={Astal.Layer.OVERLAY}
            anchor={Astal.WindowAnchor.RIGHT | Astal.WindowAnchor.TOP | Astal.WindowAnchor.BOTTOM}
            exclusivity={Astal.Exclusivity.NORMAL}
        >
            <box vertical hexpand className='notifications-container'>

            </box>
        </window>
    );
}