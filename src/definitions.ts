import type { PluginListenerHandle } from '@capacitor/core';

export interface NativeShareItem {
	/**
	 * The text shared. It can also be a website.
	 */
	text: string;

	/**
	 * The uri (path) to the shared file.
	 */
	uri: string;

	/**
	 * The mimeType of the shared file.
	 */
	mimeType: string;
}

export enum NativeShareEventType {
	SHARE_RECEIVED = 'sharedReceived',
}

export interface NativeShareShareReceived {
	items: { [idx: string]: NativeShareItem };
	length: number;
}

export type NativeShareItemHandlerShareReceivedHandler = (
	event: NativeShareShareReceived
) => void;

export type NativeShareItemHandlerShareReceivedListener = (
	eventName: NativeShareEventType.SHARE_RECEIVED,
	handler: NativeShareItemHandlerShareReceivedHandler
) => Promise<PluginListenerHandle>;

export type NativeShareListenerHandler = NativeShareItemHandlerShareReceivedListener;

export interface NativeSharePlugin {
	addListener: NativeShareListenerHandler;
	getLastSharedItems: () => Promise<NativeShareShareReceived>;
}
