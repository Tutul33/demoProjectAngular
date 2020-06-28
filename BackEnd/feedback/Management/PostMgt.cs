using feedback.Common;
using feedback.db;
using feedback.Models;
using feedback.ViewModels;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace feedback.Management
{
    public class PostMgt
    {
        FeedBackContext _ctx = null;
        Hashtable ht = null;
        private IGenericFactory<vmPost> Generic_vmPost = null;
        public async Task<object> CreatePost(Post model)
        {
            object result = null; string message = string.Empty; bool resstate = false;
            using (_ctx = new FeedBackContext())
            {
                using (var _ctxTransaction = _ctx.Database.BeginTransaction())
                {
                    try
                    {

                        if (model.PostId > 0)
                        {
                            var objPost = await _ctx.Post.FirstOrDefaultAsync(x => x.PostId == model.PostId);
                            objPost.PostText = model.PostText;
                            objPost.CreationTime = DateTime.Now.ToUniversalTime();
                            objPost.UserId = model.UserId;
                            
                        }
                        else
                        {
                            //var dt = DateTime.Now.ToUniversalTime();
                            var objPost = new Post();
                            objPost.PostText = model.PostText;
                            objPost.CreationTime = DateTime.Now;
                            objPost.UserId = model.UserId;

                            if (objPost != null)
                            {
                                await _ctx.Post.AddAsync(objPost);
                            }
                        }

                        await _ctx.SaveChangesAsync();
                        

                        _ctxTransaction.Commit();
                        message = "Saved Successfully";
                        resstate = true;
                    }
                    catch (Exception ex)
                    {
                        _ctxTransaction.Rollback();
                        // Logs.WriteBug(ex);
                        message = "Failed to save.";
                        resstate = false;
                    }
                }
            }
            return result = new
            {
                message,
                resstate
            };
        }
        public async Task<object> GetPostData(vmCommonParam cmnParam)
        {
            object result = null; string listPost = string.Empty;
            try
            {
                Generic_vmPost = new GenericFactory<vmPost>();

                ht = new Hashtable
                {                   
                   { "pageNumber", cmnParam.pageNumber },
                   { "pageSize", cmnParam.pageSize },
                   { "search", cmnParam.search },
                   { "LogedUserId", cmnParam.UserId },
                };

                listPost = await Generic_vmPost.ExecuteCommandString(dataUtilities.SpGetPostData, ht, dataUtilities.conString.ToString());
            }
            catch (Exception ex)
            {
//Logs.WriteBug(ex);
            }

            return result = new
            {
                listPost
            };
        }
        /// <summary>
        /// This method returns an object from database as object with pagination using asynchronous operation by vmCmnParameters class as parameter.
        /// </summary>
        /// <param name="cmnParam"></param>
        /// <returns></returns>
        public async Task<object> GetPostDataWithLinq(vmCommonParam cmnParam)
        {
            List<vmPostList> listPost = null;
            object result = null; int recordsTotal = 0;
            try
            {
                using (_ctx = new FeedBackContext())
                {
                    recordsTotal= _ctx.Post.Where(x=>
                                       !string.IsNullOrEmpty(cmnParam.search) ? x.PostText.Contains(cmnParam.search) : true
                                       ).Count();
                    listPost = await (from p in _ctx.Post
                                      where (
                                              !string.IsNullOrEmpty(cmnParam.search) ? p.PostText.Contains(cmnParam.search) : true
                                            )
                                      select new vmPostList
                                      {
                                          PostId = p.PostId,
                                          PostText = p.PostText,
                                          UserId = p.UserId,
                                          UserType = (_ctx.User.Where(x => x.UserId == p.UserId).FirstOrDefault().UserType),
                                          UserName = (_ctx.User.Where(x => x.UserId == p.UserId).FirstOrDefault().UserName),
                                          FullName =(_ctx.User.Where(x => x.UserId == p.UserId).FirstOrDefault().FirstName +" " + _ctx.User.Where(x => x.UserId == p.UserId).FirstOrDefault().LastName ),
                                          CreationTime = p.CreationTime,
                                          TimeDiff =getTime(DateTime.Now, Convert.ToDateTime(p.CreationTime))  + " ago",
                                          RecordsTotal = recordsTotal,
                                          CommentList = (
                                             from c in _ctx.Comment
                                             join c_u in _ctx.User on c.UserId equals c_u.UserId
                                             where c.PostId == p.PostId
                                             select new CommentList
                                             {
                                                 PostId = c.PostId,
                                                 CommentId = c.CommentId,
                                                 CommentText = c.CommentText,
                                                 CreationTime = c.CreationTime,
                                                 CLike = c.CLike == null ? 0 : c.CLike,
                                                 CDislike = c.CDislike == null ? 0 : c.CDislike,
                                                 UserId = c.UserId,
                                                 UserName = c_u.UserName,
                                                 UserType = c_u.UserType,
                                                 FullName = c_u.FirstName+" "+ c_u.LastName,
                                                 IsLikedByLoggedUser = (_ctx.OpinionLog.Where(x => x.UserId == cmnParam.UserId && x.CommentId==c.CommentId).FirstOrDefault() != null) ? (_ctx.OpinionLog.Where(x => x.UserId == cmnParam.UserId && x.CommentId == c.CommentId).FirstOrDefault().IsLike) : null
                                             }
                                         ).ToList()


                                      }
                    ).OrderByDescending(x => x.PostId).Skip(CommonMethod.Skip(cmnParam)).Take((int)cmnParam.pageSize).ToListAsync();


                }
            }
            catch (Exception ex)
            {

            }

            return result = new
            {
                listPost,
                recordsTotal
            };
        }
        public string getTime(DateTime time1, DateTime time2)
        {
            double res = time1.Subtract(time2).TotalMinutes;
            return dataUtilities.getMinuteToYear_Month_Day_Min_Second((decimal)res);

        }
    }
}
