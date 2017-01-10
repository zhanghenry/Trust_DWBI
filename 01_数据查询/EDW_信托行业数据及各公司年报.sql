--信托年报数据查询
select * from dim_ti_report_parser t order by t.l_report_id;
select * from dim_fi_statement t where t.l_statement_id in (1000,2000,3000,4000);
select * from dim_fi_statement_item t order by t.l_item_id ;
select * from dim_ti_revenue;
select * from dim_ti_trust_props;
select * from dim_ti_company;

--资产负债表
select r.c_name_abbr, s.l_statement_id, s.c_item_name, t.*
  from tt_ti_statement_comp_y t, dim_fi_statement_item s, dim_ti_company r
 where t.l_item_id = s.l_item_id
   and t.l_comp_id = r.l_comp_id and s.l_statement_id = 1000 and r.c_name_abbr = '陆家嘴信托' and t.l_year_id = 2015
 order by r.l_comp_id, t.l_year_id,s.l_statement_id, s.l_item_id;

--利润表
select r.c_name_abbr, s.l_statement_id, s.c_item_name, t.*
  from tt_ti_statement_comp_y t, dim_fi_statement_item s, dim_ti_company r
 where t.l_item_id = s.l_item_id
   and t.l_comp_id = r.l_comp_id and s.l_statement_id = 2000 and r.c_name_abbr = '陆家嘴信托' and t.l_year_id = 2015
 order by r.l_comp_id, t.l_year_id,s.l_statement_id, s.l_item_id;

--信托资产负债表
select r.c_name_abbr, s.l_statement_id, s.c_item_name, t.*
  from tt_ti_statement_comp_y t, dim_fi_statement_item s, dim_ti_company r
 where t.l_item_id = s.l_item_id
   and t.l_comp_id = r.l_comp_id and s.l_statement_id = 3000 and r.c_name_abbr = '民生信托' and t.l_year_id = 2015
 order by r.l_comp_id, t.l_year_id,s.l_statement_id, s.l_item_id;

--信托利润表
select r.c_name_abbr, s.l_statement_id, s.c_item_name, t.*
  from tt_ti_statement_comp_y t, dim_fi_statement_item s, dim_ti_company r
 where t.l_item_id = s.l_item_id
   and t.l_comp_id = r.l_comp_id and s.l_statement_id = 4000 and r.c_name_abbr = '民生信托' and t.l_year_id = 2015
 order by r.l_comp_id, t.l_year_id,s.l_statement_id, s.l_item_id;

--信托收入情况
select r.c_name_abbr, s.c_revenue_name, t.*
  from tt_ti_revenue_comp_y t, dim_ti_revenue s, dim_ti_company r
 where t.l_comp_id = r.l_comp_id
   and t.l_revenue_id = s.l_revenue_id
 order by t.l_comp_id, t.l_year_id, t.l_revenue_id;

--存续项目
select r.c_name_abbr, s.c_props_name, t.*
  from tt_ti_exiproj_comp_y t, dim_ti_trust_props s, dim_ti_company r
 where t.l_comp_id = r.l_comp_id
   and t.l_props_id = s.l_props_id
 order by r.l_comp_id,t.l_year_id,s.l_props_id;

--清算项目
select r.c_name_abbr, s.c_props_name, t.*
  from tt_ti_cleproj_comp_y t, dim_ti_trust_props s, dim_ti_company r
 where t.l_comp_id = r.l_comp_id
   and t.l_props_id = s.l_props_id /*and t.l_comp_id = 56 and t.l_year_id = 2015 and t.l_props_id = 4*/
 order by r.l_comp_id,t.l_year_id,s.l_props_id;
 
--新增项目
select r.c_name_abbr, s.c_props_name, t.*
  from tt_ti_newproj_comp_y t, dim_ti_trust_props s, dim_ti_company r
 where t.l_comp_id = r.l_comp_id
   and t.l_props_id = s.l_props_id
 order by r.l_comp_id,t.l_year_id,s.l_props_id;
