using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using sanitation_web_api.domain;
using sanitation_web_api.helpers;

namespace sanitation_web_api.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class ValuesController(SanitationDbContext postgres, ClickhouseClientDecorator clickHouse) : ControllerBase
    {
        [HttpPost]
        public async Task<IActionResult> AddFulfilment(SanitationEntity entity, CancellationToken cancellation)
        {
            var previousFulfiments = await postgres.Sanitations
                .Where(x => x.Year == entity.Year &&
                    x.SourceId == entity.SourceId &&
                    x.DistrictId == entity.DistrictId &&
                    x.RegionId == entity.RegionId)
                .OrderBy(x => x.Id)
                .LastOrDefaultAsync(cancellation);

            postgres.Sanitations.Add(entity);
            await postgres.SaveChangesAsync();

            if (previousFulfiments != null)
                await clickHouse.InsertFulfilment(previousFulfiments, -1);

            await clickHouse.InsertFulfilment(entity, 1);

            return Ok();
        }

        [HttpGet]
        public async Task<SanitationEntity?> GetPreviousFulfilment(int sourceId, int regionId, int districtId, int year, CancellationToken cancellation)
        {
            var previousFulfiments = await postgres.Sanitations
                .Where(x => x.Year == year &&
                    x.SourceId == sourceId &&
                    x.DistrictId == districtId &&
                    x.RegionId == regionId)
                .OrderBy(x => x.Id)
                .LastOrDefaultAsync(cancellation);

            return previousFulfiments;
        }

        [HttpGet]
        public async Task<DictionaryDto[]> GetDictitonary(int type, CancellationToken cancellation) => type switch
        {
            1 => await postgres.Organizations.ToArrayAsync(cancellation),
            2 => await postgres.Regions.ToArrayAsync(cancellation),
            3 => await postgres.Districts.ToArrayAsync(cancellation),
            _ => []
        };

        [HttpGet]
        public async Task<IActionResult> GetAggregated(int regionId, int year, int? districtId, CancellationToken cancellation)
        {
            //sorting_and_recycling_per_district

            using var command = clickHouse.CreateCommand();
            var query = districtId == null ?
                @$"select sumForEachMerge(values) as values
                            from sanitation_of_settlements.sorting_and_recycling_per_region 
                                WHERE region_id = {regionId} AND year = {year} GROUP BY year, region_id FORMAT JSONEachRow" :
                @$"select sumForEachMerge(values) as values
                            from sanitation_of_settlements.sorting_and_recycling_per_district 
                                WHERE region_id = {regionId} AND district_id = {districtId} AND year = {year} GROUP BY year, region_id, district_id FORMAT JSONEachRow";

            command.CommandText = query;

            var result = await command.ExecuteRawResultAsync(cancellation);
            using var stream = await result.ReadAsStreamAsync();
            using var reader = new StreamReader(stream);
            var json = reader.ReadToEnd();

            //var result = await clickHouse.(query);

            return Content(json, "application/json");
        }


        [HttpGet]
        public async Task<IActionResult> GetSummary(int regionId, int year, CancellationToken cancellation)
        {
            //sorting_and_recycling_per_district

            using var command = clickHouse.CreateCommand();
            var query =
                @$"select 
                    dictGet('districts', 'name', district_id) as name,
                    sum(sorting_sites) as sorting_sites,
                    sum(sorting_capacity) as sorting_capacity,
                    sum(sorting_processed) as sorting_processed,
                    sum(sorting_collected) as sorting_collected,
                    sum(sorting_dumped) as sorting_dumped,
                    sum(recycling_sites) as recycling_sites,
                    sum(recycling_capacity) as recycling_capacity,
                    sum(recycling_processed) as recycling_processed,
                    sum(recycling_collected) as recycling_collected,
                    sum(recycling_dumped) as recycling_dumped
                        from sanitation_of_settlements.waste_processing 
                        where year = {year} AND region_id = {regionId}
                        group by year, region_id, district_id
                        FORMAT JSON";

            command.CommandText = query;

            var result = await command.ExecuteRawResultAsync(cancellation);
            using var stream = await result.ReadAsStreamAsync();
            using var reader = new StreamReader(stream);
            var json = reader.ReadToEnd();

            return Content(json, "application/json");
        }

        [HttpGet]
        public async Task GenerateMock(CancellationToken cancellation)
        {
            var organizations = await postgres.Organizations.ToArrayAsync(cancellation);
            var regions = await postgres.Regions.ToArrayAsync(cancellation);
            var districts = await postgres.Districts.ToArrayAsync(cancellation);

            var processed = new List<string>();

            var rand = new Random();
            for(int i = 0;  i < 100; i++)
            {
                var org = organizations[rand.Next(0, organizations.Length)];
                var region = regions[rand.Next(0, regions.Length)];
                var district = districts[rand.Next(0, districts.Length)];

                var key = $"{org.Id}{region.Id}{district.Id}";

                if(processed.Any(x => x == key))
                {
                    continue;
                }
                processed.Add(key);

                var values = new float[20];
                for(int j = 0; j < 20; j++)
                {
                    values[j] = rand.Next(1, 10) + rand.NextSingle();
                }

                await AddFulfilment(new SanitationEntity
                {
                    Id = 0,
                    DistrictId = district.Id,
                    RegionId = region.Id,
                    SourceId = org.Id,
                    Year = 2025,
                    Values = values
                }, new CancellationToken());
            }
        }
    }
}
