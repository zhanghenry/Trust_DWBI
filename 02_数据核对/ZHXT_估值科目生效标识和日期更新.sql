select t.l_expiration_date, count(*)
  from dim_to_subject t
 group by t.l_expiration_date;

select a.c_subj_code, b.c_book_code, a.l_effective_date
  from dim_to_subject a, dim_to_book b
 where a.l_book_id = b.l_book_id
 group by a.c_subj_code, b.c_book_code, a.l_effective_date
having count(*) > 1;

select a.c_subj_code, a.*, b.c_book_code, a.l_effective_date
  from dim_to_subject a, dim_to_book b
 where a.l_book_id = b.l_book_id
   and a.c_subj_code = '1131030301TQ7370'
   and b.c_book_code = '102432';
   
select t.l_expiration_date,count(*) from dim_to_book t group by t.l_expiration_date ;

select t.c_book_code,count(*) from dataedw.dim_to_book t group by t.c_book_code having count(*) > 1 ;

select distinct t.l_effective_date from dataedw.dim_to_book t;

select rowid,t.* from dataedw.dim_to_book t where t.c_book_code = '202508';

select * from datadock.tfa_book t where t.c_book_code = '202505';

select * from datadock.tfa_book t where t.d_write_on is null;

select * from dataedw.tt_to_accounting_subj_d;

update dataedw.dim_to_book a
   set a.l_effective_date =
       (select to_number(to_char(b.d_write_on, 'yyyymmdd'))
          from datadock.tfa_book b
         where a.c_book_code = b.c_book_code and b.d_write_on is not null)
 where a.c_book_code in (select t.c_book_code
                           from dataedw.dim_to_book t
                          group by t.c_book_code
                         having count(*) = 1) and a.c_book_code <> '202954';

select * from dataedw.dim_to_book a where not exists(select 1 from datadock.tfa_book b where a.c_book_code = b.c_book_code);

select rowid,t.* from dataedw.dim_to_book t where t.c_book_code in (
select a.c_book_code/*,b.c_proj_code*//*,a.l_effective_date*/
  from dataedw.dim_to_book a, dataedw.dim_pb_project_basic b
 where a.l_proj_id = b.l_proj_id
 group by a.c_book_code,b.c_proj_code/*,a.l_effective_date*/
having count(*) > 1);

update dim_to_subject t set t.l_book_id = 2984 where t.l_book_id = 2528 and t.l_effective_date = 20170523;

update dim_to_subject t set t.l_effective_flag = 0 where t.l_book_id = 931 ;
update dim_to_subject t set t.l_effective_flag = 1 where t.l_book_id = 3075 ;
update dim_to_subject t set t.l_effective_flag = 0 where t.l_book_id = 2461 ;
update dim_to_subject t set t.l_effective_flag = 1 where t.l_book_id = 3110 ;
update dim_to_subject t set t.l_effective_flag = 0 where t.l_book_id = 2464 ;
update dim_to_subject t set t.l_effective_flag = 1 where t.l_book_id = 3108 ;
update dim_to_subject t set t.l_effective_flag = 0 where t.l_book_id = 2426 ;
update dim_to_subject t set t.l_effective_flag = 1 where t.l_book_id = 3109 ;
update dim_to_subject t set t.l_effective_flag = 0 where t.l_book_id = 2526 ;
update dim_to_subject t set t.l_effective_flag = 1 where t.l_book_id = 2983 ;
update dim_to_subject t set t.l_effective_flag = 0 where t.l_book_id = 2528 ;
update dim_to_subject t set t.l_effective_flag = 1 where t.l_book_id = 2984 ;

select t.l_effective_date,t.c_book_code,t.* from dim_to_book t where t.c_book_code = '305001';
select * from dim_to_book t where t.l_book_id = 931;
select * from dim_to_subject t where t.l_book_id = 931;

select t.c_book_code,min(t.l_book_id) as l_min_id,max(t.l_book_id) as l_max_id  from dataedw.dim_to_book t where t.c_book_code in (
select a.c_book_code
  from dataedw.dim_to_book a, dataedw.dim_pb_project_basic b
 where a.l_proj_id = b.l_proj_id
 group by a.c_book_code,b.c_proj_code
having count(*) > 1) group by t.c_book_code;
