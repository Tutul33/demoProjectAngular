using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace feedback.ViewModels
{
    public class vmUserModel
    {
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int? UserTypeId { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public DateTime? BirthDate { get; set; }
        public string UserType { get; set; }
        public string Address { get; set; }
    }
}
