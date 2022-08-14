create table if not exists dwd_branches(
id bigint comment '自增id'
eid string comment '企业eid',
seq_no int comment '序号',
name string comment '分支机构名称',
sub_eid string comment '分支机构eid',
belong_org string comment '所属机构',
oper_name string comment '法人代表',
source string comment '来源',
reg_no string comment '注册号',
row_update_time string comment 'db记录变更时间'
)
comment '企业分支机构'
STORED AS ORC;