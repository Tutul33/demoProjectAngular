import { debounce } from "rxjs/operators";

export class PagerService {
    getPager(totalItems: number, currentPage: number = 1, pageSize: number = 10) {
        // calculate total pages
        pageSize = pageSize.toString() === 'All' ? totalItems : pageSize;
         
        // calculate total pages without 'All'
        let totalPages = Math.ceil(totalItems / pageSize);

        // ensure current page isn't out of range
        if (currentPage < 1) {
            currentPage = 1;
        } else if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        let startPage: number, endPage: number;
        if (totalPages <= 10) {
            // less than 10 total pages so show all
            startPage = 1;
            endPage = totalPages;
        } else {
            // more than 10 total pages so calculate start and end pages
            if (currentPage <= 6) {
                startPage = 1;
                endPage = 10;
            } else if (currentPage + 4 >= totalPages) {
                startPage = totalPages - 9;
                endPage = totalPages;
            } else {
                startPage = currentPage - 5;
                endPage = currentPage + 4;
            }
        }

        // calculate start and end item indexes
        let startIndex = (currentPage - 1) * pageSize;
        let endIndex = Math.min(startIndex + pageSize - 1, totalItems - 1);

        // create an array of pages to ng-repeat in the pager control
        let pages = Array.from(Array((endPage + 1) - startPage).keys()).map(i => startPage + i);

        // return object with all pager properties required by the view
        return {
            totalItems: totalItems,
            currentPage: currentPage,
            pageSize: pageSize,
            totalPages: totalPages,
            startPage: startPage,
            endPage: endPage,
            startIndex: startIndex,
            endIndex: endIndex,
            pages: pages
        };
    }

    pageSize() {
        //return [5, 10, 20, 50, 100, 'All'];
        return [5, 10, 20, 50, 100];
    }
    convertToDateString(date) {
       if(date!==''){
        var rdate=date.split("T");
        return rdate[0];
       }else{
           return '';
       }
       
    }
    getCurrentTimeZoneMin() {
        var formatted;
        var offset = new Date().getTimezoneOffset();
        if (offset < 0) {
            formatted = -(offset*1);
        }
        else {
            formatted = -(offset);
        }
        //var formatted = -(offset / 60);
        return formatted;
    }

    convertUTCtoLocal(utcdate) {
        //utcdate = utcdate.replace('T', ' ')
        var tz = this.getCurrentTimeZoneMin();
        //var dd = utcdate + ' UTC';
        var sdate = new Date(utcdate);
        var date = new Date(sdate.setMinutes(sdate.getMinutes() + tz));
        var rdate = date.getFullYear() + '-' + ('0' + (date.getMonth() + 1)).slice(-2) + '-' + ('0' + date.getDate()).slice(-2) + ' ' + ('0' + date.getHours()).slice(-2) + ':' + ('0' + date.getMinutes()).slice(-2) + ':' + ('0' + date.getSeconds()).slice(-2);        
        return rdate;
    }
    convertTime24to12Capital(datetime) {
        debugger
        var time=datetime.split('T');
        var hours = time[1].split(":")[0];
        var minutes = time[1].split(":")[1];
        var suffix = hours >= 12 ? "PM" : "AM";
        hours = hours % 12 || 12;
        hours = hours < 10 ? "0" + hours : hours;

        var displayTime = hours + ":" + minutes + " " + suffix;

        return time[0] + ' ' + displayTime;
    }
    getTimeDiffernce(datetime){
        var time=datetime.split('T');
        var hours = time[1].split(":")[0];
        var minutes = time[1].split(":")[1];
        var seconds = time[1].split(":")[2];

        var dates  = time[0] + ' ' + hours + ':' +minutes+ ':' +seconds;
        var dates1  = Date.parse(dates);
     //   var dateDiff=new Date(dates1)-Date.now();
      //return dateDiff;
    }
    
}