--查看是否存在未合并掉的多余客户
select a.c_custno, a.c_identitytype, b.c_custno, b.c_identitytype
  from tcustomerinfo a, tcustomerinfo b
 where (a.c_custtype = b.c_custtype and a.c_custname = b.c_custname)
   and a.c_custno <> b.c_custno
   and exists (select 1
          from tcommon_merge c
         where b.c_custno = c.c_custnocurr
           and a.c_custno = c.c_custnoold);
