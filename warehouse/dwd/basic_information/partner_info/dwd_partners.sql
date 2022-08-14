CREATE TABLE IF NOT EXISTS nhsebd.dwd_partners
(
`id`         bigint COMMENT '自增主键'
    `eid`         STRING COMMENT '企业eid' ,
    `seq_no`     int COMMENT '序号' ,
    `stock_name` STRING COMMENT '股东名称' ,
    `stock_id` STRING COMMENT '股东eid' ,
    `stock_type`       STRING COMMENT '股东类型' ,
    `stock_type_code`     STRING COMMENT '股东类型代码',
    `stock_percent`     STRING COMMENT '股东出资比例',
    `country`     STRING COMMENT '国家,地区',
    `country_code`     STRING COMMENT '国家,地区代码',
    `identify_type`     STRING COMMENT '证件类型',
    `total_real_capi`     STRING COMMENT '股东总实缴',
    `total_real_capi_new`     STRING COMMENT '股东总实缴金额',
    `real_currency_unit`     STRING COMMENT '股东总实缴币种',
    `total_should_capi`     STRING COMMENT '股东总认缴',
    `total_should_capi_new`     STRING COMMENT '股东总认缴金额',
    `should_currency_unit`     STRING COMMENT '股东总认缴币种',
    `should_capi_items`     STRING COMMENT '认缴明细',
    `real_capi_items`     STRING COMMENT '实缴明细',
    `entity_type`     STRING COMMENT '股东类别',
    `end_date`     STRING COMMENT '股东退出时间',
    `is_history`     int COMMENT '是否历史股东',
    `end_is_actual`     int COMMENT '退出时间是否是实际变更时间',
    `start_date`     STRING COMMENT '开始参股时间',
    `start_is_actual`     int COMMENT '开始参股时间是否是实际变更时间',
    `source`     STRING COMMENT '来源',
    `create_time`     bitint COMMENT '创建时间',
    `row_update_time`     STRING COMMENT 'db记录变更时间',
    `raw_stock_name`     STRING COMMENT '原始股东名'
)
    COMMENT '股东（含历史）'
    STORED AS ORC;