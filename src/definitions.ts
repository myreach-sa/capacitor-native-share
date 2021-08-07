export interface NativeSharePlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
