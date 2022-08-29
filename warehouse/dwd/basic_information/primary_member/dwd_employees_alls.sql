--一个企业可能有多个主要人员
CREATE TABLE IF NOT EXISTS dwd_employees_alls
    (
        `id` STRING COMMENT '自增序号' ,
        `eid` STRING COMMENT '企业eid' ,
        `job_title` STRING COMMENT '职位'                            ,
        `job_title_analy` STRING COMMENT '解析职位'                 ,
        `name` STRING COMMENT '名称'                              ,
        `name_type` STRING COMMENT '人员类型'                       ,
        `name_pid` STRING COMMENT 'pid/eid'                     ,
        `sex`        int COMMENT '性别'                                  ,
        `is_history` STRING COMMENT '是否历史主要人员'                            ,
        `end_date` STRING COMMENT '退出时间'                               ,
        `is_actual` STRING COMMENT '退出时间是否是实际变更时间'                     ,
        `create_time` bigint COMMENT '创建时间'                            ,
        `row_update_time` STRING COMMENT 'db记录变更时间'                    ,
        `start_date` STRING COMMENT '开始任职时间'                           ,
        `start_is_actual` STRING COMMENT '任职时间是否是实际变更时间'
    )
COMMENT '主要人员工商公示表' STORED
AS ORC;


insert overwrite table dwd_employees_alls
select
`id`,
`eid`,
regexp_replace(`job_title`, '[,\\"\\s]', '') as `job_title`,
`job_title_analy`,
regexp_replace(`name`, '[,\\"\\s]', '') as `name`,
`name_type`,
`name_pid`,
`sex`,
`is_history`,
`end_date`,
`is_actual`,
`create_time`,
`row_update_time`,
`start_date`,
`start_is_actual`
from
db_qkgp.db_enterpriset_employees_alls
where length(trim(nvl(`eid`,'')))>0 and `is_history` != '2';