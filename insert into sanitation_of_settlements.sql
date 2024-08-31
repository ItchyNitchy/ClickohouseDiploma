insert into sanitation_of_settlements.motor_vehicle_availability (version, sign, values, year, source_id, district_id, region_id)
values (1, 1, [[1,2],[3,4],[5,6]], 2024, 10, 1, 1);

SELECT id, sumArrayForEach(units) units
FROM (
  /* emulate dataset */
  SELECT data.1 id, data.2 units
  FROM (
    SELECT arrayJoin([(1, [[1,2],[3,4],[5,6]]), (2, [[1,2],[3,4],[5,6]]), (1, [[1,2],[3,4],[5,6]]), (3, [[1,2],[3,4],[5,6]]), (2, [[1,2],[3,4],[5,6]])]) data))
GROUP BY id
