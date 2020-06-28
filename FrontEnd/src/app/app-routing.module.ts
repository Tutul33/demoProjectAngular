import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {FeedbacksComponent} from './feedbacks/feedbacks.component'
import {LoginComponent} from './login/login.component'
import {NewBookComponent} from './new-book/new-book.component';
const routes: Routes = [
  {
    path:'',
    component:LoginComponent
  },
  {
    path:'login',
    component:LoginComponent
  },
  {
    path:'feedback',
    component:FeedbacksComponent
  }
  ,{
    path:'newbook',
    component:NewBookComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
