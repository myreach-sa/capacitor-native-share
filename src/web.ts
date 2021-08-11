import type { ListenerCallback, PluginListenerHandle } from '@capacitor/core';
import { WebPlugin } from '@capacitor/core';

import { NativeSharePlugin, NativeShareShareReceived } from './definitions';

export class NativeShareWeb extends WebPlugin implements NativeSharePlugin {
	addListener(
		// eslint-disable-next-line @typescript-eslint/no-unused-vars
		_eventName: string,
		// eslint-disable-next-line @typescript-eslint/no-unused-vars
		_listenerFunc: ListenerCallback
	): Promise<PluginListenerHandle> & PluginListenerHandle {
		return new Promise<PluginListenerHandle>((resolve) => {
			resolve({ remove: () => new Promise<void>((res) => res()) });
		}) as Promise<PluginListenerHandle> & PluginListenerHandle;
	}

	getLastSharedItems(): Promise<NativeShareShareReceived> {
		return new Promise<NativeShareShareReceived>((_resolve, reject) => {
			reject('Web not supported');
		});
	}

	clear(): Promise<void> {
		return new Promise<void>((resolve) => {
			resolve();
		})
	}
}
