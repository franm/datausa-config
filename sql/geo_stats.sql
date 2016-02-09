-- state stats
SELECT ( SELECT max(yg.year) AS max
          FROM acs_1yr.yg) AS year,
   a.id AS geo,
   ( SELECT tmp.pos
          FROM ( SELECT yg.geo,
                   yg.pop,
                   rank() OVER (PARTITION BY "left"(yg.geo, 3) ORDER BY yg.pop DESC) AS pos
                  FROM acs_1yr.yg
                 WHERE yg.year = (( SELECT max(yg_1.year) AS max
                          FROM acs_1yr.yg yg_1)) AND yg.geo LIKE '040%') tmp
         WHERE tmp.geo = a.id::text) AS state_rank,
   ARRAY( SELECT yg.geo
          FROM acs_1yr.yg
         WHERE yg.year = (( SELECT max(yg_1.year) AS max
                  FROM acs_1yr.yg yg_1)) AND (yg.geo IN ( SELECT geo_containment.child_geoid
                  FROM attrs.geo_containment
                 WHERE geo_containment.child_geoid LIKE '16000' || substr(a.id, 6 ,4) || '%'  ))
         ORDER BY yg.pop DESC
        LIMIT 3) AS top_places,
        ARRAY( SELECT yg.geo
               FROM acs_1yr.yg
              WHERE yg.year = (( SELECT max(yg_1.year) AS max
                       FROM acs_1yr.yg yg_1)) AND (yg.geo IN ( SELECT geo_containment.child_geoid
                       FROM attrs.geo_containment
                      WHERE geo_containment.child_geoid LIKE '05000' || substr(a.id, 6 ,4) || '%'  ))
              ORDER BY yg.pop DESC
             LIMIT 3) AS top_counties,
   ARRAY( SELECT geo_neighbors.neighbor
          FROM attrs.geo_neighbors
         WHERE geo_neighbors.geo = a.id::text) AS state_neighbors
  FROM attrs.geo_names a
 WHERE a.id::text ~~ '04000US%'::text;

-- msa stats
CREATE TABLE stats.msa AS (SELECT a.id AS geo,
   ARRAY( SELECT yg.geo
          FROM acs.yg
         WHERE (yg.geo IN ( SELECT geo_containment.child_geoid
                  FROM attrs.geo_containment
                 WHERE geo_containment.parent_geoid = a.id::text AND geo_containment.child_geoid ~~ '050%'::text)) and year = 2013
         ORDER BY yg.pop DESC
        LIMIT 3) AS top_counties,
   ARRAY( SELECT yg.geo
          FROM acs.yg
         WHERE (yg.geo IN ( SELECT geo_containment.child_geoid
                  FROM attrs.geo_containment
                 WHERE geo_containment.parent_geoid = a.id::text AND geo_containment.child_geoid ~~ '160%'::text) and year = 2013 )
         ORDER BY yg.pop DESC
        LIMIT 3) AS top_places
  FROM attrs.geo_names a
 WHERE a.id::text ~~ '310%'::text)

-- county stats
CREATE TABLE stats.counties AS (SELECT
a.id as geo,
(SELECT pos
	FROM
	(SELECT geo, pop, rank()
		 OVER (PARTITION BY LEFT(geo, 3) ORDER BY pop DESC) AS 	pos FROM acs.yg
	WHERE geo like '05000' ||SUBSTR(a.id, 6, 4) || '%') as tmp
	WHERE geo = a.id) as stat_1,
(SELECT count(child_geoid) from attrs.geo_containment where parent_geoid = a.id and child_geoid LIKE '160%') as stat_2,
ARRAY(SELECT geo
FROM acs.yg WHERE geo in
(SELECT child_geoid from attrs.geo_containment where parent_geoid = a.id and child_geoid LIKE '160%')
ORDER BY pop desc
LIMIT 3) as stat_3,
ARRAY(SELECT neighbor from attrs.geo_neighbors where geo = a.id) as stat_4
FROM attrs.geo_names a
WHERE id LIKE '05000US%')
