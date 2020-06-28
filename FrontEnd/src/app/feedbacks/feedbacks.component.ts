import { Component,ViewChild, ElementRef, OnInit } from '@angular/core';
import { FeedbackService } from '../shared/feedback.service';
import { PagerService } from '../shared/pagerservice';
import {Router} from '@angular/router';
import * as $ from 'jquery';
//For debouncing search import start 
import { of } from "rxjs";
import {
  debounceTime,
  map,
  distinctUntilChanged,
  filter
} from "rxjs/operators";
import { fromEvent } from 'rxjs';
//End
@Component({
  selector: 'app-feedbacks',
  templateUrl: './feedbacks.component.html',
  styleUrls: ['./feedbacks.component.css']
})
export class FeedbacksComponent implements OnInit {
  //To searching with debouncing
  @ViewChild('SearchInput', { static: true }) SearchInput: ElementRef;

  //Common Variable
  public _postListUrl: string = 'posts/getPostDataUsingSP'; //for ADO.NET and Store Procedure
  //public _postListUrl: string = 'posts/getPostDataUsingLinq'; // for entity framework core and LINQ
  public loggedUserId:number=0;
  public loggedUserName:string='';
  public textData:string='';
  public Message:string='';
  public res:any;
  public search:string='';

  //Comment Variable
  public _createCommentUrl:string='comment/createComment';
  public isCommentCreate:boolean=false;
  public postObject:any;
  public listPost:any=[];

  //Post Variable
  public _createPostUrl:string='posts/createPost';
  public isPostCreate:boolean=false;
  public isCreate:boolean=false;
  
  //Like or Dislike variable
  public _setOpinionUrl:string='comment/setOpinion';

  //Pagination
  public pageNumber: number = 0;
  public pageSize: number = 5;
  public totalRows: number = 0;
  public pager: any = {};
  public pagedItems: any = [];
  public pageStart: number = 0;
  public pageEnd: number = 0;
  public isSerachng:boolean=false;
  constructor(private _dataService:FeedbackService,public pagerService:PagerService,public _router:Router) { }

  ngOnInit(): void {
    var userID=localStorage.getItem('userId');    
    this.loggedUserId=parseInt(userID);
    this.loggedUserName=localStorage.getItem('username');
    if(this.loggedUserId<=0){
      this._router.navigate(['/login']);
    }

    //To search with debouncing time
    this.searchWithDebouncingTime();

    if(!this.isSerachng)
    this.loadPostData(1,true,this.pageSize); 

  }
  searchWithDebouncingTime(){
    fromEvent(this.SearchInput.nativeElement, 'keyup').pipe(

      // get value
      map((event: any) => {
        return event.target.value;
      })
      // if character length greater then 2
      , filter(res => res.length > 2)

      // Time in milliseconds between key events
      , debounceTime(1000)

      // If previous query is diffent from current   
      , distinctUntilChanged()

      // subscription for response
    ).subscribe((text: string) => {     
      this.isSerachng=true; 
      this.search=text;
      this.loadPostData(1,true,this.pageSize);
    });
  }

  searchPost(){
    if(this.search.trim()!='')
        this.loadPostData(0,true,this.pageSize);

  }
  loadPostData(pageIndex: number, isPaging: boolean, pageSize: number) {
    this.pageNumber = pageIndex;

    var param = { pageNumber: pageIndex, pageSize: pageSize,search:this.search,userID:this.loggedUserId };
    this._dataService.getAll(this._postListUrl,param)
        .subscribe(
            response => {
                this.listPost = [];
               
                this.res = response;
                if (this.res.resdata === null && this.res.resdata.listPost.length === 0) {
                   
                } else if (this.res.resdata.listPost !== "") {
                    //Uncomment below code for ADO.NET and when result from Store procedure
                    this.listPost = JSON.parse(this.res.resdata.listPost);

                    //Uncomment below code for Entity Framework Core and when result from linq
                    //this.listPost=this.res.resdata.listPost;

                    this.totalRows = this.listPost[0].recordsTotal;
                  //  this.totalRowsInList = this.listBillLedger.length;
                    if (this.pageNumber == 0 || this.pageNumber == 1) {
                        this.pageStart = 1;
                        if (this.totalRows < this.pageSize) {
                            this.pageEnd = this.totalRows;
                        } else {
                            this.pageEnd = this.pageSize;
                        }
                    } else {
                        this.pageStart = (this.pageNumber - 1) * this.pageSize + 1;
                        this.pageEnd = (this.pageStart - 1) + this.totalRows;
                    }
                    //paging info end
                    if (isPaging)
                        this.setPaging(pageIndex, false);
                    else
                        this.pagedItems = this.listPost;
                }
                else {
                   
                }
            }, error => {
                console.log(error);
            }
        );
}

//Set Page
setPaging(page: number, isPaging: boolean) {
    this.pager = this.pagerService.getPager(this.totalRows, page, this.pageSize);
    if (isPaging) {
        this.loadPostData(page, false, this.pager.pageSize);
    }
    else {
        this.pagedItems = this.listPost;
        
    }
}
//Like or disloke section
setOpinion(model,opinion){
  if(model.isLikedByLoggedUser===opinion){
    var strOp=opinion?'You already like it.':'You already dislike it.';
    this.Message=strOp+'Please select different sign.';
    return;
  }
  this.Message='';
  var param = [{ opinion: opinion,id:model.commentId ,userId:this.loggedUserId}];
        
  this._dataService.post(this._setOpinionUrl, param)
            .subscribe(response => {
                this.res = response;
             
                if (this.res.resdata.resstate) {
                   this.loadPostData(this.pageNumber,true,this.pageSize);
                } else {
                          }
            }, error => {
                console.log(error);
            });

}

//Post Section 

GoToCreatePost(){
  this.isPostCreate=true;
  this.isCreate=true;
  this.textData='';
}
createPost(){
  if(this.textData==''){
    this.Message='Post can not be empty.';
    return;
  }
  var param = [{ userID: this.loggedUserId,postText:this.textData }];
        
  this._dataService.post(this._createPostUrl, param)
            .subscribe(response => {
                this.res = response;
             
                if (this.res.resdata.resstate) {
                  this.isPostCreate=false;
                  this.isCreate=false;
                  this.Message='';
                   this.loadPostData(0,true,this.pageSize);
                } else {
                          }
            }, error => {
                console.log(error);
            });
}
//Comment section
GoToCreateComment(item){
  this.isCommentCreate=true;
  this.isCreate=true;
  this.postObject=item;
  this.textData='';
}
createComment(){
  if(this.textData==''){
    this.Message='Comment can not be empty.';
    return;
  }
  var param = [{ userId: this.loggedUserId,postId:this.postObject.postId,commentText:this.textData }];
        
  this._dataService.post(this._createCommentUrl, param)
            .subscribe(response => {
                this.res = response;
             
                if (this.res.resdata.resstate) {
                  this.isCommentCreate=false;
                  this.isCreate=false;
                  this.Message='';
                   this.loadPostData(0,true,this.pageSize);
                } else {
                          }
            }, error => {
                console.log(error);
            });
}
//Logout Section
LogOut(){
  localStorage.setItem('userId', '');
  this._router.navigate(['/login']);
}

}
