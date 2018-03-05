--会计科目表
select t.c_id         as c_subid, --科目id
       t.c_number     as c_subcode, --科目代码
       t.c_name       as c_subname, --科目名称
       t1.c_number    as l_class, --科目分类
       0              as c_fundid, --账套id
       t.f_dc         as l_baldir, --余额方向
       t.f_level      as l_level, --科目级次
       t.f_isleaf     as l_leaf, --是否明细
       t.c_currencyid as c_cykind, --币种代码
       t.c_parentid   as c_fsubcode --父级科目
  from ts_ea_accountview t, ts_ea_accounttype t1
 where t.c_accounttypeid = t1.c_id;

--公司所属科目及科目可辅助对象
select t3.fname_l2, t2.fname_l2, t1.*
  from T_BD_AccountView t1, T_BD_ASSTACCOUNT t2, T_ORG_Company t3
 where t1.fcaa = t2.fid
   and t1.fcompanyid = t3.fid
   and t1.fnumber like '6001%'
   and t3.fname_l2 like '%信托%';

--辅助核算组合
select t.fid, t.fasstaccountid, t1.fname_l2, t.fproviderid, t.fcostorgid,
       t2.fname_l2, t.fcontrolunitid, t.fgeneralassacttype6id, t3.fnumber,
       t3.fname_l2
  from T_BD_AssistantHG t, T_BD_ASSTACCOUNT t1, t_org_costcenter t2,
       t_bd_generalasstacttype t3
 where t.fasstaccountid = t1.fid
   and t.fcostorgid = t2.fid
   and t.fgeneralassacttype6id = t3.fid
   and t.fid = 'WuUAAAAG0UFBimy7';   

--凭证分录表--EAS
SELECT T.FID AS C_JOURID, --分录ID
       T.FBILLID AS C_VOUCHERID, --凭证ID
       0 AS C_FUNDID, --账套ID
       T1.FBIZDATE AS D_BUSI, --业务日期
       T1.FDESCRIPTION AS C_DIGEST, --凭证摘要
       T.FSEQ AS L_ROWID, --分录号
       T2.FNUMBER AS C_SUBCODE, --科目代码
       T2.FNAME_L2 AS C_SUBNAME, --科目名称
       T.FENTRYDC AS L_BALDIR, --余额方向
       DECODE(T.FENTRYDC, 1, T.FLOCALAMOUNT, 0) AS F_DEBIT, --本币借方
       DECODE(T.FENTRYDC, 0, T.FLOCALAMOUNT, 0) AS F_CREDIT, --本币贷方
       T4.FNUMBER AS C_CYKIND, --币种代码
       NULL AS F_EXCH, --汇率
       T.FORIGINALAMOUNT AS F_FOREIGN, --外币金额
       T1.FBIZSTATUS AS L_STATE, --凭证状态
       T3.FPERIODYEAR AS L_YEAR, --会计年度
       T3.FPERIODNUMBER AS L_MONTH, --会计月份
       NULL AS C_COMBID --组合ID
  FROM T_GL_VOUCHERENTRY T,
       T_GL_VOUCHER      T1,
       T_BD_ACCOUNTVIEW  T2,
       T_BD_PERIOD       T3,
       T_BD_CURRENCY     T4,
       T_ORG_COMPANY     T5
 WHERE T.FBILLID = T1.FID
   AND T.FACCOUNTID = T2.FID
   AND T1.FPERIODID = T3.FID
   AND T.FCURRENCYID = T4.FID
   AND T1.FCOMPANYID = T5.FID
   AND T5.FNUMBER = 'ZRT';

--凭证分录表--TS
select t.c_id            as c_jourid, --分录id
       t.c_billid        as c_voucherid, --凭证id
       0                 as c_fundid, --账套id
       t1.d_bizdate      as d_busi, --业务日期
       t1.c_description  as c_digest, --凭证摘要
       t.f_seq           as l_rowid, --分录号
       t2.c_number       as c_subcode, --科目代码
       t2.c_name         as c_subname, --科目名称
       t.f_entrydc       as l_baldir, --余额方向
       0                 as f_debit, --本币借方
       0                 as f_credit, --本币贷方
       t4.c_number       as c_cykind, --币种代码
       null              as f_exch, --汇率
       null              as f_foreign, --外币金额
       t1.f_bizstatus    as l_state, --凭证状态
       t3.f_periodyear   as l_year, --会计年度
       t3.f_periodnumber as l_month, --会计月份
       null              as c_combid --组合id
  from ts_ea_voucherent  t,
       ts_ea_voucher     t1,
       ts_ea_accountview t2,
       ts_ea_period      t3,
       ts_ea_currency    t4
 where t.c_billid = t1.c_id
   and t.c_accountid = t2.c_id
   and t1.c_periodid = t3.c_id
   and t.c_currencyid = t4.c_id;

--核算明细--EAS
SELECT T1.FID AS C_DTLID, --明细ID
       T1.FENTRYID AS C_JOURID, --分录ID
       T1.FSEQ AS C_INSEQNO, --核算序号
       T3.FNUMBER AS C_DEPTNO, --部门编号
       T2.FACCOUNTCUSSENTID AS C_CLIENTNO, --往来单位,都为空
       T8.FNUMBER AS C_STAFFNO, --员工编号
       T4.FNUMBER AS C_PRODCODE, --产品编号
       T9.FNUMBER AS C_BANKACCNO, --账户编号
       NULL AS L_BALDIR, --余额方向
       DECODE(T5.FENTRYDC, 1, T1.FLOCALAMOUNT, 0) AS F_DEBIT, --本币借方
       DECODE(T5.FENTRYDC, 0, T1.FLOCALAMOUNT, 0) AS F_CREDIT --本币贷方
  FROM T_GL_VOUCHERASSISTRECORD T1,
       T_BD_ASSISTANTHG         T2,
       T_ORG_COSTCENTER         T3,
       T_BD_GENERALASSTACTTYPE  T4,
       T_GL_VOUCHERENTRY        T5,
       T_GL_VOUCHER             T6,
       T_ORG_COMPANY            T7,
       T_BD_PERSON              T8,
       T_BD_ACCOUNTBANKS        T9
 WHERE T1.FASSGRPID = T2.FID
   AND T2.FCOSTORGID = T3.FID(+) --部门
   AND T2.FGENERALASSACTTYPE6ID = T4.FID(+) --产品
   AND T2.FPERSONID = T8.FID(+) --员工
   AND T2.FBANKACCOUNTID = T9.FID(+) --银行账户 
   AND T1.FENTRYID = T5.FID
   AND T1.FBILLID = T6.FID
   AND T6.FCOMPANYID = T7.FID
   AND T7.FNUMBER = 'ZRT';


--辅项分类表
select t.c_id     as c_classid, --分类id
       t.c_number as c_classno, --分类编号
       t.c_name   as c_classname, --分类名称
       null       as c_fclassid, --父类id
       null       as c_remark --备注
  from ts_ea_generalasstacttypegrp t;

--部门信息表--EAS
select t.fid       as c_deptid, --部门id
       t.fnumber   as c_deptcode, --部门编号
       t.fname_l2     as c_deptname, --部门名称
       t.fparentid as c_parentid, --上级部门id
       t.fisstart  as c_isvoid, --是否失效
  from t_org_admin t;  
  
--部门信息表
select t.c_id       as c_deptid, --部门id
       t.c_number   as c_deptcode, --部门编号
       t.c_name     as c_deptname, --部门名称
       t.c_parentid as c_parentid, --上级部门id
       t.f_isstart  as c_isvoid --是否失效
  from ts_ea_admin t;

--员工信息--EAS
select t.fid          as c_staffid, --员工d
       t1.fid        as c_deptid, --所属部门d
       t.fnumber      as c_staffcode, --员工号
       t.fname_l2     as c_staffname, --员工名称
       null           as c_idtype, --证件类型，员工默认为身份证
       t.fidcardno    as c_idcard, --证件号码
       null           as c_ctqcno, --从业资格证号
       null           as c_posting, --职务，可以关联，但会存在多个职务的情况，暂时放空
       null           as c_issenior, --是否高管
       null           as c_nostaff, --是否无编制
       t.fstate       as c_status, --在职状态
       t.fcell        as c_mobile, --手机
       t.fofficephone as c_tel, --电话
       t.femail       as c_email, --邮箱
       null           as c_msgmode, --消息方式
       null           as c_remark --备注
  from t_bd_person t, t_org_admin t1
 where t.fhrorgunitid = t1.fid;  
  
--员工信息
select t.fid          as c_staffid, --员工d
       t1.c_id        as c_deptid, --所属部门d
       t.fnumber      as c_staffcode, --员工号
       t.fname_l2     as c_staffname, --员工名称
       null           as c_idtype, --证件类型，员工默认为身份证
       t.fidcardno    as c_idcard, --证件号码
       null           as c_ctqcno, --从业资格证号
       null           as c_posting, --职务，可以关联，但会存在多个职务的情况，暂时放空
       null           as c_issenior, --是否高管
       null           as c_nostaff, --是否无编制
       t.fstate       as c_status, --在职状态
       t.fcell        as c_mobile, --手机
       t.fofficephone as c_tel, --电话
       t.femail       as c_email, --邮箱
       null           as c_msgmode, --消息方式
       null           as c_remark --备注
  from ts_ea_person t, ts_ea_admin t1
 where t.fhrorgunitid = t1.c_id
   and t.fid = t2.fpersonid;

--产品信息

--银行账户
select t.c_id                as c_accid, --账户id
       t.c_name              as c_accname, --帐户名称
       t.c_bankaccountnumber as c_accno, --帐户账号
       t1.c_name             as c_orgname, --开户机构名称
       t.c_bank              as c_headbankno, --开户总行编号
       t.f_isclosed          as c_isvoid --是否失效
  from ts_ea_accountbanks t, ts_ea_company t1
 where t.c_companyid = t1.c_id;
