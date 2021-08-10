# @[rea.ch](https://rea.ch)/capacitor-native-share

Converts a native share to a js event.

## Install

In order to use this library, first add it to your project by:

```bash
npm install @rea.ch/capacitor-native-share --save
```

or

```bash
yarn add @rea.ch/capacitor-native-share
```

## Web

There are two methods that can be used to obtain the shared items:

- **`getLastSharedItems`**: Returns a promise that resolves in the last items shared to the app. The idea behind this is to use it as soon as the app is initialized.

- **`addListener`**: Emits every time the app receives a share **only if the listener was registered before receiving the shared**.

### Example

```typescript
import { NativeShare } from '@rea.ch/capacitor-native-share';

// ...

public onAppInitialization(): void {
	NativeShare.getLastSharedItems()
		.then(this.handleShare.bind(this))
		.catch(console.error);

	NativeShare.addListener(
		NativeShareEventType.SHARE_RECEIVED,
		this.handleShare.bind(this)
	);
}

private handleShare(share: NativeShareShareReceived): void {
	// ...
}
```

## Android

Edit your android's **`AndroidManifest.xml`** file with the types that you want to handle ([ref](https://developer.android.com/guide/components/intents-filters#Receiving)):

```xml
<!-- Single share -->
<intent-filter>
	<action android:name="android.intent.action.SEND" />

	<category android:name="android.intent.category.DEFAULT" />
	<category android:name="android.intent.category.BROWSABLE" />

	<!-- Any type of data -->
	<data android:mimeType="*/*" />
</intent-filter>

<!-- multiple share -->
<intent-filter>
	<action android:name="android.intent.action.SEND_MULTIPLE" />

	<category android:name="android.intent.category.DEFAULT" />
	<category android:name="android.intent.category.BROWSABLE" />

	<!-- Any type of data -->
	<data android:mimeType="*/*" />
</intent-filter>
```

## iOS

There are some special setup that needs to be done in iOS:

### App Extension

### Override extension class

### Override AppDelegate class

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

## Alternatives

This library is based on these two libraries that handles the share in a similar way:

- [carsten-klaffke/send-intent](https://github.com/carsten-klaffke/send-intent)
- [marwonline/capacitor-share-target](https://github.com/marwonline/capacitor-share-target)
