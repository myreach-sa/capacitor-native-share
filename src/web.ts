import { WebPlugin } from '@capacitor/core';

import type { NativeSharePlugin } from './definitions';

export class NativeShareWeb extends WebPlugin implements NativeSharePlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
