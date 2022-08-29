create table if not exists dws_business_information(
eid string comment '企业eid',
credit_no string comment '社会信用代码',
org_no string comment '组织机构代码',
reg_no string comment '注册号',
`status` string comment '状态',
econ_kind string comment '企业类型',
start_date string comment '成立日期',
oper_name string comment '法定代表人',
term_start string comment '经营期限起始日期 YYYY-MM-DD',
term_end string comment '经营期限结束日期 YYYY-MM-DD',
regist_capi string comment '注册资本',
check_date string comment '核准日期 YYYY-MM-DD',
actual_capi string comment '实收资金',
insured_num bigint comment '在被投资公司的持股数',
belong_org string comment '实收资金',
reg_address string comment '企业工商地址',
latest_address string comment '企业最新地址',
scope string comment '经营范围',
industry_name string comment '行业名称',
industry_code string comment '行业代码',
telephones_origin string comment '联系电话',
all_emails string comment '企业邮箱',
web_url string comment '企业网址',
stock_name string comment '股东名称',
stock_type string comment '股东类型',
stock_percent string comment '股东出资比例',
should_capi_items string comment '认缴明细',
real_capi_items string comment '实缴明细',
job_title string comment '职位',
employees_name string comment '主要人员名称',
change_date string comment '企业变更日期',
change_item string comment '企业变更名称',
before_content string comment '企业变更前内容',
after_content string comment '企业变更后内容',
report_year string comment '年报日期',
partners string comment '年报股东信息',
invest_items string comment '年报投资信息',
report_reg_no string comment '注册号',
report_credit_no string comment '社会信用代码',
`report_name` string comment '企业名称',
report_telephone string comment '公司电话',
zip_code string comment '年报邮编',
report_address string comment '年报地址',
`report_email` string comment '年报邮箱',
if_equity string comment '是否发生股东股权转让',
report_status string comment '年报企业经营状态',
if_website string comment '是否有网站或网店',
if_invest string comment '企业是否有投资信息或购买其他公司股权',
collegues_num string comment '从业人数',
report_websites string comment '年报网站信息',
report_change_records string comment '年报变更记录',
report_total_equity string comment '资产总额',
serv_fare_income string comment '主营业务收入',
profit_reta string comment '所有者权益合计',
net_amount string comment '净利润',
sale_income string comment '销售总额',
tax_total string comment '纳税总额',
profit_total string comment '利润总额',
debit_amount string comment '负债总额',
report_date string comment '年报日期',
external_guarantees string comment '年报对外担保信息',
stock_changes string comment '年报股东变更',
update_records string comment '年报修改记录',
sub_eid string comment '分支机构eid',
sub_status string comment '分支机构企业状态',
sub_name string comment '分支机构名称',
sub_oper_name string comment '分支机构法人代表',
sub_start_date string comment '分支机构成立时间',
invest_eid string comment '被投资公司id',
invest_name string comment '被投资公司名称',
invest_status string comment '被投资公司状态',
invest_oper_name string comment '被投资公司法定代表人',
invest_regist_capi string comment '被投资公司注册资本',
should_capi_conv string comment '应缴额（转换为万元人民币的）',
invest_stock_percent string comment '股比',
invest_start_date string comment '被投资公司创立日期',
invest_admin_name string comment '区域名称',
invest_type_code string comment '区域代码',
invest_industry_name string comment '被投资行业名称',
invest_industry_code string comment '被投资行业代码',
stock_num string comment '在被投资公司的持股数',
should_capi string comment '数据源原始认缴额(单位未转换)'
)
comment '基本信息主题表'
STORED AS ORC;


with a as (select * from dim_enterprise),
    b as (select eid,status as sub_status,sub_eid,name as sub_name,oper_name as sub_oper_name,start_date as sub_start_date from
    dwd_branches),
    c as (select eid,change_date,change_item,before_content,after_content from dwd_change_records),
    d as (select t1.eid,t1.address as reg_address from (select eid,address, row_number() over(partition by eid order by
    `date` desc) as rn from dwd_address where source='s8') t1 where t1.rn=1),
    d1 as (select t1.eid,t1.latest_address from (select eid,address as latest_address, row_number() over(partition by
    eid order by `date` desc) as rn from dwd_address where length(trim(address)) > 0) t1 where t1.rn=1),
    e as (select eid,concat('[', concat_ws(',', collect_set(concat('{','"name":','"',name,'","value":','"',value,'","date":','"',date,'"}'))), ']') as all_emails from dwd_emails group by eid),
    f as (select eid,concat('[', concat_ws(',', collect_set(concat('{','"name":','"',name,'","value":','"',value,'",
    "date":','"',date,'"}'))), ']') as telephones_origin from dwd_telephones group by eid),
    g as (select t5.eid,t5.web_url from (select eid,web_url, row_number() over(partition by eid order by date desc) as
    rn from dwd_websites where source='s4') t5 where t5.rn=1),
    h as (select * from dws_partners),
    i as (select eid,job_title,`name` as employees_name from dwd_employees_alls),
    j as (select * from dwd_report_details),
    k as (select t1.eid,t1.`report_year`,t1.insured_num from (select eid,`report_year`, cast(substring(`yanglaobx_num`, 0, length(`yanglaobx_num`)-1) as int) as `insured_num`,row_number() over(partition by eid order by `report_year` desc) as rn from dwd_social_security where length(`yanglaobx_num`)>=2)t1 where rn=1),
    l as (select * from dwd_enterprise_investment)
insert overwrite table dws_business_information
select
a.eid,
a.credit_no,
a.org_no,
a.reg_no,
a.status,
a.econ_kind,
a.start_date,
a.oper_name,
a.term_start,
a.term_end,
a.regist_capi,
a.check_date,
a.actual_capi,
k.insured_num,
a.belong_org,
d.reg_address,
d1.latest_address,
a.scope,
a.industry_name,
a.industry_code,
f.telephones_origin,
e.all_emails,
g.web_url,
h.stock_name,
h.stock_type,
h.stock_percent,
h.should_capi_items,
h.real_capi_items,
i.job_title,
i.employees_name,
c.change_date,
c.change_item,
c.before_content,
c.after_content,
j.report_year,
'' as partners,
'' as invest_items,
j.reg_no,
j.credit_no,
j.`name`,
j.telephone,
j.zip_code,
j.address,
j.`email`,
j.if_equity,
j.status,
j.if_website,
j.if_invest,
j.collegues_num,
'' as websites,
'' as change_records,
j.total_equity,
j.serv_fare_income,
j.profit_reta,
j.net_amount,
j.sale_income,
j.tax_total,
j.profit_total,
j.debit_amount,
j.report_date,
'' as external_guarantees,
'' as stock_changes,
'' as update_records,
b.sub_eid,
b.sub_status,
b.sub_name,
b.sub_oper_name,
b.sub_start_date,
l.invest_eid,
l.invest_name,
l.invest_status,
l.invest_oper_name,
l.invest_regist_capi,
l.should_capi_conv,
l.stock_percent,
l.invest_start_date,
l.admin_name,
l.type_code,
l.industry_name,
l.industry_code,
l.stock_num,
l.should_capi
from a
left join b on a.eid=b.eid
left join c on a.eid=c.eid
left join d on a.eid=d.eid
left join d1 on a.eid=d1.eid
left join e on a.eid=e.eid
left join f on a.eid=f.eid
left join g on a.eid=g.eid
left join h on a.eid=h.eid
left join i on a.eid=i.eid
left join j on a.eid=j.eid
left join k on a.eid=k.eid
left join l on a.eid=l.eid;
