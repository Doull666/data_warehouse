--一个企业可能有多个地址
CREATE TABLE IF NOT EXISTS dwd_address
    (
        `id` bigint COMMENT '自增id'                 ,
        `eid` STRING COMMENT '企业id'                ,
        `seq_no` int COMMENT '序号'                  ,
        `address` STRING COMMENT '地址'              ,
        `name` STRING COMMENT '地址获取描述'             ,
        `postcode` STRING COMMENT '邮编'             ,
        `date` STRING COMMENT '获取日期'               ,
        `source` STRING COMMENT '地址获取来源'           ,
        `check_date` STRING COMMENT '核准日期'         ,
        `update_date` STRING COMMENT '更新日期'        ,
        `row_update_time` STRING COMMENT 'db记录变更时间',
        `address_code` STRING COMMENT '地址区域代码'     ,
        `u_tags` STRING COMMENT '隐藏标记'
    )
COMMENT '企业地址' STORED
AS ORC;


insert overwrite table dwd_address
select
`id`,
`eid`,
`seq_no`,
regexp_replace(`address`,'[,\\"\\s]','') as `address`,
`name`,
`postcode`,
`date`,
`source`,
`check_date`,
`update_date`,
`row_update_time`,
`address_code`,
`u_tags`
from
db_qkgp.db_enterpriset_address
where length(trim(nvl(`eid`,'')))>0 and `u_tags` != '2' and length(trim(nvl(`address`,'')))>0;