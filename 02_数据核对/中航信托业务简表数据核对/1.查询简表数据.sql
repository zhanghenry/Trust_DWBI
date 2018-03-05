truncate table temp_20180222_01;
drop table temp_20180222_01;
create table temp_20180222_01 as 
select c_proj_code,sum(f_cxgm) as f_cxgm  from (
with temp_xmbm as
 (select t1.d_file, t1.c_file_code, t1.l_row_axis, t1.c_value as c_proj_code
    from datadock.tsg_file_value t1
   where (t1.c_item_code, t1.c_file_code, t1.l_column_axis) in
         (select t2.c_item_code, t2.c_file_code, t2.l_column_axis
            from datadock.tsg_file_item t2
           where t2.c_item_name = '项目编码'
           and t2.c_file_code = '业务简表20171231.xls')
     and t1.l_row_axis <> 4098),
temp_cxgm as
 (select t1.d_file,
         t1.c_file_code,
         t1.l_row_axis,
         to_number(t1.c_value) as f_cxgm
    from datadock.tsg_file_value t1
   where (t1.c_item_code, t1.c_file_code, t1.l_column_axis) in
         (select t2.c_item_code, t2.c_file_code, t2.l_column_axis
            from datadock.tsg_file_item t2
           where t2.c_item_name = '项目实收资本额'
           and t2.c_file_code  = '业务简表20171231.xls')
     and t1.l_row_axis <> 4098)
select tp1.c_proj_code, tp2.f_cxgm
  from temp_xmbm tp1, temp_cxgm tp2
 where /*tp1.d_file = tp2.d_file(+)
   and */tp1.c_file_code = tp2.c_file_code(+)
   and tp1.l_row_axis = tp2.l_row_axis(+)) group by c_proj_code;
   
truncate table temp_20180222_03;
drop table temp_20180222_03;
create table temp_20180222_03 as 
select c_proj_code,sum(f_xtsr) as f_xtsr,sum(f_xtbc) as f_xtbc,sum(f_xtcgf) as f_xtcgf  from (
with temp_xmbm as
 (select t1.d_file, t1.c_file_code, t1.l_row_axis, t1.c_value as c_proj_code
    from datadock.tsg_file_value t1
   where (t1.c_item_code, t1.c_file_code, t1.l_column_axis) in
         (select t2.c_item_code, t2.c_file_code, t2.l_column_axis
            from datadock.tsg_file_item t2
           where t2.c_item_name = '项目编码'
           and t2.c_file_code = '业务简表20171231.xls')
     and t1.l_row_axis <> 4098),
temp_xtsr as
 (select t1.d_file,
         t1.c_file_code,
         t1.l_row_axis,
         to_number(t1.c_value) as f_xtsr
    from datadock.tsg_file_value t1
   where (t1.c_item_code, t1.c_file_code, t1.l_column_axis) in
         (select t2.c_item_code, t2.c_file_code, t2.l_column_axis
            from datadock.tsg_file_item t2
           where t2.c_item_name = '合同总收入(信托报酬+财务顾问收入)'
           and t2.c_file_code = '业务简表20171231.xls')
     and t1.l_row_axis <> 4098),
temp_xtbc as
 (select t1.d_file,
         t1.c_file_code,
         t1.l_row_axis,
         to_number(t1.c_value) as f_xtbc
    from datadock.tsg_file_value t1
   where (t1.c_item_code, t1.c_file_code, t1.l_column_axis) in
         (select t2.c_item_code, t2.c_file_code, t2.l_column_axis
            from datadock.tsg_file_item t2
           where t2.c_item_name = '信托报酬收入')
     and t1.l_row_axis <> 4098),
temp_xtcgf as
 (select t1.d_file,
         t1.c_file_code,
         t1.l_row_axis,
         to_number(t1.c_value) as f_xtcgf
    from datadock.tsg_file_value t1
   where (t1.c_item_code, t1.c_file_code, t1.l_column_axis) in
         (select t2.c_item_code, t2.c_file_code, t2.l_column_axis
            from datadock.tsg_file_item t2
           where t2.c_item_name = '合同财务顾问收入')
     and t1.l_row_axis <> 4098)
select tp1.c_proj_code, tp2.f_xtsr,tp3.f_xtbc,tp4.f_xtcgf
  from temp_xmbm tp1, temp_xtsr tp2,temp_xtbc tp3,temp_xtcgf tp4
 where /*tp1.d_file = tp2.d_file(+)
   and */tp1.c_file_code = tp2.c_file_code(+)
   and tp1.l_row_axis = tp2.l_row_axis(+)
   and tp1.l_row_axis = tp3.l_row_axis(+)
   and tp1.l_row_axis = tp4.l_row_axis(+)
   ) group by c_proj_code;
   
truncate table temp_20180222_05;
drop table temp_20180222_05;
create table temp_20180222_05 as 
select c_proj_code,sum(f_qsgm) as f_qsgm  from (
with temp_xmbm as
 (select t1.d_file, t1.c_file_code, t1.l_row_axis, t1.c_value as c_proj_code
    from datadock.tsg_file_value t1
   where (t1.c_item_code, t1.c_file_code, t1.l_column_axis) in
         (select t2.c_item_code, t2.c_file_code, t2.l_column_axis
            from datadock.tsg_file_item t2
           where t2.c_item_name = '项目编码'
           and t2.c_file_code = '业务简表20171231-清算.xls')
     and t1.l_row_axis <> 502),
temp_qsgm as
 (select t1.d_file,
         t1.c_file_code,
         t1.l_row_axis,
         to_number(t1.c_value) as f_qsgm
    from datadock.tsg_file_value t1
   where (t1.c_item_code, t1.c_file_code, t1.l_column_axis) in
         (select t2.c_item_code, t2.c_file_code, t2.l_column_axis
            from datadock.tsg_file_item t2
           where t2.c_item_name = '累计还本'
           and t2.c_file_code  = '业务简表20171231-清算.xls')
     and t1.l_row_axis <> 502)
select tp1.c_proj_code, tp2.f_qsgm
  from temp_xmbm tp1, temp_qsgm tp2
 where /*tp1.d_file = tp2.d_file(+)
   and */tp1.c_file_code = tp2.c_file_code(+)
   and tp1.l_row_axis = tp2.l_row_axis(+)) group by c_proj_code;
   
truncate table temp_20180222_07;
drop table temp_20180222_07;
create table temp_20180222_07 as 
select c_proj_code,count(*) as f_xzgs from (
with temp_xmbm as
 (select t1.d_file, t1.c_file_code, t1.l_row_axis, t1.c_value as c_proj_code
    from datadock.tsg_file_value t1
   where (t1.c_item_code, t1.c_file_code, t1.l_column_axis) in
         (select t2.c_item_code, t2.c_file_code, t2.l_column_axis
            from datadock.tsg_file_item t2
           where t2.c_item_name = '项目编码'
           and t2.c_file_code = '业务简表20171231.xls')
     and t1.l_row_axis <> 4098),
temp_sfxz as
 (select t1.d_file, t1.c_file_code, t1.l_row_axis, t1.c_value as l_sfxz
    from datadock.tsg_file_value t1
   where (t1.c_item_code, t1.c_file_code, t1.l_column_axis) in
         (select t2.c_item_code, t2.c_file_code, t2.l_column_axis
            from datadock.tsg_file_item t2
           where t2.c_item_name = '是否新增'
           and t2.c_file_code = '业务简表20171231.xls')
     and t1.l_row_axis <> 4098),
temp_htrq as
 (select t1.d_file, t1.c_file_code, t1.l_row_axis, t1.c_value as c_htks
    from datadock.tsg_file_value t1
   where (t1.c_item_code, t1.c_file_code, t1.l_column_axis) in
         (select t2.c_item_code, t2.c_file_code, t2.l_column_axis
            from datadock.tsg_file_item t2
           where t2.c_item_name = '合同起点时间'
           and t2.c_file_code = '业务简表20171231.xls')
     and t1.l_row_axis <> 4098)
select tp1.c_proj_code,tp3.c_htks
  from temp_xmbm tp1,temp_sfxz tp2,temp_htrq tp3
 where /*tp1.d_file = tp2.d_file(+)
   and */tp1.c_file_code = tp2.c_file_code
   and tp1.l_row_axis = tp2.l_row_axis
   and tp1.c_file_code = tp3.c_file_code
   and tp1.l_row_axis = tp3.l_row_axis
   and substr(tp3.c_htks,1,4) = '2017'
   ) group by c_proj_code;


truncate table temp_20180222_09;
drop table temp_20180222_09;
create table temp_20180222_09 as 
select c_proj_code,sum(f_xzgm) as f_xzgm from (
with temp_xmbm as
 (select t1.d_file, t1.c_file_code, t1.l_row_axis, t1.c_value as c_proj_code
    from datadock.tsg_file_value t1
   where (t1.c_item_code, t1.c_file_code, t1.l_column_axis) in
         (select t2.c_item_code, t2.c_file_code, t2.l_column_axis
            from datadock.tsg_file_item t2
           where t2.c_item_name = '项目编码'
           and t2.c_file_code = '业务简表20171231.xls')
     and t1.l_row_axis <> 4098),
temp_htrq as
 (select t1.d_file, t1.c_file_code, t1.l_row_axis, t1.c_value as c_htks
    from datadock.tsg_file_value t1
   where (t1.c_item_code, t1.c_file_code, t1.l_column_axis) in
         (select t2.c_item_code, t2.c_file_code, t2.l_column_axis
            from datadock.tsg_file_item t2
           where t2.c_item_name = '合同起点时间'
           and t2.c_file_code = '业务简表20171231.xls')
     and t1.l_row_axis <> 4098),
temp_xzgm as
 (select t1.d_file,
         t1.c_file_code,
         t1.l_row_axis,
         to_number(t1.c_value) as f_xzgm
    from datadock.tsg_file_value t1
   where (t1.c_item_code, t1.c_file_code, t1.l_column_axis) in
         (select t2.c_item_code, t2.c_file_code, t2.l_column_axis
            from datadock.tsg_file_item t2
           where t2.c_item_name = '项目实收资本额'
           and t2.c_file_code  = '业务简表20171231.xls')
     and t1.l_row_axis <> 4098)
select tp1.c_proj_code,tp3.c_htks,tp4.f_xzgm
  from temp_xmbm tp1,temp_htrq tp3,temp_xzgm tp4
 where /*tp1.d_file = tp2.d_file(+)
   and */tp1.c_file_code = tp3.c_file_code
   and tp1.l_row_axis = tp3.l_row_axis
   and tp1.c_file_code = tp4.c_file_code(+)
   and tp1.l_row_axis = tp4.l_row_axis(+)
   and substr(tp3.c_htks,1,4) = '2017'
   ) group by c_proj_code;
