import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent, AppPageModule } from './page/app.component';

@NgModule({
	imports: [BrowserModule, AppPageModule],
	bootstrap: [AppComponent],
})
export class AppModule {}
