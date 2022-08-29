--一个企业可能多个网址
CREATE TABLE IF NOT EXISTS dwd_websites
    (
        `id` STRING COMMENT '自增id' ,
        `eid` STRING COMMENT '企业id' ,
        `seq_no` int COMMENT '序号'                              ,
        `web_type` STRING COMMENT '网址类型'                       ,
        `web_name` STRING COMMENT '网址名称'                       ,
        `web_url` STRING COMMENT '网址'                          ,
        `report_year` STRING COMMENT '年报年份'                    ,
        `is_official` int COMMENT '是否为官网 0：否，1：是'              ,
        `source` STRING COMMENT '来源'                           ,
        `date` STRING COMMENT '获取日期'                           ,
        `tags` STRING COMMENT '隐藏标记'                              ,
        `row_update_time` STRING COMMENT 'db记录变更时间'
    )
COMMENT '企业网址' STORED
AS ORC;


insert overwrite table dwd_websites
select
`id`,
`eid`,
`seq_no`,
`web_type`,
`web_name`,
`web_url`,
'' as `report_year`,
'' as `is_official`,
`source`,
`date`,
`tags`,
`row_update_time`
from
db_qkgp.db_enterpriset_websites
where length(trim(nvl(`eid`,'')))>0 and `tags` != '2';