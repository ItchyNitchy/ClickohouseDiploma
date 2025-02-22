namespace sanitation_web_api.domain
{
    public class SanitationDto
    {
        public int Id { get; set; }
        public required float[] Values { get; set; }
        public int Year { get; set; }
        public int SourceId { get; set; }
        public int DistrictId { get; set; }
        public int RegionId { get; set; }
    }
}
