import { Injectable } from '@angular/core';
import { HttpClient ,HttpParams ,HttpErrorResponse} from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';  
import { Observable,throwError } from 'rxjs'; 
import { map, catchError } from 'rxjs/operators';
import { analyzeAndValidateNgModules } from '@angular/compiler';
@Injectable({
  providedIn: 'root'
})
export class FeedbackService {
  public apiHost: string='http://localhost:58349/api/';
  constructor(private http: HttpClient) { }
  JsonStringify(models: any): string {
    var smodel = '';
    if (models.length !== undefined) {
        if (models.length > 1) {
            for (var i = 0; i < models.length; i++) {
                if (i == 0) {
                    smodel += "[" + JSON.stringify(models[i]) + ",";
                }
                else if (i == (models.length - 1)) {
                    smodel += JSON.stringify(models[i]) + "]";
                }
                else {
                    smodel += JSON.stringify(models[i]) + ",";
                }
            }
        }
        else {
            smodel = "[" + JSON.stringify(models[0]) + "]";
        }
    }
    else {
        smodel = "[" + JSON.stringify(models) + "]";
    }
    return smodel;
}
  getAll(controllerName:string,model:any): Observable<any[]> {
    var url='';
    const headers = new HttpHeaders({'Content-Type':'application/json; charset=utf-8'});

     let qString = this.JsonStringify(model);
    url  = this.apiHost + controllerName+"?param="+qString ;

  // Add safe, URL encoded search parameter if there is a search term
  const options ={headers:headers};
  return this.http.get<any[]>(url,options);
 
  }  
  getById(Id: string,controllerName:string): Observable<any> {  
    return this.http.get<any>(this.apiHost + controllerName + Id);  
  }  
  post(controllerName:string,model: any): Observable<any> {  
    let body = this.JsonStringify(model); 
    const httpOptions = { headers: new HttpHeaders({ 'Content-Type': 'application/json'}) };  
    var url='';
    url=this.apiHost + controllerName;
    //https://localhost:44342/api/comment/setOpinion
    return this.http.post<any>(url, body, httpOptions);  
  }  
  put(model: any,controllerName:string): Observable<any> {  
    const httpOptions = { headers: new HttpHeaders({ 'Content-Type': 'application/json'}) };  
    var url='';
    url=this.apiHost + controllerName;
    return this.http.put<any>(url,  
    model, httpOptions);  
  }  
  delete(Id: string,controllerName:string): Observable<number> {  
    const httpOptions = { headers: new HttpHeaders({ 'Content-Type': 'application/json'}) }; 
    var url='';
    url=this.apiHost +controllerName+ '?id=' +Id;
    return this.http.delete<number>(url,   httpOptions);  
  }  
errorHandler(error: HttpErrorResponse) {
  if (error.error instanceof ErrorEvent) {
    // A client-side or network error occurred. Handle it accordingly.
    console.error('An error occurred:', error.error.message);
  } else {
    // The backend returned an unsuccessful response code.
    // The response body may contain clues as to what went wrong,
    console.error(
      `Backend returned code ${error.status}, ` +
      `body was: ${error.error}`);
  }
  // return an observable with a user-facing error message
  return throwError(
    'Something bad happened; please try again later.');
}
}

