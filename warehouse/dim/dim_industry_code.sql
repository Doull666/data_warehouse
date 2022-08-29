CREATE TABLE IF NOT EXISTS dim_industry_code
    (
        `id` bigint COMMENT '自增ID'                ,
        `industry_code` STRING COMMENT '行业代码'                ,
        `industry_name` int COMMENT '行业名称'                  ,
        `series` STRING COMMENT '级数'              ,
        `industry_standard` STRING COMMENT '分类标准'             ,
        `last_update_time` bigint COMMENT '最后更新时间'             ,
        `row_update_time` STRING COMMENT '数据库行更新时间'
    )
COMMENT '行业代码配置表' STORED
AS ORC;

with a as (select *,row_number() over(partition by industry_code order by series) rn from db_qkgp.db_codet_industry_code)
insert overwrite table dim_industry_code
select
id,
industry_code,
industry_name,
series,
industry_standard,
last_update_time,
row_update_time
from
a
where length(trim(nvl(`industry_code`,'')))>0 and length(trim(nvl(`industry_name`,'')))>0 and rn=1;