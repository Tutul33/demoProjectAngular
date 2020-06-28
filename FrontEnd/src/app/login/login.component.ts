import { Component, OnInit } from '@angular/core';
import { FeedbackService } from '../shared/feedback.service';
import {Router} from '@angular/router' 
@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  public _userAuthenticationUrl:string='users/userAuthentication';
  public _userCreationUrl:string='users/userCreate';
  public username:string='';
  public password: string='';
  public res:any;
  public islogin:boolean=true;
  public Message:string='';
  public UserModel:any={
    userId:0,
    firstName:'',
    lastName:'',
    userTypeId:1,
    userName:'',
    password:'',
    email:'',
    countryCode:'',
    phone:'',
    birthDate:'',
    address:''
  };
  constructor(private _dataService:FeedbackService,public _router:Router) { }

  ngOnInit(): void {
  }
 
 
  UserAuthentication(){
    if(this.username==''){
      this.Message="Please enter user name.";
      return;
    }
    if(this.password==''){
      this.Message="Please enter password.";
      return;
    }
  var param = [{ Username: this.username,password:this.password }];
        
  this._dataService.post(this._userAuthenticationUrl, param)
            .subscribe(response => {
                this.res = response;             
                if (this.res.resdata.resstate) {
                  localStorage.setItem('userId', this.res.resdata.userId);
                  localStorage.setItem('username', this.res.resdata.username);
                  localStorage.setItem('userModel', JSON.stringify(this.res.resdata.userModel));
                  this._router.navigate(['/newbook']);
                } else {
                  this.Message='Please enter exact user name or email and password.';
                          }
            }, error => {
                console.log(error);
            });

}
ValidateEmail(){
  var isValid = this.validateEmail(this.UserModel.email);
  if (!isValid) {
      this.Message='Please enter valid email id.';
  }else{
    this.Message='';
  }
  return isValid;
}
validateEmail(email: string) {
  var isValid = true;
  var re = /\S+@\S+\.\S+/;
  if (re.test(email.toString()) === false) {
      isValid = false
  }
  return isValid;
}
UserCreate(){
  if(this.UserModel.firstName==''){
    this.Message="Please enter first name.";
    return;
  }
  if(this.UserModel.lastName==''){
    this.Message="Please enter last name.";
    return;
  }
  if(this.UserModel.email==''){
    this.Message="Please enter email.";
    return;
  }
  if(this.UserModel.password==''){
    this.Message="Please enter password.";
    return;
  } 
  if(!this.ValidateEmail()){
    this.Message="Please enter valid email.";
    return;
  }
  
  //var param = [{ Username: this.username,password:this.password }];""
  console.log(JSON.stringify(this.UserModel));
  var param = [this.UserModel];    
  this._dataService.post(this._userCreationUrl, param)
            .subscribe(response => {
                this.res = response;             
                if (this.res.resdata.resstate) {
                this.islogin=true;
                } else {
                          }
            }, error => {
                console.log(error);
            });

}


}
