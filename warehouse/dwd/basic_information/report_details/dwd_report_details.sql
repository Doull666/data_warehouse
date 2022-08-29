--一家企业可能有多条工商变更
CREATE TABLE IF NOT EXISTS dwd_report_details
    (
        `eid` STRING COMMENT '企业eid'                          ,
        `report_year` STRING COMMENT '年报年份'                   ,
        `reg_no` STRING COMMENT '注册号'                         ,
        `credit_no` string COMMENT '社会信用代码'                   ,
        `name` STRING COMMENT '企业名称'                          ,
        `report_name` STRING COMMENT '年报名称'                   ,
        `report_date` STRING COMMENT '年报日期'                   ,
        `net_amount` STRING COMMENT '净利润'                     ,
        `debit_amount` string COMMENT '负债总额'                  ,
        `telephone` string COMMENT '公司电话'                     ,
        `email` STRING COMMENT '公司电子邮箱'                       ,
        `sale_income` STRING COMMENT '销售总额'                   ,
        `profit_total` STRING COMMENT '利润总额'                  ,
        `profit_reta` STRING COMMENT '所有者权益合计'                ,
        `tax_total` STRING COMMENT '纳税总额'                     ,
        `total_equity` STRING COMMENT '资产总额'                  ,
        `address` STRING COMMENT '地址'                         ,
        `fare_scope` STRING COMMENT '主营业务'                    ,
        `oper_name` STRING COMMENT '法定代表人'                    ,
        `zip_code` STRING COMMENT '邮编'                        ,
        `serv_fare_income` STRING COMMENT '主营业务收入'            ,
        `reg_capi` STRING COMMENT '注册资本'                      ,
        `indiv_form_mode` STRING COMMENT '江苏地方年报中的法定代表人字段'    ,
        `collegues_num` STRING COMMENT '从业人数'                 ,
        `if_website` STRING COMMENT '是否有网站或网店'                ,
        `if_invest` STRING COMMENT '企业是否有投资信息或购买其他公司股权'       ,
        `if_external_guarantee` STRING COMMENT '是否提供对外担保'     ,
        `if_equity` STRING COMMENT '是否发生股东股权转让'               ,
        `create_date` STRING COMMENT '创建时间'                   ,
        `status` STRING COMMENT '企业经营状态'                      ,
        `female_collegues_num` STRING COMMENT '其中女性从业人数'      ,
        `enterprise_holding_situation` STRING COMMENT '企业控股情况',
        `row_update_time` STRING COMMENT 'db记录变更时间'           ,
        `sup_ename` STRING COMMENT '隶属企业名称'                   ,
        `sup_credit_no` STRING COMMENT '隶属企业统一社会信用代'          ,
        `sup_eid` STRING COMMENT '隶属企业eid'
    )
COMMENT '企业年报' STORED
AS ORC;

insert overwrite table dwd_report_details
select
`eid`,
if(regexp(`report_year`,'^[1|2][0-9]{3}') and substr(`report_year`,1,4) < 2030,`report_year`,'0000') as `report_year`,
`reg_no`,
`credit_no`,
`name`,
`report_name`,
`report_date`,
`net_amount`,
`debit_amount`,
`telephone`,
`email`,
`sale_income`,
`profit_total`,
`profit_reta`,
`tax_total`,
`total_equity`,
`address`,
`fare_scope`,
`oper_name`,
`zip_code`,
`serv_fare_income`,
`reg_capi`,
`indiv_form_mode`,
`collegues_num`,
`if_website`,
`if_invest`,
`if_external_guarantee`,
`if_equity`,
`create_date`,
`status`,
`female_collegues_num`,
`enterprise_holding_situation`,
`row_update_time`,
`sup_ename`,
`sup_credit_no`,
`sup_eid`
from
db_qkgp.db_enterprise_reportst_report_details
where length(trim(nvl(`eid`,'')))>0 and length(trim(nvl(`report_year`,'')))>0;