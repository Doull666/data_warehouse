-- 关联 db_sub_enterprisest_last_industry（企业最新行业信息表） 以及 db_codet_industry_code （行业代码配置表） 将企业行业属性维度退化至企业事实表中
-- 因为行业信息的使用基本上都会关联到企业，无单独使用的其他场景

CREATE TABLE IF NOT EXISTS dim_enterprise
    (
        `eid` STRING COMMENT '企业id'                      ,
        `id` bigint COMMENT '自增序号（非主键）'                  ,
        `reg_no` STRING COMMENT '注册号'                    ,
        `credit_no` STRING COMMENT '社会信用代码'              ,
        `org_no` STRING COMMENT '组织机构代码'                 ,
        `name` STRING COMMENT '公司名称'                     ,
        `format_name` STRING COMMENT '标准名称'              ,
        `econ_kind` STRING COMMENT '企业类型'                ,
        `regist_capi` STRING COMMENT '注册资本'              ,
        `actual_capi` STRING COMMENT '实收资金'              ,
        `scope` STRING COMMENT '经营范围'                    ,
        `term_start` STRING COMMENT '经营期限起始日期 YYYY-MM-DD',
        `term_end` STRING COMMENT '经营期限结束日期 YYYY-MM-DD'  ,
        `check_date` STRING COMMENT '核准日期 YYYY-MM-DD'    ,
        `belong_org` STRING COMMENT '登记机关'               ,
        `oper_name` STRING COMMENT '法定代表人'               ,
        `oper_type` STRING COMMENT '法定代表人类型'             ,
        `start_date` STRING COMMENT '成立日期'               ,
        `status` STRING COMMENT '状态'                     ,
        `type_desc` STRING COMMENT '组织形式'                ,
        `title` STRING COMMENT '公司代表人职务'                 ,
        `longitude` double COMMENT '百度经度'                ,
        `latitude` double COMMENT '百度纬度'                 ,
        `gd_longitude` double COMMENT '高德经度'             ,
        `gd_latitude` double COMMENT '高德纬度'              ,
        `collegues_num` STRING COMMENT '从业人数'            ,
        `created_time` bigint COMMENT '创建时间'             ,
        `logo_url` STRING COMMENT '公司logo'               ,
        `url` STRING COMMENT '工商快照信息url'                 ,
        `row_update_time` STRING COMMENT '变更时间'          ,
        `district_code` STRING COMMENT '最优区域码'           ,
        `title_code` STRING COMMENT '代表人类型代码'            ,
        `econ_kind_code` STRING COMMENT '企业类型代码'         ,
        `regist_capi_new` STRING COMMENT '注册资本(新)'       ,
        `currency_unit` STRING COMMENT '货币单位'            ,
        `revoke_reason` STRING COMMENT '吊销原因'            ,
        `revoke_date` STRING COMMENT '吊销日期'              ,
        `logout_reason` STRING COMMENT '注销原因'            ,
        `logout_date` STRING COMMENT '注销日期'              ,
        `revoked_certificates` STRING COMMENT '吊销凭证'     ,
        `new_status_code` STRING COMMENT '企业状态码'         ,
        `u_tags` STRING COMMENT '是否隐藏'                   ,
        `organization_code` STRING COMMENT '组织分类代码'      ,
        `industry_code` STRING COMMENT '行业代码'            ,
        `industry_name` STRING COMMENT '行业名称'            ,
        `series` STRING COMMENT '行业分级'                   ,
        `industry_standard` STRING COMMENT '行业分类标准'
    )
COMMENT '企业基本信息表' STORED
AS ORC;



with a as (select a.eid,b.industry_code,b.industry_name,b.series,b.industry_standard from
db_qkgp.db_sub_enterprisest_last_industry a left join dim_industry_code b on a.industry_code=b
.industry_code where length(trim(nvl(a.eid,'')))>0 and length(trim(nvl(b.industry_code,'')))>0)
insert overwrite table dim_enterprise
select
t.eid,
id,
reg_no,
credit_no,
org_no,
regexp_replace(name,'[,\\"\\s]','') as name,
regexp_replace(format_name,'[,\\"\\s]','') as format_name,
concat_ws('\u0002',
            if(econ_kind_code IN ( "1110" , "1140" , "1213" , "1223" , "3100" , "4110" , "4210" , "4410" ),'国有企业',null),
            if(econ_kind_code IN ( "3200" , "4120" , "4220" , "4420" ),'集体企业',null),
            if(econ_kind_code IN ("3400"),'股份合作企业',null),
            if(econ_kind_code IN ( "3500" , "4600" ),'联营企业',null),
            if(econ_kind_code IN
                 ( '1100' , '1110' , '1120' , '1121' , '1122' , '1123' , '1130' , '1140' , '1150' , '1151' , '1152' , '1153' , '1190' , '5100' , '5110' , '5120' ,
                   '5130' , '5140' , '5150' , '5160' , '5190' , '6100' , '6110' , '6120' , '6130' , '6140' , '6150' , '6160' , '6170' , '6190' , '7120' ),
            '有限责任公司',null),
            if(econ_kind_code IN
                 ( '1200' , '1210' , '1211' , '1212' , '1213' , '1219' , '1220' , '1221' , '1222' , '1223' , '1229' , '5200' , '5210' , '5220' , '5230' , '5240' ,
                   '5290' , '6200' , '6210' , '6220' , '6230' , '6240' , '6250' , '6260' , '6290' , '3300' , '4700' , '7130' ),'股份有限公司',null),
            if(econ_kind_code IN ( '1130' , '1150' , '1151' , '1152' , '1212' , '4500' , '4530' , '4531' , '4532' , '4533' , '4540' ),'私营企业',null),
            if(econ_kind_code IN
                 ( '6000' , '6100' , '6110' , '6120' , '6130' , '6140' , '6150' , '6160' , '6190' , '6200' , '6210' , '6220' , '6230' , '6240' , '6290' , '6300' ,
                   '6310' , '6320' , '6390' , '6400' , '6410' , '6420' , '6430' , '6490' ),'港、澳、台商投资企业',null),
            if(econ_kind_code IN
                 ( '5000' , '5100' , '5110' , '5120' , '5130' , '5140' , '5150' , '5160' , '5190' , '5200' , '5210' , '5220' , '5230' , '5240' , '5290' , '5300' ,
                   '5310' , '5390' , '5400' , '5410' , '5420' , '5430' , '5490' , '5800' , '5810' , '5820' , '5830' , '5840' , '5890' ),'外商投资企业',null),
            if(econ_kind_code IN
                 ( '2000' , '2100' , '2110' , '2120' , '2121' , '2122' , '2123' , '2130' , '2140' , '2150' , '2151' , '2152' , '2153' , '2190' , '2200' , '2210' ,
                   '2211' , '2212' , '2213' , '2219' , '2220' , '2221' , '2222' , '2223' , '2229' , '4300' , '4310' , '4320' , '4330' , '4340' , '4550' , '4551' ,
                   '4552' , '4553' , '4560' , '4660' ),'内资企业分支机构',null),
            if(econ_kind_code IN ( '6800' , '6810' , '6820' , '6830' , '6840' , '6890' ),'港、澳、台商投资企业分支机构',null),
            if(econ_kind_code IN ( '5800' , '5810' , '5820' , '5830' , '5840' , '5890' ),'外商投资企业分支机构',null),
            if(econ_kind_code IN ('9600'),'个体工商户',null),
            if(econ_kind_code IN ( "9900" , "4100" , "4200" , "4400" , "7100" , "7110" , "7190" , "7200" , "7300" , "9100" , "9200" , "9700" ) OR
                 econ_kind_code IS NULL
                OR econ_kind_code = '','其他企业',null)) as econ_kind,
regist_capi,
actual_capi,
scope,
term_start,
term_end,
check_date,
belong_org,
oper_name,
oper_type,
start_date,
status,
type_desc,
title,
longitude,
latitude,
gd_longitude,
gd_latitude,
collegues_num,
created_time,
logo_url,
url,
row_update_time,
district_code,
title_code,
concat_ws('\u0002',
            if(econ_kind_code in ('1110','1140','1213','1223','3100','4110','4210','4410'),'110',null),
            if(econ_kind_code in ('3200','4120','4220','4420'),'120',null),
         if(econ_kind_code in ('3400'),'130',null),
         if(econ_kind_code in ('3500','4600'),'140',null),
         if(econ_kind_code in ('1100','1110','1120','1121','1122','1123','1130','1140','1150','1151','1152','1153','1190','5100','5110','5120','5130','5140','5150','5160','5190','6100','6110','6120','6130','6140','6150','6160','6170','6190','7120'),'150',null),
         if(econ_kind_code in ('1200','1210','1211','1212','1213','1219','1220','1221','1222','1223','1229','5200','5210','5220','5230','5240','5290','6200','6210','6220','6230','6240','6250','6260','6290','3300','4700','7130'),'160',null),
         if(econ_kind_code in ('1130','1150','1151','1152','1212','4500','4530','4531','4532','4533','4540'),'170',null),
         if(econ_kind_code in ('6000','6100','6110','6120','6130','6140','6150','6160','6190','6200','6210','6220','6230','6240','6290','6300','6310','6320','6390','6400','6410','6420','6430','6490'),'200',null),
         if(econ_kind_code in ('5000','5100','5110','5120','5130','5140','5150','5160','5190','5200','5210','5220','5230','5240','5290','5300','5310','5390','5400','5410','5420','5430','5490','5800','5810','5820','5830','5840','5890'),'300',null),
         if(econ_kind_code in ('2000','2100','2110','2120','2121','2122','2123','2130','2140','2150','2151','2152','2153','2190','2200','2210','2211','2212','2213','2219','2220','2221','2222','2223','2229','4300','4310','4320','4330','4340','4550','4551','4552','4553','4560','4660'),'996',null),
         if(econ_kind_code in ('6800','6810','6820','6830','6840','6890'),'997',null),
         if(econ_kind_code in ('5800','5810','5820','5830','5840','5890'),'998',null),
         if(econ_kind_code in ('9600'),'400',null),
         if(econ_kind_code in ("9900", "4100", "4200", "4400", "7100", "7110", "7190", "7200", "7300", "9100", "9200", "9700") or econ_kind_code is null
             or econ_kind_code='','999',null)) as econ_kind_code,
regist_capi_new,
currency_unit,
revoke_reason,
revoke_date,
logout_reason,
logout_date,
revoked_certificates,
new_status_code,
u_tags,
organization_code,
a.industry_code,
a.industry_name,
a.series,
a.industry_standard
from
db_qkgp.db_enterpriset_enterprise t
left join a
on t.eid=a.eid
where length(trim(nvl(t.eid,'')))>0 and `longitude`>-180 and `longitude`<180 and `gd_longitude`>-180 and
`gd_longitude`<180 and `latitude`>-90 and `latitude`<90 and `gd_latitude`>-90 and `gd_latitude`<90 and u_tags != '2';

