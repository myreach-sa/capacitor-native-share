# native-share

Converts a native share to a js event

## Install

```bash
npm install native-share
npx cap sync
```

## API

<docgen-index>

* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### Interfaces


#### NativeShareShareReceived

| Prop         | Type                                                                            |
| ------------ | ------------------------------------------------------------------------------- |
| **`items`**  | <code>{ [idx: string]: <a href="#nativeshareitem">NativeShareItem</a>; }</code> |
| **`length`** | <code>number</code>                                                             |


#### NativeShareItem

| Prop           | Type                | Description                                |
| -------------- | ------------------- | ------------------------------------------ |
| **`text`**     | <code>string</code> | The text shared. It can also be a website. |
| **`uri`**      | <code>string</code> | The uri (path) to the shared file.         |
| **`mimeType`** | <code>string</code> | The mimeType of the shared file.           |

</docgen-api>
