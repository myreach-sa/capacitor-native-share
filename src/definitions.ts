export interface NativeShareItem {
  /**
   * The text shared. It can also be a website.
   */
  text: string;

  /**
   * The URL of a shared website.
   * Sometimes it is places in the {@link NativeShareItem.text text} field.
   */
  website: string;

  /**
   * The uri (path) to the shared file.
   */
  uri: string;

  /**
   * The mimeType of the shared file.
   */
  mimeType: string;
}

export interface NativeSharePlugin {
  /**
   * Returns a list of the shared items.
   */
  getSharedItems(): Promise<NativeShareItem[]>;
}
