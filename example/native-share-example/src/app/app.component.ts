import {
	ChangeDetectionStrategy,
	ChangeDetectorRef,
	Component,
	NgZone,
	OnDestroy,
	OnInit,
} from '@angular/core';
import { PluginListenerHandle } from '@capacitor/core';
import {
	NativeShare,
	NativeShareEventType,
	NativeShareShareReceived,
} from '@rea.ch/capacitor-native-share';

@Component({
	selector: 'app-root',
	templateUrl: './app.component.html',
	styleUrls: ['./app.component.scss'],
	changeDetection: ChangeDetectionStrategy.OnPush,
})
export class AppComponent implements OnInit, OnDestroy {
	public eventData = 'Nothing received';

	private listener?: PluginListenerHandle;

	constructor(private readonly cdRef: ChangeDetectorRef, private readonly ngZone: NgZone) {}

	async ngOnInit(): Promise<void> {
		NativeShare.getLastSharedItems()
			.then(this.handleShare.bind(this))
			.catch(console.error);

		this.listener = await NativeShare.addListener(
			NativeShareEventType.SHARE_RECEIVED,
			this.handleShare.bind(this)
		);
	}

	ngOnDestroy(): void {
		this.listener?.remove();
	}

	private handleShare(event: NativeShareShareReceived): void {
		this.ngZone.run(() => {
			this.eventData = JSON.stringify(event, null, 4);
			this.cdRef.detectChanges();
		});
	}
}
