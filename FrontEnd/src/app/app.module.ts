import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import {FormsModule } from '@angular/forms';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { FeedbacksComponent } from './feedbacks/feedbacks.component';
import { HttpClientModule } from '@angular/common/http'
import { FeedbackService } from './shared/feedback.service';
import {PagerService} from './shared/pagerservice';
import { LoginComponent } from './login/login.component';
//import { AngularFontAwesomeModule } from 'angular-font-awesome';
import * as bootstrap from 'bootstrap';
import { NewBookComponent } from './new-book/new-book.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatSliderModule } from '@angular/material/slider';
@NgModule({
  declarations: [
    AppComponent,
    FeedbacksComponent,
    LoginComponent,
    NewBookComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule ,
    HttpClientModule,
    BrowserAnimationsModule,
    MatSliderModule
    //,AngularFontAwesomeModule
  ],
  providers: [HttpClientModule,FeedbackService,PagerService],
  bootstrap: [AppComponent]
})
export class AppModule { }
