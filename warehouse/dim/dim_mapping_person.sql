create table if not exists dim_mapping_person(
    uid STRING COMMENT '映射前uid' ,
    uid_mapped STRING COMMENT '映射后pid'
)
comment '企业名称和id映射表'
STORED AS ORC;

insert overwrite table dim_mapping_person
select
uid,
uid_mapped
from db_qkgp.std_mapping_person;