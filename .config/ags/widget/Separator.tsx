import { Widget } from "astal/gtk3"

type Props = {
    spacing?: number;
}

export const Separator = (props: Props) => {
    const {
        spacing = 5
    } = props;

    return new Widget.Box({ vexpand: true, css: `min-width: 1px; padding: 0 ${spacing}px; background: rgba(242, 242, 242, 0.12)` })
}