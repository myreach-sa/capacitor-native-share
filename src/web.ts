import { WebPlugin } from '@capacitor/core';

import type { NativeShareItem, NativeSharePlugin } from './definitions';

export class NativeShareWeb extends WebPlugin implements NativeSharePlugin {
  getSharedItems(): Promise<NativeShareItem[]> {
    return new Promise<NativeShareItem[]>(res => res([]));
  }
}
