with temp_prod as
 (select b.l_prod_id,
         sum(case
               when c.c_scatype_code = '50' then
                a.f_scale
               else
                0
             end) as f_50,
         sum(a.f_scale) as f_cx
    from tt_tc_scale_flow_d a, dim_tc_contract b, dim_sr_scale_type c
   where a.l_cont_id = b.l_cont_id
     and a.l_scatype_id = c.l_scatype_id
   group by b.l_prod_id),
temp_cont as
 (select c.c_cust_code,
         c.c_cust_name,
         c.l_cust_id,
         b.l_prod_id,
         sum(a.f_scale) as f_cy
    from tt_tc_scale_flow_d a, dim_tc_contract b, dim_ca_customer c
   where a.l_cont_id = b.l_cont_id
     and A.L_CHANGE_DATE <= 20160630
     and b.l_settler_id = c.l_cust_id
     and c.c_cust_type = '2'
   group by c.c_cust_code, c.c_cust_name, c.l_cust_id, b.l_prod_id),
temp_cust as
 (select tt.*, row_number() over(order by tt.f_cy desc) as l_rn
    from (select c.l_cust_id, c_cust_name, sum(a.f_scale) as f_cy
            from tt_tc_scale_flow_d a, dim_tc_contract b, dim_ca_customer c
           where a.l_cont_id = b.l_cont_id
             and A.L_CHANGE_DATE <= 20160630
             and b.l_settler_id = c.l_cust_id
             and c.c_cust_type = '2'
           group by c.l_cust_id, c_cust_name) tt)
select t1.c_cust_code,
       t1.c_cust_name,
       t3.c_prod_code,
       t3.c_prod_name,
       t1.f_cy,
       t2.f_50,
       t2.f_cx
  from temp_cont t1, temp_prod t2, dim_pb_product t3, temp_cust t4
 where t1.l_prod_id = t2.l_prod_id
   and t2.l_prod_id = t3.l_prod_id
   and t1.l_cust_id = t4.l_cust_id --and t4.l_rn <= 50
;