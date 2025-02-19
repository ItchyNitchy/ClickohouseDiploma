using ClickHouse.Client.ADO;
using ClickHouse.Client.Utility;
using Microsoft.AspNetCore.Mvc;
using sanitation_web_api.domain;

namespace sanitation_web_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ValuesController(SanitationDbContext postgres, ClickHouseConnection clickHouse) : ControllerBase
    {
        [HttpPost]
        public async Task<IActionResult> AddFulfilment(SanitationEntity entity)
        {
            postgres.Sanitations.Add(entity);
            await postgres.SaveChangesAsync();

            var command = $@"INSERT INTO sanitation_of_settlements.sorting_and_recycling
                    (version, sign, year, source_id, district_id, region_id, values)
                    VALUES
                    ({entity.Id}, {1}, {entity.Year}, {entity.SourceId}, {entity.DistrictId}, {entity.RegionId}, [{String.Join(",",entity.Values)}])";

            await clickHouse.ExecuteScalarAsync(command);

            return Ok();
        }
    }
}
