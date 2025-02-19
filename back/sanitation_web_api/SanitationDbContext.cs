using Microsoft.EntityFrameworkCore;
using sanitation_web_api.domain;

namespace sanitation_web_api
{
    public class SanitationDbContext(DbContextOptions<SanitationDbContext> options) : DbContext(options)
    {
        public DbSet<SanitationEntity> Sanitations { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfigurationsFromAssembly(typeof(SanitationDbContext).Assembly);
        }

    }
}
