create table if not exists dwd_branches(
id bigint comment '自增id',
eid string comment '企业eid',
seq_no int comment '序号',
name string comment '分支机构名称',
sub_eid string comment '分支机构eid',
belong_org string comment '所属机构',
oper_name string comment '法人代表',
source string comment '来源',
reg_no string comment '注册号',
row_update_time string comment 'db记录变更时间',
status string comment '分支机构企业状态',
start_date string comment '分支机构成立时间'
)
comment '企业分支机构'
STORED AS ORC;


insert overwrite table dwd_branches
select
a.id,
a.eid,
seq_no,
regexp_replace(a.name,'[,\\"\\s]','') as name,
case when b.eid is not null then b.eid else a.sub_eid end as sub_eid,
a.belong_org,
regexp_replace(a.oper_name,'[,\\"\\s]','') as oper_name,
a.source,
a.reg_no,
a.row_update_time,
c.status,
if(regexp(c.start_date,'^[1|2][0-9]{3}') and substr(c.start_date,1,4) < 2030,c.start_date,'0000-00-00') as start_date
from
db_qkgp.db_enterpriset_branches a
left join dim_nameeidlookup b
on a.name = b.name
left join dim_enterprise c
on a.sub_eid=c.eid
where length(trim(nvl(a.eid,'')))>0 and length(trim(nvl(sub_eid,'')))>0;