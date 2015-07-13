 SELECT b.year,
    x.state AS geo_id,
    b.degree_id,
    sum(b.total) AS total,
    sum(b.total_men) AS total_men,
    sum(b.total_women) AS total_women,
    sum(b.total_native) AS total_native,
    sum(b.total_native_men) AS total_native_men,
    sum(b.total_native_women) AS total_native_women,
    sum(b.total_asian) AS total_asian,
    sum(b.total_asian_men) AS total_asian_men,
    sum(b.total_asian_women) AS total_asian_women,
    sum(b.total_black) AS total_black,
    sum(b.total_black_men) AS total_black_men,
    sum(b.total_black_women) AS total_black_women,
    sum(b.total_hispanic) AS total_hispanic,
    sum(b.total_hispanic_men) AS total_hispanic_men,
    sum(b.total_hispanic_women) AS total_hispanic_women,
    sum(b.total_hawaiian) AS total_hawaiian,
    sum(b.total_hawaiian_men) AS total_hawaiian_men,
    sum(b.total_hawaiian_women) AS total_hawaiian_women,
    sum(b.total_white) AS total_white,
    sum(b.total_white_men) AS total_white_men,
    sum(b.total_white_women) AS total_white_women,
    sum(b.total_multi) AS total_multi,
    sum(b.total_multi_men) AS total_multi_men,
    sum(b.total_multi_women) AS total_multi_women,
    sum(b.total_unknown) AS total_unknown,
    sum(b.total_unknown_men) AS total_unknown_men,
    sum(b.total_unknown_women) AS total_unknown_women,
    sum(b.total_nonresident) AS total_nonresident,
    sum(b.total_nonresident_men) AS total_nonresident_men,
    sum(b.total_nonresident_women) AS total_nonresident_women
   FROM ipeds.grads_yucd b
     LEFT JOIN attrs.university x ON x.id = b.university_id
  GROUP BY b.year, x.state, b.degree_id;