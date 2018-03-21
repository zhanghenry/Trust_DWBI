select rowid,t.* from dim_pb_project_basic t where t.c_proj_code = 'AVICTC2012X0297'; 

select rowid,t.* from dim_pb_product t where t.l_proj_id in (3454);

select rowid, t1.*
  from dim_tc_contract t1
 where t1.l_prod_id in
       (select t.l_prod_id from dim_pb_product t where t.l_proj_id in (3454));

select rowid, t1.*
  from dim_ic_contract t1
 where t1.l_prod_id in
       (select t.l_prod_id from dim_pb_product t where t.l_proj_id in (3454));
       
select  rowid,t.* from dim_to_book t where t.l_proj_id in (3454);
