create table if not exists dws_partners(
eid string comment '企业eid',
stock_id string comment '股东id',
stock_name string comment '股东名称',
stock_type string comment '股东类型',
`type` string comment '企业类型',
stock_percent string comment '股比',
should_capi_items string comment '认缴明细',
real_capi_items string comment '实缴明细',
country string comment '国家地区'
)
comment 'dws 股东表'
STORED AS ORC;



-- 对股东信息做一些简单的聚合，以供 企业基本信息-股东信息使用
with a as (select eid,stock_id,stock_name,stock_type,case when length(stock_id)=36 and length(stock_name)>3 then 'E' else
                 nhsebd.classify_type(stock_name) end as type,stock_percent,should_capi_items,real_capi_items,country
                 from dwd_partners ),
      b as (select eid,case when type='E' then stock_id
                            when type='P' or type='U' then md5(concat(eid, stock_name, type))
                       else md5(concat(stock_name, type)) end as stock_id,stock_name,stock_type,type,stock_percent,
                       should_capi_items,real_capi_items,country from a),
      c as (select eid,case when t.uid_mapped is null then b.stock_id else t.uid_mapped end as stock_id,stock_name,
      stock_type,type,stock_percent,should_capi_items,real_capi_items,country from b left join dim_mapping_person t on b
      .stock_id = t.uid),
      d as (select eid,stock_id,stock_name,stock_type,type,stock_percent,should_capi_items,real_capi_items,country from
      (select eid,stock_id,stock_name,stock_type,type,stock_percent,should_capi_items,real_capi_items,country,row_number
      () over(partition by eid order by stock_percent desc) as rn from c)t where t.rn=1)
insert overwrite table dws_partners
select
eid,
stock_id,
stock_name,
stock_type,
type,
stock_percent,
should_capi_items,
real_capi_items,
country
from d;
