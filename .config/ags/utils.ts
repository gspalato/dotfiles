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

export function toHumanReadableTime(min: number) {
    const hours = Math.floor(min / 60);
    const remainingMin = min % 60;

    let res = '';

    const formattedHours = String(hours);
    const formattedMin = String(remainingMin.toFixed(0));

    if (hours > 0) {
        res += `${formattedHours}h`;
    }

    if (remainingMin > 0) {
        res += ` ${formattedMin}m`
    }

    return res.trim();
}