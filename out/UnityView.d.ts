import * as React from "react";
import { ViewProperties } from 'react-native';
import MessageHandler from "./MessageHandler";
import { UnityViewMessage } from "./UnityModule";
export interface UnityViewProps extends ViewProperties {
    /**
     * Receive string message from unity.
     */
    onMessage?: (message: string) => void;
    /**
     * Receive unity message from unity.
     */
    onUnityMessage?: (handler: MessageHandler) => void;
}
export default class UnityView extends React.Component<UnityViewProps> {
    static propTypes: any;
    private handle;
    constructor(props: any);
    componentWillMount(): void;
    componentWillUnmount(): void;
    /**
     * [Deprecated] Use `UnityModule.pause` instead.
     */
    pause(): void;
    /**
     * [Deprecated] Use `UnityModule.resume` instead.
     */
    resume(): void;
    /**
     * [Deprecated] Use `UnityModule.postMessage` instead.
     */
    postMessage(gameObject: string, methodName: string, message: string): void;
    /**
     * [Deprecated] Use `UnityModule.postMessageToUnityManager` instead.
     */
    postMessageToUnityManager(message: string | UnityViewMessage): void;
    render(): JSX.Element;
}
