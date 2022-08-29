CREATE TABLE IF NOT EXISTS dim_admin_division_code
    (
        `id` bigint COMMENT '自增ID'                ,
        `type_code` STRING COMMENT '区域代码'                ,
        `admin_name` STRING COMMENT '区域名称'                  ,
        `short_name` STRING COMMENT '区域简称'              ,
        `series` STRING COMMENT '级数'             ,
        `zip_code` STRING COMMENT '邮编'             ,
        `last_update_time` bigint COMMENT '最后更新时间',
        `row_update_time` STRING COMMENT '数据库行更新时间',
        `CityCode` STRING COMMENT '区号',
        `mca_code` STRING COMMENT '对应民政部区域码',
        `nbs_code` STRING COMMENT '对应统计局区域码',
        `is_history` STRING COMMENT '是否是历史数据'
    )
COMMENT '行政区域代码表' STORED
AS ORC;


insert overwrite table dim_admin_division_code
select
id,
type_code,
admin_name,
short_name,
series,
zip_code,
last_update_time,
row_update_time,
CityCode,
mca_code,
nbs_code,
is_history
from
db_qkgp.db_codet_admin_division_code
where length(trim(nvl(`type_code`,'')))>0 and length(trim(nvl(`admin_name`,'')))>0 and is_history !='1';