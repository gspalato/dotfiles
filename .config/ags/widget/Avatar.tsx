import { exec } from 'astal';
import { Widget } from 'astal/gtk3';

export const Avatar = () => {
    const home = exec("bash -c 'echo $HOME'");
    const path = `${home}/.face.icon`;

    return new Widget.Icon({
        className: 'avatar module',
        css: `
                background-image: url('${path}');
            `,
        icon: path
    });
};
