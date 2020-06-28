using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace feedback.ViewModels
{
    public static class dataUtilities
    {
        public const String conString = @"Server=TUTULPC\TUTUL;Database=FeedBack;Trusted_Connection=True;";
        public const string SpGetPostData = "[dbo].[SpGetPostData]";
        public static string getMinuteToYear_Month_Day_Min_Second(decimal minute)
        {
            string result = "";
            decimal Hours = minute / 60;
            decimal hoursPart = Hours - Hours % 1;
            decimal minPart = (Hours % 1 )*60;
            decimal secondPart = (((Hours % 1) * 60 % 1) * 10);
            if(hoursPart>0 && minPart > 0)
            {
                int day = 0, month = 0,hourss=0,year=0, std_day_to_hour=24, @std_hours=0, std_month_to_hour=730, std_year_to_hour=8760;
                if(hoursPart < @std_year_to_hour)
                {
                    year=0;
                }
                else
                {
                    year = (int)hoursPart / std_year_to_hour;
                }
               
                if((hoursPart% std_year_to_hour)< std_month_to_hour)
                {
                    month = 0;
                }
                else
                {
                    month = (int)(hoursPart % std_year_to_hour) / std_month_to_hour;
                }
                
                if(((hoursPart % std_year_to_hour) % std_month_to_hour) < std_day_to_hour)
                {
                    day = 0;
                }
                else
                {
                    day = (int)((hoursPart % std_year_to_hour) % std_month_to_hour) / std_day_to_hour;
                }
                hourss = (int)(((hoursPart % std_year_to_hour) % std_month_to_hour) % @std_day_to_hour);

                #region For year
                if (year>0)
                {
                    if(hoursPart < std_year_to_hour)
                    {
                        result = "";
                    }
                    else
                    {
                        var yres=(int)(hoursPart / std_year_to_hour);
                        result = yres.ToString();
                    }

                    if (year > 1)
                    {
                        result = result + " " + "years";
                    }
                    else {
                        result = result + " " + "year";
                    }
                }
                #endregion
                #region For month
                if (month > 0)
                {
                    if((hoursPart % std_year_to_hour) < std_month_to_hour)
                    {
                        result = result + "";
                    }
                    else
                    {
                        var mntres = (int)((hoursPart % std_year_to_hour) / std_month_to_hour);
                        result = result + " " + mntres.ToString();
                    }

                    if (month > 1)
                    {
                        result = result + " " + "months";
                    }
                    else
                    {
                        result = result + " " + "month";
                    }
                }
                #endregion
                #region For day
                if (day > 0)
                {
                    if (((hoursPart % std_year_to_hour) % std_month_to_hour) < std_day_to_hour){
                        result = result + "";
                    }
                    else
                    {
                        var dayRes = (int)(((hoursPart % std_year_to_hour) % std_month_to_hour) / std_day_to_hour);
                        result = result + " "+ dayRes.ToString();
                    }
                    if (day > 1)
                    {
                        result = result +" "+ "days";
                    }
                    else
                    {
                        result = result + " " + "day";
                    }
                }
                #endregion
                #region For hours
                if(hourss> 0)
                {
                    //var hrs = hourss;
                    result = result +" "+ hourss;
                    if (hourss > 1)
                    {
                        result = result + " " + "hours";
                    }
                    else
                    {
                        result = result + " " + "hour";
                    }

                }
                #endregion
                #region For minutes
                if (minPart > 0)
                {
                    var mints = (int)minPart;
                    result = result + " " + mints;
                    if (mints > 1)
                    {
                        result = result + " " + "minutes";
                    }
                    else
                    {
                        result = result + " " + "minute";
                    }

                }
                #endregion
                #region For seconds
                if (secondPart > 0)
                {
                    int secs=(int)secondPart;
                    result = result + " " + secs;
                    if (secs > 1)
                    {
                        result = result + " " + "seconds";
                    }
                    else
                    {
                        result = result + " " + "second";
                    }

                }
                #endregion
            }
            else
            {
                int secs = (int)secondPart;
                result = result + " " + secs;
                if (secs > 1)
                {
                    result = result + " " + "seconds";
                }
                else
                {
                    result = result + " " + "second";
                }

            }
            return result;
        }
    }
}
