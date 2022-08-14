--一个企业可能多个邮箱
CREATE TABLE IF NOT EXISTS nhsebd.dwd_websites
(
`id`         STRING COMMENT '自增id'
    `eid`         STRING COMMENT '企业id' ,
    `seq_no`     int COMMENT '序号' ,
    `name` STRING COMMENT '邮箱获取描述' ,
    `value` STRING COMMENT '公司邮箱' ,
    `date`       STRING COMMENT '获取日期' ,
    `source`     STRING COMMENT '来源',
    `row_update_time`     STRING COMMENT '变更时间',
    `u_tags`     STRING COMMENT '隐藏标识'
)
    COMMENT '企业邮箱'
    STORED AS ORC;