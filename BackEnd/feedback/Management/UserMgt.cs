using feedback.Models;
using feedback.ViewModels;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace feedback.Management
{
    public class UserMgt
    {
        FeedBackContext _ctx = null;
        public async Task<object> userCreate(User model)
        {
            object result = null; string message = string.Empty; bool resstate = false;
            using (_ctx = new FeedBackContext())
            {
                using (var _ctxTransaction = _ctx.Database.BeginTransaction())
                {
                    try
                    {

                        if (model.UserId > 0)
                        {
                            var objUser = await _ctx.User.FirstOrDefaultAsync(x => x.UserId == model.UserId);
                            objUser.UserName = model.UserName;
                            //objUser.UserType = model.UserType;
                            objUser.Password = model.Password;
                            objUser.FirstName = model.FirstName;
                            objUser.LastName = model.LastName;
                            objUser.Email = model.Email;
                            objUser.Phone = model.Phone;
                            objUser.UserTypeId = model.UserTypeId;
                            objUser.Address = model.Address;
                            objUser.BirthDate = model.BirthDate;

                        }
                        else
                        {
                            var objUser = new User();
                            var userId = _ctx.User.DefaultIfEmpty().Max(x => x == null ? 0 : x.UserId) + 1;

                            var emailSplit = model.Email.Split("@");
                            string userName = "" ;
                            if(emailSplit!=null)
                            userName = emailSplit[0];

                            objUser.UserName = userName+"_"+ userId.ToString();
                            //objUser.UserType = model.UserType;
                            objUser.Password = model.Password;
                            objUser.FirstName = model.FirstName;
                            objUser.LastName = model.LastName;
                            objUser.Email = model.Email;
                            objUser.Phone = model.Phone;
                            objUser.UserTypeId = model.UserTypeId;
                            objUser.Address = model.Address;
                            objUser.BirthDate = model.BirthDate;

                            if (objUser != null)
                            {
                                await _ctx.User.AddAsync(objUser);
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
        public async Task<object> userAuthentication(User model)
        {
            object result = null; string message = string.Empty, notificationList = string.Empty; bool resstate = false; 
            int userId = 0;
            string username = "";
            vmUserModel userModel = new vmUserModel();
            try
            {
                using (_ctx = new FeedBackContext())
                {
                    var User = await _ctx.User.FirstOrDefaultAsync(x => (x.UserName == model.UserName ||x.Email == model.UserName) && (x.Password==model.Password));
                    if (User != null)
                    {
                        userId = User.UserId;
                        username = User.UserName;
                        userModel.UserId = User.UserId;
                        userModel.FirstName = User.FirstName;
                        userModel.LastName = User.LastName;
                        userModel.UserName = User.UserName;
                        message = "Login Successfully.";
                        resstate = true;
                    }
                    else
                    {
                        resstate = false;
                    }

                }
            }
            catch (Exception ex)
            {
               //test
            } 

            return result = new
            {
                userModel,
                userId,
                username,
                message,
                resstate
            };
        }
    }
}
