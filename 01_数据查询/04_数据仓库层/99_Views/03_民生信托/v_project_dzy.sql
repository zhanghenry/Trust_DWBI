create or replace view v_project_dzy as
select l_proj_id,
       case
         when count(*) > 1 then
          9 --9组合（两个及以上分为组合）
         when count(*) = 1 and max(C_GUARAWAY) = 1 then
          1 --1质押
         when count(*) = 1 and max(C_GUARAWAY) = 2 then
          2 --2抵押
         when count(*) = 1 and max(C_GUARAWAY) = 4 then
          3 --3信用
         else
          0 --0无担保
       end C_GUARAWAY,
        case
         when count(*) > 1 then
         '组合'
         when count(*) = 1 and max(C_GUARAWAY) = 1 then
          '质押'
         when count(*) = 1 and max(C_GUARAWAY) = 2 then
          '抵押'
         when count(*) = 1 and max(C_GUARAWAY) = 4 then
          '信用'
         else
          '无担保'
       end C_GUARAWAYNAME
  from (select distinct d.l_proj_id,
                        case
                          when d.c_coll_cate in ('3', '5') then
                           1 --1质押
                          when d.c_coll_cate = '2' then
                           2 --2抵押
                          when d.c_coll_cate = '4' then
                           4 --4信用
                          else
                           null
                        end C_GUARAWAY
          from dim_ic_collateral d )
 group by l_proj_id;
