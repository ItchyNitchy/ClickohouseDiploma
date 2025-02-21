using Microsoft.EntityFrameworkCore;
using sanitation_web_api.domain;

namespace sanitation_web_api
{
    public class SanitationDbContext(DbContextOptions<SanitationDbContext> options) : DbContext(options)
    {
        public DbSet<SanitationEntity> Sanitations { get; set; }
        public DbSet<OrganizationsEntity> Organizations { get; set; }
        public DbSet<RegionsEntity> Regions { get; set; }
        public DbSet<DistrictsEntity> Districts { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfigurationsFromAssembly(typeof(SanitationDbContext).Assembly);
        }

    }
}
