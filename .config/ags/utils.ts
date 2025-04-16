import { exec, GLib } from 'astal';

export function truncateString(str: string, num: number) {
    if (str.length > num) {
        return str.slice(0, num) + '...';
    } else {
        return str;
    }
}

export function getIconFromClass(wmclass: string) {
    const iconName = exec(
        `bash -c 'echo $($HOME/.config/ags/scripts/find_icon.sh ${wmclass})'`
    );
    return iconName;
}
