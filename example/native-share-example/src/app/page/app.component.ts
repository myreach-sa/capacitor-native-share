import { CommonModule } from '@angular/common';
import {
	ChangeDetectionStrategy,
	ChangeDetectorRef,
	Component,
	NgModule,
	NgZone,
	OnDestroy,
	OnInit,
} from '@angular/core';
import { DomSanitizer, SafeUrl } from '@angular/platform-browser';
import { Capacitor, PluginListenerHandle } from '@capacitor/core';
import {
	NativeShare,
	NativeShareEventType,
	NativeShareItem,
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

	public sharedEvent: NativeShareItem[] = [];
	public currentItemSrc?: SafeUrl;
	public selectedIndex?: number;

	public loading = false;

	public get somethingShared(): boolean {
		return this.sharedEvent.length > 0;
	}

	private listener?: PluginListenerHandle;

	private fileUrl?: string;

	constructor(private readonly cdRef: ChangeDetectorRef, private readonly ngZone: NgZone, private sanitizer: DomSanitizer) {}

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

	public isSelected(index: number): boolean {
		return this.selectedIndex === index;
	}

	public selectItem(index: number): void {
		if (this.fileUrl) {
			try {
				URL.revokeObjectURL(this.fileUrl);
				this.fileUrl = undefined;
			} catch (error) {
				console.error(error);
			}
		}

		console.log('selectItem', index, this.sharedEvent);

		if (this.sharedEvent.length > index && index >= 0) {
			try {
				this.selectedIndex = index;
				this.loading = true;
				const item = this.sharedEvent[index];
				this.handleItemSelection(item);
			} catch (error) {
				console.error('selectItem', error);
			}
		} else {
			this.selectedIndex = undefined;
			this.currentItemSrc = undefined;
		}
		this.cdRef.detectChanges();
	}

	private handleShare(event: NativeShareShareReceived): void {
		this.ngZone.run(() => {
			try {
				this.processShare(Object.values(event.items).filter(({text, uri, mimeType}) => `${text}${uri}${mimeType}` !== ''));
			} catch (error) {
				console.error('handleShare', error);
			}
		});
	}

	private addToLog(item: string): void {
		console.log(item);
		this.logArr.push(item);
		this.log = JSON.stringify(this.logArr, null, 4);
		this.cdRef.detectChanges();
	}

	private processShare(items: NativeShareItem[]): void {
		this.sharedEvent = items;
		this.selectItem(0);
		this.cdRef.detectChanges();
	}

	private async handleItemSelection(item: NativeShareItem): Promise<void> {
		try {
			const isFile = item.uri || '' !== '';
			const src = isFile ? Capacitor.convertFileSrc(item.uri) : item.text;

			console.log({isFile, src});
			
			if (isFile) {
				const response = await fetch(src);
				const blob = await response.blob();
				const file = new File([blob], 'test', { type: item.mimeType });

				console.log(file);

				this.fileUrl = URL.createObjectURL(file);
				this.currentItemSrc = this.sanitizer.bypassSecurityTrustResourceUrl(this.fileUrl);
				
				console.log(this.fileUrl);
				console.log(this.currentItemSrc);
			} else {
				this.currentItemSrc = this.sanitizer.bypassSecurityTrustResourceUrl(src);
			}
		} catch (error) {
			console.error('handleItemSelection', JSON.stringify(error));	
		}

		this.loading = false;

		this.cdRef.detectChanges();
	}
}

@NgModule({
	declarations: [AppComponent],
	imports: [CommonModule],
	exports: [AppComponent],
})
export class AppPageModule {}