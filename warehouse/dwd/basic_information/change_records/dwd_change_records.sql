--一家企业可能有多条工商变更
CREATE TABLE IF NOT EXISTS dwd_change_records
    (
        `id` bigint COMMENT '自增序号'              ,
        `u_id` STRING COMMENT '唯一键'             ,
        `eid` STRING COMMENT '企业eid'            ,
        `after_content` STRING COMMENT '变更后内容'  ,
        `before_content` STRING COMMENT '变更前内容' ,
        `change_date` STRING COMMENT '变更日期'     ,
        `change_item` STRING COMMENT '变更名称'     ,
        `type` string COMMENT '变更分类'            ,
        `u_tags` STRING COMMENT '隐藏标记'             ,
        `row_update_time` STRING COMMENT 'db记录变更时间'
    )
COMMENT '企业变更记录' STORED
AS ORC;


insert overwrite table dwd_change_records
select
`id`,
`u_id`,
`eid`,
`after_content`,
`before_content`,
if(regexp(`change_date`,'^[1|2][0-9]{3}') and substr(`change_date`,1,4) < 2030,`change_date`,'0000-00-00') as `change_date`,
`change_item`,
`type`,
`u_tags`,
`row_update_time`
from
db_qkgp.db_enterpriset_change_records
where length(trim(nvl(`eid`,'')))>0 and `u_tags` != '2';