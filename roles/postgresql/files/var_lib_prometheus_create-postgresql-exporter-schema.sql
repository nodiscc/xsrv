CREATE SCHEMA prometheus AUTHORIZATION prometheus;

CREATE FUNCTION prometheus.f_select_pg_stat_activity()
RETURNS setof pg_catalog.pg_stat_activity
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT * from pg_catalog.pg_stat_activity;
$$;

CREATE FUNCTION prometheus.f_select_pg_stat_replication()
RETURNS setof pg_catalog.pg_stat_replication
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT * from pg_catalog.pg_stat_replication;
$$;

CREATE VIEW prometheus.pg_stat_replication
AS
  SELECT * FROM prometheus.f_select_pg_stat_replication();

CREATE VIEW prometheus.pg_stat_activity
AS
  SELECT * FROM prometheus.f_select_pg_stat_activity();

GRANT SELECT ON prometheus.pg_stat_replication TO prometheus;
GRANT SELECT ON prometheus.pg_stat_activity TO prometheus;
