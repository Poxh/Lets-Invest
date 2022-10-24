using Microsoft.EntityFrameworkCore;
using lets_invest_api.Models;

namespace lets_invest_api.Data
{
    public class Database : DbContext
    {
        public Database(DbContextOptions<Database> options) : base(options) {}

        public DbSet<User> Users {   get; set;  }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<User>()
                .HasOne(u => u.Portfolio)
                .WithOne(p => p.User)
                .HasForeignKey<Portfolio>(b => b.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
