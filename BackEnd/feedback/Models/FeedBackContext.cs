using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace feedback.Models
{
    public partial class FeedBackContext : DbContext
    {
        public FeedBackContext()
        {
        }

        public FeedBackContext(DbContextOptions<FeedBackContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Comment> Comment { get; set; }
        public virtual DbSet<OpinionLog> OpinionLog { get; set; }
        public virtual DbSet<Post> Post { get; set; }
        public virtual DbSet<PostType> PostType { get; set; }
        public virtual DbSet<User> User { get; set; }
        public virtual DbSet<UserType> UserType { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
                optionsBuilder.UseSqlServer("Server=TUTULPC\\TUTUL;Database=FeedBack;Trusted_Connection=True;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Comment>(entity =>
            {
                entity.Property(e => e.CDislike).HasColumnName("cDislike");

                entity.Property(e => e.CLike).HasColumnName("cLike");

                entity.Property(e => e.CreationTime).HasColumnType("datetime");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Comment)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("FK_Comment_Post");
            });

            modelBuilder.Entity<Post>(entity =>
            {
                entity.Property(e => e.CreationTime).HasColumnType("datetime");

                entity.Property(e => e.ImagePath)
                    .HasColumnName("imagePath")
                    .HasMaxLength(200);

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Post)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("FK_Post_User");
            });

            modelBuilder.Entity<PostType>(entity =>
            {
                entity.Property(e => e.PostTypeIcon).HasMaxLength(100);

                entity.Property(e => e.PostTypeName).HasMaxLength(200);
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.Property(e => e.Address).HasMaxLength(500);

                entity.Property(e => e.BirthDate).HasColumnType("datetime");

                entity.Property(e => e.Email).HasMaxLength(50);

                entity.Property(e => e.FirstName).HasMaxLength(200);

                entity.Property(e => e.LastName).HasMaxLength(200);

                entity.Property(e => e.Password).HasMaxLength(20);

                entity.Property(e => e.Phone).HasMaxLength(200);

                entity.Property(e => e.UserName).HasMaxLength(300);

                entity.Property(e => e.UserType).HasMaxLength(300);
            });

            modelBuilder.Entity<UserType>(entity =>
            {
                entity.Property(e => e.UserTypeName).HasMaxLength(200);
            });
        }
    }
}
