using ClickHouse.Client.ADO;
using ClickHouse.Client.Utility;
using sanitation_web_api.domain;

namespace sanitation_web_api.helpers
{
    public class ClickhouseClientDecorator(string? dsn) : ClickHouseConnection(dsn)
    {
        public async Task InsertFulfilment(SanitationEntity value, int sign)
        {
            var command = $@"INSERT INTO sanitation_of_settlements.sorting_and_recycling
                    (version, sign, year, source_id, district_id, region_id, values)
                    VALUES
                    ({value.Id}, {sign}, {value.Year}, {value.SourceId}, {value.DistrictId}, {value.RegionId}, [{String.Join(",", value.Values)}])";

            await this.ExecuteScalarAsync(command);
        }
    }
}
