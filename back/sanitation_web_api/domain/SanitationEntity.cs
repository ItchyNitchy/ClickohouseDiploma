using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace sanitation_web_api.domain
{
    public class SanitationEntity : SanitationDto { }

    public class SnitationConfiguration : IEntityTypeConfiguration<SanitationEntity>
    {
        public void Configure(EntityTypeBuilder<SanitationEntity> entity)
        {
            entity.ToTable("fulfilments");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.Id).HasColumnName("id").ValueGeneratedOnAdd();
            entity.Property(x => x.Values).HasColumnName("values");
            entity.Property(x => x.Year).HasColumnName("year");
            entity.Property(x => x.SourceId).HasColumnName("source_id");
            entity.Property(x => x.DistrictId).HasColumnName("district_id");
            entity.Property(x => x.RegionId).HasColumnName("region_id");
        }
    }
}
