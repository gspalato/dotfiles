import { exec } from 'astal';

export const Avatar = () => {
    const home = exec("bash -c 'echo $HOME'");
    const path = `${home}/.face.icon`;

    return (
        <box
            className="avatar module"
            css={`
                background-image: url('${path}');
            `}
        />
    );
};
