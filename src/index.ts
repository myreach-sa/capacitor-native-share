import { registerPlugin } from '@capacitor/core';

import type { NativeSharePlugin } from './definitions';

const NativeShare = registerPlugin<NativeSharePlugin>('NativeShare', {
	web: () => import('./web').then((m) => new m.NativeShareWeb()),
});

export * from './definitions';
export { NativeShare };
