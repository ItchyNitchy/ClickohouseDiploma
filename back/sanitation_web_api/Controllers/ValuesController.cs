using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using sanitation_web_api.domain;
using sanitation_web_api.helpers;

namespace sanitation_web_api.Controllers
{
    [Route("api/[controller]/[method]")]
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

        public async Task<DictionaryDto[]> GetDictitonary(int type, CancellationToken cancellation) => type switch
        {
            1 => await postgres.Organizations.ToArrayAsync(cancellation),
            2 => await postgres.Regions.ToArrayAsync(cancellation),
            3 => await postgres.Districts.ToArrayAsync(cancellation),
            _ => []
        };
    }
}
