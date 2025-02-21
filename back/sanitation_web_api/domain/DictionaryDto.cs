using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace sanitation_web_api.domain
{
    public class DictionaryDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = "";
    }

    public class OrganizationsEntity : DictionaryDto { }
    public class OrganizationsConfiguration : IEntityTypeConfiguration<OrganizationsEntity>
    {
        public void Configure(EntityTypeBuilder<OrganizationsEntity> entity)
        {
            entity.ToTable("organizations");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.Id).HasColumnName("id");
            entity.Property(x => x.Name).HasColumnName("name");
        }
    }

    public class RegionsEntity : DictionaryDto { }
    public class RegionsConfiguration : IEntityTypeConfiguration<RegionsEntity>
    {
        public void Configure(EntityTypeBuilder<RegionsEntity> entity)
        {
            entity.ToTable("regions");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.Id).HasColumnName("id");
            entity.Property(x => x.Name).HasColumnName("name");
        }
    }

    public class DistrictsEntity : DictionaryDto { }
    public class DistrictsConfiguration : IEntityTypeConfiguration<DistrictsEntity>
    {
        public void Configure(EntityTypeBuilder<DistrictsEntity> entity)
        {
            entity.ToTable("districts");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.Id).HasColumnName("id");
            entity.Property(x => x.Name).HasColumnName("name");
        }
    }
}
