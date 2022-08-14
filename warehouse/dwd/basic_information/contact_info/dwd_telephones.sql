--一个企业可能多个电话
CREATE TABLE IF NOT EXISTS nhsebd.dwd_telephones
(
`id`         STRING COMMENT '自增id'
    `eid`         STRING COMMENT '企业id' ,
    `seq_no`     int COMMENT '序号' ,
    `name` STRING COMMENT '电话获取描述' ,
    `value` STRING COMMENT '公司电话' ,
    `date`       STRING COMMENT '获取日期' ,
    `source`     STRING COMMENT '来源',
    `row_update_time`     STRING COMMENT 'db记录变更时间',
    `u_tags`     STRING COMMENT '隐藏标识'
)
    COMMENT '企业电话'
    STORED AS ORC;