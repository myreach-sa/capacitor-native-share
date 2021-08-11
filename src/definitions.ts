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


export interface NativeShareGetItemsOptions {
	/**
	 * Whether to remove the share event so if you call {@link NativeSharePlugin.getLastSharedItems} again it will return void.
	 * 
	 * Default: `true`.
	 */
	autoRemove?: boolean;
}
export interface NativeSharePlugin {
	/**
	 * Adds a listener to the plugin.
	 */
	addListener: NativeShareListenerHandler;

	/**
	 * Gets the last shared items. It is used in case the shared was received while the app was not active, and therefore the listener was not placed.
	 * 
	 * This must only be used once, and before adding the listener.
	 */
	getLastSharedItems: (options?: Partial<NativeShareGetItemsOptions>) => Promise<NativeShareShareReceived>;

	/**
	 * Removed the stored share.
	 */
	clear: () => Promise<void>;
}
