using System;
using System.Collections.Generic;

namespace feedback.Models
{
    public partial class User
    {
        public User()
        {
            Comment = new HashSet<Comment>();
            Post = new HashSet<Post>();
        }

        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int? UserTypeId { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public DateTime? BirthDate { get; set; }
        public string UserType { get; set; }
        public string Address { get; set; }

        public ICollection<Comment> Comment { get; set; }
        public ICollection<Post> Post { get; set; }
    }
}
