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
	public log = '';
	public logArr: string[] = [];
	public eventData = 'Nothing received';

	private listener?: PluginListenerHandle;

	constructor(private readonly cdRef: ChangeDetectorRef, private readonly ngZone: NgZone) {}

	async ngOnInit(): Promise<void> {
		this.addToLog('onInit')

		NativeShare.getLastSharedItems()
			.then((ev) => {
				this.addToLog("getLastSharedItems");
				this.handleShare(ev);
			})
			.catch((error) => {
				this.addToLog('getLastSharedItems error');
				this.addToLog(error);
				console.error(error);
			});

		this.listener = await NativeShare.addListener(
			NativeShareEventType.SHARE_RECEIVED,
			(ev) => {
				this.addToLog('listener');
				this.handleShare(ev);
			}
		);
	}

	ngOnDestroy(): void {
		this.listener?.remove();
	}

	private handleShare(event: NativeShareShareReceived): void {
		this.ngZone.run(() => {
			this.eventData = JSON.stringify(event, null, 4);
			this.addToLog('handleShre');
			this.cdRef.detectChanges();
		});
	}

	private addToLog(item: string): void {
		this.logArr.push(item);
		this.log = JSON.stringify(this.logArr, null, 4);
		this.cdRef.detectChanges();
	}
}
