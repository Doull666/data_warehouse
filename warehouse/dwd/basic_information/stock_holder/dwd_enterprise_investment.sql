--一家企业可能有多条工商变更
CREATE TABLE IF NOT EXISTS dwd_enterprise_investment
    (
        `id` STRING COMMENT '自增序号'                         ,
        `eid` STRING COMMENT '企业eid'                       ,
        `name` string COMMENT '公司名称'                       ,
        `invest_eid` STRING COMMENT '被投资公司id'              ,
        `stock_percent` STRING COMMENT '股比'                ,
        `should_capi_conv` STRING COMMENT '应缴额（转换为万元人民币的）' ,
        `invest_name` STRING COMMENT '被投资公司名称'             ,
        `invest_credit_no` string COMMENT '被投资公司统一社会信用代码'  ,
        `invest_reg_no` int COMMENT '被投资公司注册号'             ,
        `invest_status` STRING COMMENT '被投资公司状态'           ,
        `invest_oper_name` STRING COMMENT '被投资公司法定代表人'     ,
        `invest_regist_capi` STRING COMMENT '被投资公司注册资本'    ,
        `invest_start_date` STRING COMMENT '被投资公司创立日期'     ,
        `belong_org` STRING COMMENT '被投资公司登记机关'            ,
        `belong_org_code` STRING COMMENT '被投资公司登记机关区域'     ,
        `stock_num`           bigint COMMENT '在被投资公司的持股数'            ,
        `invest_quote_status` int COMMENT '被投资公司上市状态'                ,
        `should_capi` STRING COMMENT '数据源原始认缴额(单位未转换)'               ,
        `currency_code` STRING COMMENT '货币代码'                        ,
        `real_capi` STRING COMMENT '实缴额'                             ,
        `should_con_date` STRING COMMENT '应缴出资日期'                    ,
        `create_time` STRING COMMENT '创建时间'                          ,
        `is_history` STRING COMMENT '是否历史'                           ,
        `row_update_time` STRING COMMENT '数据库行更新时间（自动）',
        `invest_oper_id` STRING COMMENT '被投资股东id',
        `invest_oper_type` STRING COMMENT '被投资股东类型',
        `admin_name` STRING COMMENT '区域名称',
        `type_code` STRING COMMENT '区域代码',
        `industry_name` STRING COMMENT '行业名称',
        `industry_code` STRING COMMENT '行业代码'
    )
COMMENT '企业对外投资' STORED
AS ORC;


with a as (select
a.id,
a.eid,
a.name,
a.invest_eid,
a.stock_percent,
a.should_capi_conv,
a.invest_name,
a.invest_credit_no,
a.invest_reg_no,
a.invest_status,
a.invest_oper_name,
a.invest_regist_capi,
a.invest_start_date,
a.belong_org,
a.belong_org_code,
a.stock_num,
a.invest_quote_status,
a.should_capi,
a.currency_code,
a.real_capi,
a.should_con_date,
a.create_time,
a.is_history,
a.row_update_time,
case when length(d.name)>3 then d.eid else '' end as invest_oper_id,
'E' as invest_oper_type,
'' as admin_name,
b.district_code as type_code,
'' as industry_name,
'' as industry_code
from db_qkgp.db_sub_enterprisest_enterprise_investment a
left join dim_enterprise b on a.eid=b.eid
left join dim_nameeidlookup d on a.invest_oper_name = d.name
where length(trim(nvl(a.`eid`,'')))>0 and length(trim(nvl(a.`invest_eid`,'')))>0
),
b as (select
a.id,
eid,
name,
invest_eid,
stock_percent,
should_capi_conv,
invest_name,
invest_credit_no,
invest_reg_no,
invest_status,
invest_oper_name,
invest_regist_capi,
invest_start_date,
belong_org,
belong_org_code,
stock_num,
invest_quote_status,
should_capi,
currency_code,
real_capi,
should_con_date,
create_time,
a.is_history,
a.row_update_time,
invest_oper_id,
case when length(invest_oper_id)=36 and length(invest_oper_name)>3 then 'E' else  nhsebd.classify_type(invest_oper_name)
 end as invest_oper_type,
t.admin_name as admin_name,
a.type_code,
industry_name,
industry_code
from
a
left join dim_admin_division_code t on a.type_code = t.type_code and t.series = '1'
),
c as (select
id,
eid,
name,
invest_eid,
stock_percent,
should_capi_conv,
invest_name,
invest_credit_no,
invest_reg_no,
invest_status,
invest_oper_name,
invest_regist_capi,
invest_start_date,
belong_org,
belong_org_code,
stock_num,
invest_quote_status,
should_capi,
currency_code,
real_capi,
should_con_date,
create_time,
is_history,
row_update_time,
case when invest_oper_type='E' then invest_oper_id
     when invest_oper_type='P' or invest_oper_type='U' then md5(concat(invest_eid, invest_oper_name, invest_oper_type))
     else md5(concat(invest_oper_name, invest_oper_type))
end as invest_oper_id,
invest_oper_type,
admin_name,
type_code,
industry_name,
industry_code
from
b)
insert overwrite table dwd_enterprise_investment
select
id,
eid,
name,
invest_eid,
stock_percent,
should_capi_conv,
invest_name,
invest_credit_no,
invest_reg_no,
invest_status,
invest_oper_name,
invest_regist_capi,
invest_start_date,
belong_org,
belong_org_code,
stock_num,
invest_quote_status,
should_capi,
currency_code,
real_capi,
should_con_date,
create_time,
is_history,
row_update_time,
case when d.uid_mapped is null then c.invest_oper_id else d.uid_mapped end as invest_oper_id,
invest_oper_type,
admin_name,
type_code,
industry_name,
industry_code
from
c
left join dim_mapping_person d
on c.invest_oper_id = d.uid;