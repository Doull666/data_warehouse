create table if not exists dim_nameeidlookup(
eid string comment '企业id',
name string comment '企业名称'
)
comment '企业名称和id映射表'
STORED AS ORC;


insert overwrite table dim_nameeidlookup
select
eid,
name
from db_qkgp.ads_hive_nameeidlookup;