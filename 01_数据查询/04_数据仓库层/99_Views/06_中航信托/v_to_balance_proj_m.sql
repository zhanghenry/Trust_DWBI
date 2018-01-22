create or replace view v_to_balance_proj_m as
select tt."L_MONTH_ID",tt."C_BOOK_CODE",tt."L_BOOK_ID",tt."L_PROJ_ID",tt."L_PROD_ID",tt."ÕËÌ×±àºÅ(FA)",tt."F_BALANCE_SCALE",tt."F_BALANCE_ZC",tt."F_BALANCE_DK",sum(tt.f_balance_zc)over(partition by tt.l_proj_id)  as f_proj_balance_zc from (
select to3.l_month_id, to1.c_book_code, to1.l_book_id, to1.l_proj_id, to1.l_prod_id,
       to1.c_book_code as "ÕËÌ×±àºÅ(FA)",
       sum(case when to2.c_subj_code_l1 = '4001' and to2.c_subj_code_l2 <> '400100' then to3.f_balance_agg else 0 end)                              as f_balance_scale,
       sum(case when to2.c_subj_code_l1 in ('1101', '1111', '1303', '1501','1503','1531','1541','1122','1511') then to3.f_balance_agg else 0 end) as f_balance_zc,
       sum(case when to2.c_subj_code_l1 in ('1303') then to3.f_balance_agg else 0 end)                                                            as f_balance_dk
  from dim_to_book to1, dim_to_subject to2, tt_to_accounting_subj_m to3
 where to1.l_book_id = to2.l_book_id
   and to1.l_book_id = to3.l_book_id
   and to2.l_subj_id = to3.l_subj_id
   and substr(to2.l_effective_date, 1, 6) <= to3.l_month_id
   and substr(to2.l_expiration_date, 1, 6) > to3.l_month_id
   --and to2.l_effective_flag = 1
   and to3.l_month_id = 201707
 group by to3.l_month_id, to1.c_book_code,to1.l_book_id,to1.l_proj_id,to1.l_prod_id,to1.c_book_code) tt;
