export declare const UnityMessagePrefix = "@UnityMessage@";
export default class MessageHandler {
    static deserialize(message: string): MessageHandler;
    static isUnityMessage(message: string): boolean;
    id: number;
    seq: 'start' | 'end' | '';
    name: string;
    data: any;
    constructor();
    send(data: any): void;
}
